from __future__ import annotations

import copy
from dataclasses import dataclass
from pathlib import Path
from typing import Optional

from bitarray import bitarray

from .coverage import AggregatedCoverage, Coverage, CoverageStat


@dataclass
class FileMapping:
    file_name: str
    line_numbers: list[str]
    branch_numbers: list[str]
    fns: list[str]
    fnda: list[str]

    @classmethod
    def empty(cls) -> FileMapping:
        return cls(
            file_name="",
            line_numbers=[],
            branch_numbers=[],
            fns=[],
            fnda=[],
        )


@dataclass
class FastCoverage:
    files: dict[str, FastFileCov]

    @classmethod
    def empty(cls) -> FastCoverage:
        return cls(files={})

    def is_empty(self) -> bool:
        return not self.files

    def to_dict(self) -> dict:
        return {
            "files": {file_name: file_cov.to_dict() for file_name, file_cov in self.files.items()},
        }

    def convert_to_lcov(self) -> str:
        lcov_lines = []
        for file_cov in self.files.values():
            lcov_lines.extend(file_cov.convert_to_lcov_lines())
        return "\n".join(lcov_lines)

    def convert_to_other_mapping(self, other: FastCoverage):
        to_remove = []
        for file_name, file_cov in self.files.items():
            if file_name in other.files:
                file_cov.convert_to_other_mapping(other.files[file_name])
            else:
                # If the file is not in other, we ignore it
                to_remove.append(file_name)

        for file_name in to_remove:
            del self.files[file_name]

        for file_name, file_cov in other.files.items():
            # This file is not covered by self
            if file_name not in self.files:
                clean_copy = copy.deepcopy(file_cov)
                clean_copy.clear()
                self.files[file_name] = clean_copy

    def copy_mappings(self, other: FastCoverage) -> None:
        """Directly copy mappings from `other` to `self`. Could invalidate the current coverage."""
        for file_name, file_cov in self.files.items():
            if file_name in other.files:
                file_cov.mapping = other.files[file_name].mapping

    @classmethod
    def parse_lcov(
        cls,
        lcov_path: str | Path,
        root: str = "",
        ignore_files: list[str] = [],
        keep_only: list[str] = [],
    ) -> FastCoverage:
        lcov_lines = Path(lcov_path).read_text().splitlines()

        files: dict[str, FastFileCov] = {}
        parsing_file = ""
        curr_file = FastFileCov.empty()
        continue_to_next_file = False

        for line in lcov_lines:
            if line.startswith("SF:"):
                continue_to_next_file = False
                parsing_file = line[3:]

                for to_keep in keep_only:
                    if to_keep not in parsing_file:
                        parsing_file = ""
                        continue_to_next_file = True
                        break

                for to_ignore in ignore_files:
                    if to_ignore in parsing_file:
                        continue_to_next_file = True
                        break

                if root and root not in parsing_file:
                    continue_to_next_file = True
                else:
                    parsing_file = f"{root}{parsing_file.split(root, 1)[-1]}"

                if continue_to_next_file:
                    continue
            elif continue_to_next_file:
                continue
            elif line.startswith("DA:"):
                hit = line.rsplit(",", 1)[-1]
                if hit == "0":
                    curr_file.lines.append(0)
                else:
                    curr_file.lines.append(1)
            elif line.startswith("BRDA:"):
                hit = line.rsplit(",", 1)[-1]
                if hit == "-" or hit == "0":
                    curr_file.branches.append(0)
                else:
                    curr_file.branches.append(1)
            elif line.startswith("end_of_record"):
                files[parsing_file] = curr_file
                parsing_file = ""
                curr_file = FastFileCov.empty()
            elif line.startswith("FNF:"):
                curr_file.function_found += int(line[4:])
            elif line.startswith("FNH:"):
                curr_file.function_hit += int(line[4:])
            elif line.startswith("LF:"):
                curr_file.line_found = int(line[3:])
            elif line.startswith("LH:"):
                curr_file.line_hit = int(line[3:])
            elif line.startswith("BRF:"):
                curr_file.branch_found = int(line[4:])
            elif line.startswith("BRH:"):
                curr_file.branch_hit = int(line[4:])

        return cls(files=files)

    @classmethod
    def parse_lcov_with_mapping(
        cls,
        lcov_path: str | Path,
        root: str = "",
        ignore_files: list[str] = [],
        keep_only: list[str] = [],
    ) -> FastCoverage:
        lcov_lines = Path(lcov_path).read_text().splitlines()

        files: dict[str, FastFileCov] = {}
        parsing_file = ""
        curr_file = FastFileCov.empty_with_mapping()
        continue_to_next_file = False

        for line in lcov_lines:
            assert curr_file.mapping is not None
            if line == "end_of_record":
                files[parsing_file] = curr_file
                curr_file = FastFileCov.empty_with_mapping()
                parsing_file = ""
                continue_to_next_file = False
                continue

            parts = line.split(":", 1)
            label = parts[0]
            data = parts[1]

            if label == "SF":
                continue_to_next_file = False
                parsing_file = data.strip()

                for to_keep in keep_only:
                    if to_keep not in parsing_file:
                        parsing_file = ""
                        continue_to_next_file = True
                        break

                for to_ignore in ignore_files:
                    if to_ignore in parsing_file:
                        continue_to_next_file = True
                        break

                if root and root not in parsing_file:
                    continue_to_next_file = True
                else:
                    parsing_file = f"{root}{parsing_file.split(root, 1)[-1]}"
                    curr_file.mapping.file_name = line[3:]
            elif continue_to_next_file:
                continue
            elif label == "DA":
                parts = data.rsplit(",")
                line_number = parts[0]
                hit = parts[1]
                if hit == "0":
                    curr_file.lines.append(0)
                else:
                    curr_file.lines.append(1)
                curr_file.mapping.line_numbers.append(line_number)
            elif label == "BRDA":
                parts = data.rsplit(",", 1)
                branch_number = parts[0]
                hit = parts[1]
                if hit == "-" or hit == "0":
                    curr_file.branches.append(0)
                else:
                    curr_file.branches.append(1)
                curr_file.mapping.branch_numbers.append(branch_number)
            elif label == "FN":
                curr_file.mapping.fns.append(line)
            elif label == "FNDA":
                curr_file.mapping.fnda.append(line)
            elif label == "FNF":
                curr_file.function_found += int(line[4:])
            elif label == "FNH":
                curr_file.function_hit += int(line[4:])
            elif label == "LF":
                curr_file.line_found = int(line[3:])
            elif label == "LH":
                curr_file.line_hit = int(line[3:])
            elif label == "BRF":
                curr_file.branch_found = int(line[4:])
            elif label == "BRH":
                curr_file.branch_hit = int(line[4:])
        return cls(files=files)

    def keep_only(self, keep_only: list[str]) -> FastCoverage:
        new_cov = FastCoverage.empty()
        for file_name, file_cov in self.files.items():
            if any(to_keep in file_name for to_keep in keep_only):
                new_cov.files[file_name] = copy.deepcopy(file_cov)
        return new_cov

    def total_cov(self) -> AggregatedCoverage:
        cov = AggregatedCoverage.new_stat()
        for file_cov in self.files.values():
            cov.functions.add(CoverageStat.new_stat(file_cov.function_hit, file_cov.function_found))
            cov.lines.add(CoverageStat.new_stat(file_cov.line_hit, file_cov.line_found))
            cov.branches.add(CoverageStat.new_stat(file_cov.branch_hit, file_cov.branch_found))
        return cov

    def merge(self, other: FastCoverage) -> FastCoverage:
        if self.is_empty():
            return copy.deepcopy(other)
        if other.is_empty():
            return copy.deepcopy(self)

        new_cov = FastCoverage.empty()
        for file_name, file_cov in self.files.items():
            if file_name not in other.files:
                new_cov.files[file_name] = copy.deepcopy(file_cov)
            else:
                new_file_cov = file_cov.merge(other.files[file_name])
                new_cov.files[file_name] = new_file_cov
        return new_cov

    def unique_cov(self, other: FastCoverage) -> FastCoverage:
        if self.is_empty():
            return copy.deepcopy(other)
        if other.is_empty():
            return copy.deepcopy(self)

        new_cov = FastCoverage.empty()
        for file_name, file_cov in self.files.items():
            if file_name not in other.files:
                new_cov.files[file_name] = copy.deepcopy(file_cov)
            else:
                new_file_cov = file_cov.unique_cov(other.files[file_name])
                new_cov.files[file_name] = new_file_cov
        return new_cov

    def intersection(self, other: FastCoverage) -> FastCoverage:
        if self.is_empty() or other.is_empty():
            return FastCoverage.empty()

        new_cov = FastCoverage.empty()
        for file_name, file_cov in self.files.items():
            if file_name in other.files:
                new_file_cov = file_cov.intersection(other.files[file_name])
                new_cov.files[file_name] = new_file_cov
        return new_cov

    def dump_lines(self) -> str:
        lines = []
        for file_cov in self.files.values():
            lines.extend(file_cov.dump_lines())
        return "\n".join(lines)

    @staticmethod
    def union_all(covs: list[FastCoverage]) -> FastCoverage:
        if not covs:
            return FastCoverage.empty()

        union_cov = FastCoverage.empty()
        for cov in covs:
            union_cov = union_cov.merge(cov)
        return union_cov


@dataclass
class FastFileCov:
    function_found: int
    function_hit: int
    line_found: int
    line_hit: int
    branch_found: int
    branch_hit: int
    lines: bitarray
    branches: bitarray
    mapping: Optional[FileMapping] = None

    def to_dict(self) -> dict:
        return {
            "function_found": self.function_found,
            "function_hit": self.function_hit,
            "line_found": self.line_found,
            "line_hit": self.line_hit,
            "branch_found": self.branch_found,
            "branch_hit": self.branch_hit,
            "lines": self.lines.to01(),
            "branches": self.branches.to01(),
            "mapping": self.mapping.__dict__ if self.mapping else None,
        }

    def convert_to_lcov_lines(self) -> list[str]:
        assert self.mapping is not None

        lcov_lines = []
        lcov_lines.append(f"SF:{self.mapping.file_name}")

        lcov_lines.extend(self.mapping.fns)
        lcov_lines.extend(self.mapping.fnda)
        lcov_lines.append(f"FNF:{self.function_found}")
        lcov_lines.append(f"FNH:{self.function_hit}")

        for line_number, hit in zip(self.mapping.line_numbers, self.lines):
            lcov_lines.append(f"DA:{line_number},{hit}")
        lcov_lines.append(f"LF:{self.line_found}")
        lcov_lines.append(f"LH:{self.line_hit}")

        for branch_number, hit in zip(self.mapping.branch_numbers, self.branches):
            lcov_lines.append(f"BRDA:{branch_number},{hit}")
        lcov_lines.append(f"BRF:{self.branch_found}")
        lcov_lines.append(f"BRH:{self.branch_hit}")
        lcov_lines.append("end_of_record")
        return lcov_lines

    @classmethod
    def empty(cls) -> FastFileCov:
        return cls(
            function_found=0,
            function_hit=0,
            line_found=0,
            line_hit=0,
            branch_found=0,
            branch_hit=0,
            lines=bitarray(),
            branches=bitarray(),
        )

    @classmethod
    def empty_with_mapping(cls) -> FastFileCov:
        return cls(
            function_found=0,
            function_hit=0,
            line_found=0,
            line_hit=0,
            branch_found=0,
            branch_hit=0,
            lines=bitarray(),
            branches=bitarray(),
            mapping=FileMapping.empty(),
        )

    def clear(self) -> None:
        self.function_hit = 0
        self.line_hit = 0
        self.branch_hit = 0
        self.lines.setall(0)
        self.branches.setall(0)

    def convert_to_other_mapping(self, other: FastFileCov) -> None:
        """
        Convert `self`'s mapping to match `other`'s mapping for set operations
        """
        assert self.mapping is not None
        assert other.mapping is not None

        self.mapping.file_name = other.mapping.file_name
        self.function_found = other.function_found
        self.branch_found = other.branch_found
        self.line_found = other.line_found

        self_line_covs = list(zip(self.mapping.line_numbers, self.lines))
        other_line_numbers = copy.deepcopy(other.mapping.line_numbers)
        self.lines = bitarray()
        while len(other_line_numbers) > 0:
            if len(self_line_covs) == 0:
                self.lines.append(0)
                other_line_numbers.pop(0)
                continue

            self_line_num, self_hit = self_line_covs.pop(0)
            self_line_num = int(self_line_num)
            other_line_num = int(other_line_numbers[0])

            if self_line_num < other_line_num:
                continue
            elif self_line_num == other_line_num:
                self.lines.append(self_hit)
                other_line_numbers.pop(0)
            elif self_line_num > other_line_num:
                self.lines.append(0)
                self_line_covs.insert(0, (str(self_line_num), self_hit))
                other_line_numbers.pop(0)

        self_branch_covs = list(zip(self.mapping.branch_numbers, self.branches))
        other_branch_numbers = copy.deepcopy(other.mapping.branch_numbers)
        self.branches = bitarray()

        while len(other_branch_numbers) > 0:
            if len(self_branch_covs) == 0:
                self.branches.append(0)
                other_branch_numbers.pop(0)
                continue

            self_branch_num, self_hit = self_branch_covs.pop(0)

            if FastFileCov.__compare_branch_num_str(self_branch_num, other_branch_numbers[0]) < 0:
                continue
            elif FastFileCov.__compare_branch_num_str(self_branch_num, other_branch_numbers[0]) == 0:
                self.branches.append(self_hit)
                other_branch_numbers.pop(0)
            elif FastFileCov.__compare_branch_num_str(self_branch_num, other_branch_numbers[0]) > 0:
                self.branches.append(0)
                self_branch_covs.insert(0, (self_branch_num, self_hit))
                other_branch_numbers.pop(0)

        self.function_hit = 0
        self.line_hit = self.lines.count(1)
        self.branch_hit = self.branches.count(1)
        self.mapping = other.mapping

    @staticmethod
    def __compare_branch_num_str(left: str, right: str) -> int:
        if left == right:
            return 0

        left_parts = left.split(",")
        left_nums = [int(part) for part in left_parts]
        right_parts = right.split(",")
        right_nums = [int(part) for part in right_parts]

        for left_num, right_num in zip(left_nums, right_nums):
            if left_num < right_num:
                return -1
            elif left_num > right_num:
                return 1
        return 0

    def merge(self, other: FastFileCov) -> FastFileCov:
        assert len(self.lines) == len(other.lines)
        assert len(self.branches) == len(other.branches)
        assert self.function_found == other.function_found
        assert self.line_found == other.line_found
        assert self.branch_found == other.branch_found

        new_lines = self.lines | other.lines
        new_branches = self.branches | other.branches
        if self.mapping is not None:
            new_mapping = copy.deepcopy(self.mapping)
        elif other.mapping is not None:
            new_mapping = copy.deepcopy(other.mapping)
        else:
            new_mapping = None

        return FastFileCov(
            function_found=self.function_found,
            function_hit=max(self.function_hit, other.function_hit),
            line_found=self.line_found,
            line_hit=max(self.line_hit, other.line_hit),
            branch_found=self.branch_found,
            branch_hit=max(self.branch_hit, other.branch_hit),
            lines=new_lines,
            branches=new_branches,
            mapping=new_mapping,
        )

    def unique_cov(self, other: FastFileCov) -> FastFileCov:
        assert len(self.lines) == len(other.lines)
        assert len(self.branches) == len(other.branches)
        assert self.function_found == other.function_found
        assert self.line_found == other.line_found
        assert self.branch_found == other.branch_found

        new_lines = self.lines & (~other.lines)
        new_branches = self.branches & (~other.branches)
        if self.mapping is not None:
            new_mapping = copy.deepcopy(self.mapping)
        elif other.mapping is not None:
            new_mapping = copy.deepcopy(other.mapping)
        else:
            new_mapping = None

        return FastFileCov(
            function_found=self.function_found,
            function_hit=0,
            line_found=self.line_found,
            line_hit=new_lines.count(1),
            branch_found=self.branch_found,
            branch_hit=new_branches.count(1),
            lines=new_lines,
            branches=new_branches,
            mapping=new_mapping,
        )

    def intersection(self, other: FastFileCov) -> FastFileCov:
        assert len(self.lines) == len(other.lines)
        assert len(self.branches) == len(other.branches)
        assert self.function_found == other.function_found
        assert self.line_found == other.line_found
        assert self.branch_found == other.branch_found

        new_lines = self.lines & other.lines
        new_branches = self.branches & other.branches
        if self.mapping is not None:
            new_mapping = copy.deepcopy(self.mapping)
        elif other.mapping is not None:
            new_mapping = copy.deepcopy(other.mapping)
        else:
            new_mapping = None

        return FastFileCov(
            function_found=self.function_found,
            function_hit=0,
            line_found=self.line_found,
            line_hit=new_lines.count(1),
            branch_found=self.branch_found,
            branch_hit=new_branches.count(1),
            lines=new_lines,
            branches=new_branches,
            mapping=new_mapping,
        )

    def dump_lines(self) -> list[str]:
        assert self.mapping is not None
        lines = []
        for line_number, hit in zip(self.mapping.line_numbers, self.lines):
            if hit == 1:
                lines.append(f"{self.mapping.file_name}:{line_number}")
        return lines


if __name__ == "__main__":
    import pickle
    import time

    from .config import APTOS_CORE_DIR, MOVE_SMITH_DIR
    from .runner import generate_lcov_for_one

    rep = 20

    file1 = APTOS_CORE_DIR / "third_party/move/move-compiler-v2/transactional-tests/cov_original.lcov"
    file2 = APTOS_CORE_DIR / "third_party/move/move-compiler-v2/transactional-tests/cov_with_corpus.lcov"
    file3 = MOVE_SMITH_DIR / "llm/work/fuzz-fixer/unique_tests/0a5a35e7adc58e437646cac6a4cd4fe5.move"

    result = generate_lcov_for_one(
        MOVE_SMITH_DIR / "runner/move-test-runner/target/debug/move-test-runner", Path(file3), True
    )
    result_lcov = result.coverage.convert_to_lcov()
    print(f"New cov: {result.coverage.total_cov()}")
    temp_file = Path("temp_cov.lcov")
    temp_file.write_text(result_lcov)
    old_cov = Coverage.parse(temp_file)
    old_origin = Coverage.parse(file1)
    uniq = old_cov.unique_cov(old_origin)
    print(f"Txnal cov: {old_origin.total_cov()}")
    print(f"Unique coverage: {uniq.total_cov()}")

    print("Calculating unique coverage using mapping conversion...")
    result = generate_lcov_for_one(
        MOVE_SMITH_DIR / "runner/move-test-runner/target/debug/move-test-runner", Path(file3), True
    )
    print(f"New cov: {result.coverage.total_cov()}")
    txnal_cov = FastCoverage.parse_lcov_with_mapping(file1, root="third_party", keep_only=["third_party"])
    print(f"Txnal cov: {txnal_cov.total_cov()}")
    txnal_cov.convert_to_other_mapping(result.coverage)
    print(f"Txnal cov: {txnal_cov.total_cov()}")
    uniq = result.coverage.unique_cov(txnal_cov)
    print(f"Unique coverage: {uniq.total_cov()}")

    root = "third_party"

    cov1 = Coverage.parse(file1)
    cov2 = Coverage.parse(file2)
    uniq_slow = cov2.unique_cov(cov1)
    print(f"Slow unique_cov: {uniq_slow.total_cov()}")

    cov1 = FastCoverage.parse_lcov(file1, root, keep_only=[root])
    cov2 = FastCoverage.parse_lcov(file2, root, keep_only=[root])
    uniq_fast = cov2.unique_cov(cov1)
    print(f"Fast unique_cov: {uniq_fast.total_cov()}")

    start = time.perf_counter()
    for _ in range(rep):
        cov1 = Coverage.parse(file1)
    print("Coverage.parse: ", time.perf_counter() - start)

    start = time.perf_counter()
    for _ in range(rep):
        cov1 = FastCoverage.parse_lcov(file1, root, keep_only=[root])
    print("FastCoverage.parse_lcov: ", time.perf_counter() - start)

    cov1 = Coverage.parse(file1)
    start = time.perf_counter()
    for _ in range(rep):
        pickled_str = pickle.dumps(cov1)
        converted = pickle.loads(pickled_str)
    print("Coverage pickle.dumps and loads: ", time.perf_counter() - start)

    cov1 = FastCoverage.parse_lcov(file1, root, keep_only=[root])
    start = time.perf_counter()
    for _ in range(rep):
        pickled_str = pickle.dumps(cov1)
        converted = pickle.loads(pickled_str)
    print("FastCoverage pickle.dumps and loads: ", time.perf_counter() - start)

    cov1 = Coverage.parse(file1)
    cov2 = Coverage.parse(file2)
    start = time.perf_counter()
    for _ in range(rep):
        cov3 = cov1.merge(cov2)
    print("Coverage.merge: ", time.perf_counter() - start)

    cov1 = FastCoverage.parse_lcov(file1, root, keep_only=[root])
    cov2 = FastCoverage.parse_lcov(file2, root, keep_only=[root])
    start = time.perf_counter()
    for _ in range(rep):
        cov3 = cov1.merge(cov2)
    print("FastCoverage.merge: ", time.perf_counter() - start)

    cov1 = Coverage.parse(file1)
    cov2 = Coverage.parse(file2)
    start = time.perf_counter()
    for _ in range(rep):
        cov3 = cov1.unique_cov(cov2)
    print("Coverage.unique_cov: ", time.perf_counter() - start)

    cov1 = FastCoverage.parse_lcov(file1, root, keep_only=[root])
    cov2 = FastCoverage.parse_lcov(file2, root, keep_only=[root])
    start = time.perf_counter()
    for _ in range(rep):
        cov3 = cov1.unique_cov(cov2)
    print("FastCoverage.unique_cov: ", time.perf_counter() - start)
    print("FastCoverage.unique_cov: ", time.perf_counter() - start)
