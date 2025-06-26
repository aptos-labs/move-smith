from __future__ import annotations

import copy
import json
from dataclasses import dataclass, field
from pathlib import Path
from typing import Optional

from loguru import logger


@dataclass
class CoverageStat:
    covered: float = 0
    total: float = 0
    percent: float = 0

    @staticmethod
    def new_stat(covered, total) -> CoverageStat:
        stat = CoverageStat()
        stat.covered = covered
        stat.total = total
        stat.calculate_percent()
        return stat

    def add(self, other: CoverageStat):
        self.covered += other.covered
        self.total += other.total
        self.calculate_percent()

    def diff(self, other: CoverageStat) -> CoverageStat:
        return CoverageStat.new_stat(self.covered - other.covered, other.total)

    def calculate_percent(self):
        if self.total == 0:
            self.percent = 0
        else:
            self.percent = self.covered / self.total * 100

    @staticmethod
    def average_all(stats: list[CoverageStat]):
        if len(stats) == 0:
            return CoverageStat()
        covered = 0
        total = 0
        for stat in stats:
            covered += stat.covered
            total += stat.total
        avg_cov = covered / len(stats)
        avg_total = total / len(stats)
        return CoverageStat.new_stat(avg_cov, avg_total)

    def only_percentages(self) -> CoverageStat:
        return CoverageStat(covered=self.percent, total=100, percent=self.percent)

    @staticmethod
    def from_dict(data) -> CoverageStat:
        return CoverageStat(**data)

    @staticmethod
    def from_summary(data) -> Optional[CoverageStat]:
        if data is None:
            return None
        if "covered" not in data or "count" not in data:
            return None
        if "percent" not in data:
            return CoverageStat.new_stat(data["covered"], data["count"])
        else:
            return CoverageStat(covered=data["covered"], total=data["count"], percent=data["percent"])


@dataclass
class AggregatedCoverage:
    functions: CoverageStat
    lines: CoverageStat
    branches: CoverageStat

    @staticmethod
    def new_stat() -> AggregatedCoverage:
        return AggregatedCoverage(
            functions=CoverageStat(),
            lines=CoverageStat(),
            branches=CoverageStat(),
        )

    def is_empty(self) -> bool:
        return self.functions.covered == 0 and self.lines.covered == 0 and self.branches.covered == 0

    def functions_covered(self) -> float:
        return self.functions.covered

    def lines_covered(self) -> float:
        return self.lines.covered

    def branches_covered(self) -> float:
        return self.branches.covered

    @staticmethod
    def average_all(covs: list[AggregatedCoverage]):
        functions = [cov.functions for cov in covs]
        lines = [cov.lines for cov in covs]
        branches = [cov.branches for cov in covs]

        avg_functions = CoverageStat.average_all(functions)
        avg_lines = CoverageStat.average_all(lines)
        avg_branches = CoverageStat.average_all(branches)

        return AggregatedCoverage(
            functions=avg_functions,
            lines=avg_lines,
            branches=avg_branches,
        )

    def diff(self, other: AggregatedCoverage) -> AggregatedCoverage:
        return AggregatedCoverage(
            functions=self.functions.diff(other.functions),
            lines=self.lines.diff(other.lines),
            branches=self.branches.diff(other.branches),
        )

    def only_percentages(self) -> AggregatedCoverage:
        return AggregatedCoverage(
            functions=self.functions.only_percentages(),
            lines=self.lines.only_percentages(),
            branches=self.branches.only_percentages(),
        )

    @staticmethod
    def from_dict(data: dict) -> AggregatedCoverage:
        return AggregatedCoverage(
            functions=CoverageStat.from_dict(data["functions"]),
            lines=CoverageStat.from_dict(data["lines"]),
            branches=CoverageStat.from_dict(data["branches"]),
        )

    def pprint(self) -> str:
        s = []
        s.append(f"Functions: {self.functions.covered}/{self.functions.total} {self.functions.percent:.2f}%")
        s.append(f"Lines: {self.lines.covered}/{self.lines.total} {self.lines.percent:.2f}%")
        s.append(f"Branches: {self.branches.covered}/{self.branches.total} {self.branches.percent:.2f}%")
        return "\n".join(s)


@dataclass
class Coverage:
    from_info: list[str]
    files: dict[str, File]

    @staticmethod
    def new_empty() -> Coverage:
        return Coverage(from_info=[], files={})

    @staticmethod
    def parse(info_file) -> Coverage:
        info_file = Path(info_file)
        logger.info(f"Parsing coverage file {info_file}")
        lines = info_file.read_text().splitlines()
        file_lines = [[]]
        for line in lines:
            if line.startswith("end_of_record"):
                file_lines.append([])
            else:
                file_lines[-1].append(line)

        files = {}
        for fl in file_lines:
            if len(fl) == 0:
                continue
            file = File.parse_lines(fl)
            if file is not None:
                files[file.file_name] = file
        return Coverage(files=files, from_info=[str(info_file)])

    def total_cov(self) -> AggregatedCoverage:
        cov = AggregatedCoverage.new_stat()
        for _, file in self.files.items():
            cov.functions.add(CoverageStat.new_stat(file.covered_functions(), file.total_functions()))
            cov.lines.add(CoverageStat.new_stat(file.covered_lines(), file.total_lines()))
            cov.branches.add(CoverageStat.new_stat(file.covered_branches(), file.total_branches()))
        return cov

    @staticmethod
    def from_dict(data: dict) -> Coverage:
        cov = Coverage(**data)
        cov.files = {}
        for name, file in data["files"].items():
            cov.files[name] = File.from_dict(file)
        return cov

    def merge(self, other: Coverage):
        for file_name, file in other.files.items():
            if file_name in self.files:
                self.files[file_name].merge(file)
            else:
                self.files[file_name] = file
                self.files[file_name].is_merged = True
        self.from_info.extend(other.from_info)

    @staticmethod
    def select_max_line(covs: list[Coverage]):
        max_cov = covs[0]
        for cov in covs[1:]:
            if cov.total_cov().lines.percent > max_cov.total_cov().lines.percent:
                max_cov = cov
        return max_cov

    @staticmethod
    def union_all(covs: list[Coverage]):
        if len(covs) == 0:
            return None
        union = copy.deepcopy(covs[0])
        for cov in covs[1:]:
            union.merge(cov)
        return union

    def unique_cov(self, other: Coverage) -> Coverage:
        cov = Coverage.new_empty()
        curr_cov = copy.deepcopy(self)
        cov.from_info = self.from_info
        cov.files = {}
        for name, file in curr_cov.files.items():
            if name not in other.files:
                cov.files[name] = file
            else:
                cov.files[name] = file.unique_cov(other.files[name])
        return cov

    def intersection(self, other: Coverage) -> Coverage:
        cov = Coverage.new_empty()
        cov.files = {}
        for name, file in self.files.items():
            if name in other.files:
                cov.files[name] = file.unique_cov(other.files[name])
        return cov

    def dump_lines(self) -> str:
        lines = []
        for file in self.files.values():
            for line in file.lines.values():
                if line.hit > 0:
                    lines.append(f"{file.file_name}:{line.line_number}")
        return "\n".join(lines)


@dataclass
class File:
    functions: dict[str, Function] = field(default_factory=dict)
    lines: dict[str, Line] = field(default_factory=dict)
    branches: dict[str, Branch] = field(default_factory=dict)

    file_name: str = ""

    functions_found: int = 0
    functions_hit: int = 0

    branches_found: int = 0
    branches_hit: int = 0

    lines_found: int = 0
    lines_hit: int = 0

    is_merged: bool = False

    @staticmethod
    def from_dict(data: dict) -> File:
        file = File(**data)
        file.functions = {}
        file.lines = {}
        file.branches = {}
        for name, func in data["functions"].items():
            file.functions[name] = Function(**func)
        for name, line in data["lines"].items():
            file.lines[name] = Line(**line)
        for name, branch in data["branches"].items():
            file.branches[name] = Branch(**branch)
        return file

    @staticmethod
    def parse_lines(lines: list[str]) -> Optional[File]:
        file = File()
        file.functions = {}
        file.lines = {}
        file.branches = {}

        for line in lines:
            parts = line.split(":", 1)
            label = parts[0]
            data = parts[1]
            if label == "SF":
                move_parts = data.split("third_party/", 1)
                if len(move_parts) > 1:
                    file.file_name = move_parts[1]
                    logger.trace(f"Processing file {data}")
                else:
                    logger.trace(f"Skipping file {data}")
                    return None
            elif label == "FNF":
                logger.trace(f"Function found: {data}")
                file.functions_found = int(data)
            elif label == "FNH":
                logger.trace(f"Function hit: {data}")
                file.functions_hit = int(data)
            elif label == "BRF":
                logger.trace(f"Branch found: {data}")
                file.branches_found = int(data)
            elif label == "BRH":
                logger.trace(f"Branch hit: {data}")
                file.branches_hit = int(data)
            elif label == "LF":
                logger.trace(f"Lines found: {data}")
                file.lines_found = int(data)
            elif label == "LH":
                logger.trace(f"Lines hit: {data}")
                file.lines_hit = int(data)
            elif label == "FN":
                logger.trace(f"Ignoring function: {data}")
                continue
            elif label == "FNDA":
                func = Function.parse(file.file_name, data)
                file.functions[repr(func)] = func
            elif label == "DA":
                line = Line.parse(file.file_name, data)
                file.lines[repr(line)] = line
            elif label == "BRDA":
                branch = Branch.parse(file.file_name, data)
                file.branches[repr(branch)] = branch
            else:
                logger.error(f"Unknown label in line: {line}")

        if file.lines_found == 0:
            logger.warning(f"No lines found in file {file.file_name}")
            return None

        return file

    def merge(self, other: File):
        assert self.file_name == other.file_name
        self.is_merged = True
        self.functions_found = 0
        self.functions_hit = 0
        self.branches_found = 0
        self.branches_hit = 0
        self.lines_found = 0
        self.lines_hit = 0

        for name, func in other.functions.items():
            if name in self.functions:
                self.functions[name].hit += func.hit
            else:
                self.functions[name] = copy.deepcopy(func)

        for name, line in other.lines.items():
            if name in self.lines:
                self.lines[name].hit += line.hit
            else:
                self.lines[name] = copy.deepcopy(line)

        for name, branch in other.branches.items():
            if name in self.branches:
                self.branches[name].hit += branch.hit
            else:
                self.branches[name] = copy.deepcopy(branch)

    def total_functions(self):
        if self.is_merged:
            return len(self.functions)
        else:
            return self.functions_found

    def covered_functions(self):
        if self.is_merged:
            return len([f for f in self.functions if self.functions[f].hit > 0])
        else:
            return self.functions_hit

    def total_lines(self):
        if self.is_merged:
            return len(self.lines)
        else:
            return self.lines_found

    def covered_lines(self):
        if self.is_merged:
            return len([line for line in self.lines if self.lines[line].hit > 0])
        else:
            return self.lines_hit

    def total_branches(self):
        if self.is_merged:
            return len(self.branches)
        else:
            return self.branches_found

    def covered_branches(self):
        if self.is_merged:
            return len([b for b in self.branches if self.branches[b].hit > 0])
        else:
            return self.branches_hit

    def unique_cov(self, other: File) -> File:
        file = File()
        file.file_name = self.file_name
        file.is_merged = True

        file.functions = {}
        file.lines = {}
        file.branches = {}

        for name, func in self.functions.items():
            file.functions[name] = func
            if name in other.functions:
                if other.functions[name].hit > 0:
                    file.functions[name].hit = 0

        for name, line in self.lines.items():
            file.lines[name] = line
            if name in other.lines:
                if other.lines[name].hit > 0:
                    file.lines[name].hit = 0

        for name, branch in self.branches.items():
            file.branches[name] = branch
            if name in other.branches:
                if other.branches[name].hit > 0:
                    file.branches[name].hit = 0
        return file

    def intersection(self, other: File) -> File:
        file = File()
        file.file_name = self.file_name
        file.is_merged = True

        file.functions = {}
        file.lines = {}
        file.branches = {}

        for name, func in self.functions.items():
            if name in other.functions:
                file.functions[name] = other.functions[name]
            else:
                file.functions[name] = Function(func.function_name, 0)

        for name, line in self.lines.items():
            if name in other.lines:
                file.lines[name] = other.lines[name]
            else:
                file.lines[name] = Line(line.line_number, 0)

        for name, branch in self.branches.items():
            if name in other.branches:
                file.branches[name] = other.branches[name]
            else:
                file.branches[name] = Branch(
                    file_name=self.file_name,
                    line_number=branch.line_number,
                    block_number=branch.block_number,
                    branch_number=branch.branch_number,
                    hit=0,
                )
        return file


@dataclass
class Function:
    # file_name: str
    function_name: str
    hit: int

    @staticmethod
    def parse(file_name: str, line: str) -> Function:
        # hit_cnt, function_name
        parts = line.split(",")
        hit = int(parts[0])
        function_name = parts[1]
        # return Function(file_name, function_name, hit)
        return Function(function_name, hit)

    def __repr__(self):
        return f"{self.function_name}"


@dataclass
class Line:
    # file_name: str
    line_number: int
    hit: int

    @staticmethod
    def parse(file_name: str, line: str) -> Line:
        # line_num,hit_cnt
        parts = line.split(",")
        line_number = int(parts[0])
        hit = int(parts[1])
        # return Line(file_name, line_number, hit)
        return Line(line_number, hit)

    def __repr__(self):
        return f"{self.line_number}"


@dataclass
class Branch:
    file_name: str
    line_number: int
    block_number: int
    branch_number: int
    hit: int

    @staticmethod
    def parse(file_name: str, line: str) -> Branch:
        # line_num,block_num,branch_num,hit_cnt
        parts = line.split(",")
        line_number = int(parts[0])
        block_number = int(parts[1])
        branch_number = int(parts[2])

        if parts[3] == "-":
            hit = 0
        else:
            hit = int(parts[3])

        return Branch(file_name, line_number, block_number, branch_number, hit)

    def __repr__(self):
        return f"{self.file_name}:{self.line_number}:{self.block_number}:{self.branch_number}"


class FuzzSummary:
    branches: Optional[CoverageStat]
    functions: Optional[CoverageStat]
    lines: CoverageStat
    regions: Optional[CoverageStat]
    instantiations: Optional[CoverageStat]

    @staticmethod
    def from_summary_json(summary_file: str | Path) -> Optional[FuzzSummary]:
        summary_file = Path(summary_file)
        if not summary_file.exists():
            return None

        data = json.loads(summary_file.read_text())
        if "data" not in data:
            logger.warning("cannot find data in summary file")
            return None
        data = data["data"]
        if len(data) == 0:
            logger.warning("data is empty in summary file")
            return None
        data = data[0]
        if "totals" not in data:
            logger.warning("cannot find totals in summary file")
            return None
        data = data["totals"]

        summary = FuzzSummary()
        lines = CoverageStat.from_summary(data.get("lines"))
        if not lines:
            logger.warning("cannot extract lines in summary file")
            return None
        summary.lines = lines
        summary.branches = CoverageStat.from_summary(data.get("branches"))
        summary.functions = CoverageStat.from_summary(data.get("functions"))
        summary.regions = CoverageStat.from_summary(data.get("regions"))
        summary.instantiations = CoverageStat.from_summary(data.get("instantiations"))
        return summary

    def is_almost_zero(self) -> bool:
        return self.lines.covered < 30 or self.lines.percent < 1
