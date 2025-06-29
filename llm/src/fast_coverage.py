from __future__ import annotations

import copy
from dataclasses import dataclass
from pathlib import Path

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
    mappings: list[FileMapping]
    files: dict[str, FastFileCov]

    @classmethod
    def empty(cls) -> FastCoverage:
        return cls(files={}, mappings=[])

    def is_empty(self) -> bool:
        return not self.files

    def to_dict(self) -> dict:
        return {
            "files": {file_name: file_cov.to_dict() for file_name, file_cov in self.files.items()},
            "mappings": [mapping.__dict__ for mapping in self.mappings],
        }

    @classmethod
    def generate_file_mapping(cls, lcov_path: str | Path) -> list[FileMapping]:
        lcov_lines = Path(lcov_path).read_text().splitlines()
        mappings = []
        curr_mapping = FileMapping.empty()

        for line in lcov_lines:
            if line == "end_of_record":
                mappings.append(copy.deepcopy(curr_mapping))
                curr_mapping = FileMapping.empty()
                continue

            parts = line.split(":", 1)
            label = parts[0]
            data = parts[1]

            if label == "SF":
                curr_mapping.file_name = data
            elif label == "DA":
                line_number = data.split(",")[0]
                curr_mapping.line_numbers.append(line_number)
            elif label == "BRDA":
                branch_number = data.rsplit(",", 1)[0]
                curr_mapping.branch_numbers.append(branch_number)
            elif label == "FN":
                curr_mapping.fns.append(line)
            elif label == "FNDA":
                curr_mapping.fnda.append(line)
        return mappings

    def convert_to_lcov(self) -> str:
        lcov_lines = []
        for mapping in self.mappings:
            for file_name in self.files:
                if file_name in mapping.file_name:
                    file_cov = self.files[file_name]
                    lcov_lines.extend(file_cov.convert_to_lcov_lines(mapping))
                    break
        return "\n".join(lcov_lines)

    @classmethod
    def parse_lcov(
        cls,
        lcov_path: str | Path,
        root: str = "",
        ignore_files: list[str] = [],
        keep_only: list[str] = [],
        generate_file_mappings: bool = False,
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

        if generate_file_mappings:
            mappings = cls.generate_file_mapping(lcov_path)
        else:
            mappings = []
        return cls(files=files, mappings=mappings)

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
        }

    def convert_to_lcov_lines(self, mapping: FileMapping) -> list[str]:
        assert len(mapping.line_numbers) == len(self.lines)
        assert len(mapping.branch_numbers) == len(self.branches)

        lcov_lines = []
        lcov_lines.append(f"SF:{mapping.file_name}")

        lcov_lines.extend(mapping.fns)
        lcov_lines.extend(mapping.fnda)
        lcov_lines.append(f"FNF:{self.function_found}")
        lcov_lines.append(f"FNH:{self.function_hit}")

        for line_number, hit in zip(mapping.line_numbers, self.lines):
            lcov_lines.append(f"DA:{line_number},{hit}")
        lcov_lines.append(f"LF:{self.line_found}")
        lcov_lines.append(f"LH:{self.line_hit}")

        for branch_number, hit in zip(mapping.branch_numbers, self.branches):
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

    def merge(self, other: FastFileCov) -> FastFileCov:
        assert len(self.lines) == len(other.lines)
        assert len(self.branches) == len(other.branches)
        assert self.function_found == other.function_found
        assert self.line_found == other.line_found
        assert self.branch_found == other.branch_found

        new_lines = self.lines | other.lines
        new_branches = self.branches | other.branches
        return FastFileCov(
            function_found=self.function_found,
            function_hit=max(self.function_hit, other.function_hit),
            line_found=self.line_found,
            line_hit=max(self.line_hit, other.line_hit),
            branch_found=self.branch_found,
            branch_hit=max(self.branch_hit, other.branch_hit),
            lines=new_lines,
            branches=new_branches,
        )

    def unique_cov(self, other: FastFileCov) -> FastFileCov:
        assert len(self.lines) == len(other.lines)
        assert len(self.branches) == len(other.branches)
        assert self.function_found == other.function_found
        assert self.line_found == other.line_found
        assert self.branch_found == other.branch_found

        new_lines = self.lines & (~other.lines)
        new_branches = self.branches & (~other.branches)
        return FastFileCov(
            function_found=0,
            function_hit=0,
            line_found=self.line_found,
            line_hit=new_lines.count(1),
            branch_found=self.branch_found,
            branch_hit=new_branches.count(1),
            lines=new_lines,
            branches=new_branches,
        )


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
        Path("/home/zijie/move-smith/runner/move-test-runner/target/debug/move-test-runner"), Path(file3), True
    )
    result_lcov = result.coverage.convert_to_lcov()
    print(f"New cov: {result.coverage.total_cov()}")
    temp_file = Path("temp_cov.lcov")
    temp_file.write_text(result_lcov)
    old_cov = Coverage.parse(temp_file)
    old_origin = Coverage.parse(file1)
    # uniq = old_origin.unique_cov(old_cov)
    uniq = old_cov.unique_cov(old_origin)
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
