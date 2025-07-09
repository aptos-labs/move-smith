import subprocess
import tempfile
import time
from dataclasses import dataclass
from pathlib import Path

from loguru import logger
from rich.progress import track

from .config import EXECUTOR_DIR
from .coverage import Coverage
from .fast_coverage import FastCoverage
from .llm import run_in_parallel
from .store import Monitor

TOTAL_NUMBER_OF_ERRORS = "total_number_of_errors"
TOTAL_NUMBER_OF_ICES = "total_number_of_ices"


@dataclass
class RunResult:
    has_error: bool
    has_bug: bool
    num_errors: int
    num_bugs: int
    error_message: str
    coverage: FastCoverage


def build_move_transactional_test_runner() -> Path:
    """
    Builds the test runner executable if not already built.

    Args:
        msmith_path (Path): Path to the msmith directory.

    Returns:
        Path: the path to the test runner executable.
    """
    runner_dir = EXECUTOR_DIR / "move_transactional"
    runner = runner_dir / "target/debug/runner"
    if not runner.exists():
        logger.info(f"Building test runner at {runner}")
        subprocess.run("make", cwd=runner_dir, check=True, shell=True)
    if not runner.exists():
        raise FileNotFoundError(f"Test runner not found at {runner}. Please check the build process.")
    return runner


def run_one_test(test_code: str, keep_mapping: bool = False) -> RunResult:
    runner_path = build_move_transactional_test_runner()
    with tempfile.TemporaryDirectory() as temp_dir:
        temp_path = Path(temp_dir)
        test_file = temp_path / "test.move"
        test_file.write_text(test_code)
        result = generate_lcov_for_one(runner_path, test_file, keep_mapping=keep_mapping)
        logger.success(f"Generated coverage for test: {test_file}")
    return result


def process_output(output: str) -> tuple[int, int, str]:
    parts = output.split("\n", 2)
    num_errors = int(parts[0])
    num_bugs = int(parts[1])
    error_message = parts[2] if len(parts) > 2 else ""

    return num_errors, num_bugs, error_message


def generate_lcov_for_one(runner_path: Path, test_path: Path, keep_mapping: bool) -> RunResult:
    runner_path = runner_path.resolve()
    test_path = test_path.resolve()
    test_dir = test_path.parent

    monitor = Monitor()
    start = time.perf_counter()
    try:
        r = subprocess.run(
            [
                runner_path.as_posix(),
                test_path.as_posix(),
            ],
            env={"LLVM_PROFILE_FILE": test_dir / f"{test_path.stem}.profraw"},
            text=True,
            stdout=subprocess.PIPE,
            stderr=subprocess.STDOUT,
            timeout=10,
        )
    except subprocess.TimeoutExpired as e:
        return RunResult(
            has_error=True,
            num_errors=1,
            num_bugs=0,
            has_bug=False,
            error_message=f"Test {test_path.name} timed out: {e}",
            coverage=FastCoverage.empty(),
        )

    monitor.record_time(Monitor.EXECUTION_TIME_KEY, start)

    num_errors, num_bugs, error_message = process_output(r.stdout)
    monitor.incr_counter(TOTAL_NUMBER_OF_ERRORS, num_errors)
    monitor.incr_counter(TOTAL_NUMBER_OF_ICES, num_bugs)

    start = time.perf_counter()
    logger.trace(f"Generated raw coverage for {test_path.name}")
    subprocess.run(
        [
            "llvm-profdata",
            "merge",
            "--output",
            str(test_dir / f"{test_path.stem}.profdata"),
            str(test_dir / f"{test_path.stem}.profraw"),
        ],
        text=True,
        check=True,
    )
    logger.trace(f"Generated profdata for {test_path.name}")

    r = subprocess.run(
        [
            "llvm-cov",
            "export",
            str(runner_path),
            "--format=lcov",
            f"--instr-profile={test_dir / f'{test_path.stem}.profdata'}",
            "--Xdemangler=rustfilt",
            "--ignore-filename-regex=.rustup|.cargo/registry|.cargo/git/checkouts/bcs*|rustc",
        ],
        text=True,
        check=True,
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
    )
    (test_dir / f"{test_path.stem}.lcov").write_text(r.stdout)
    logger.trace(f"Generated lcov for {test_path.name}")
    if keep_mapping:
        cov = FastCoverage.parse_lcov_with_mapping(
            test_dir / f"{test_path.stem}.lcov",
            root="third_party",
            keep_only=["third_party"],
        )
    else:
        cov = FastCoverage.parse_lcov(
            test_dir / f"{test_path.stem}.lcov",
            root="third_party",
            keep_only=["third_party"],
        )
    monitor.record_time(Monitor.COVERAGE_TIME_KEY, start)
    return RunResult(
        has_error=num_errors > 0,
        num_errors=num_errors,
        has_bug=num_bugs > 0,
        num_bugs=num_bugs,
        error_message=error_message,
        coverage=cov,
    )


def generate_all_coverage(
    runner_path: Path, test_dir: Path, ignore_singles: bool
) -> tuple[Coverage, dict[str, Coverage]]:
    """
    Generates total coverage for all tests in the specified directory.

    Args:
        runner_path (Path): Path to the test runner executable.
        test_dir (Path): Directory containing test files.

    Returns:
        Coverage: The total coverage object.
    """
    single_file_covs = {}
    args = []
    test_files = []
    for test_path in test_dir.glob("*.move"):
        if not test_path.is_file():
            continue
        args.append((runner_path, test_path))
        test_files.append(test_path.name)

    if not ignore_singles:
        covs = run_in_parallel(24, generate_lcov_for_one, args)
        for test_path, cov in zip(test_files, covs):
            single_file_covs[test_path] = cov

    profraws = test_dir.glob("*.profraw")
    list_file = test_dir / "profraw_list.txt"
    list_file.write_text("\n".join(str(p) for p in profraws))

    subprocess.run(
        [
            "llvm-profdata",
            "merge",
            "-o",
            (test_dir / "total_coverage.profdata").as_posix(),
            f"@{list_file.as_posix()}",
        ],
        text=True,
        check=True,
    )
    logger.success("Merged all profraw files into total_coverage.profdata")

    r = subprocess.run(
        [
            "llvm-cov",
            "export",
            str(runner_path),
            "--format=lcov",
            f"--instr-profile={test_dir / 'total_coverage.profdata'}",
            "--Xdemangler=rustfilt",
            "--ignore-filename-regex=.rustup|.cargo/registry|.cargo/git/checkouts/bcs*|rustc",
        ],
        text=True,
        check=True,
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
    )
    (test_dir / "total_coverage.lcov").write_text(r.stdout)

    total_coverage = Coverage.parse(test_dir / "total_coverage.lcov")
    return total_coverage, single_file_covs


def append_coverage_to_file(name: str, coverage: Coverage, output_file: Path):
    """
    Appends coverage information to the specified output file.

    Args:
        coverage (Coverage): The coverage object to append.
        output_file (Path): The file to which the coverage will be appended.
    """
    with output_file.open("a") as f:
        f.write(f"## {name}\n")
        for file in coverage.files.values():
            for line in file.lines.values():
                if line.hit > 0:
                    f.write(f"{file.file_name}:{line.line_number}\n")


def find_unique_tests(
    baseline_cov: Coverage, tests: dict[str, Coverage], all_output_file: Path, smallest_output_file: Path
):
    """
    Finds tests that are unique to the provided coverage compared to the baseline.

    Args:
        baseline_cov (Coverage): The baseline coverage object.
        tests (dict[str, Coverage]): Dictionary of test names to their coverage objects.

    Returns:
        dict[str, Coverage]: Dictionary of unique tests and their coverage.
    """

    curr_max_cov = baseline_cov

    cnt = 0
    for test_name, cov in track(tests.items()):
        cnt += 1
        logger.info(f"Processing #{cnt} test: {test_name}")
        unique_cov = cov.unique_cov(baseline_cov)
        if unique_cov.total_cov().lines.covered != 0:
            append_coverage_to_file(test_name, unique_cov, all_output_file)
            logger.info(f"Found unique test: {test_name} with unique coverage {unique_cov.total_cov().lines.covered}")

        strict_unique = cov.unique_cov(curr_max_cov)
        if strict_unique.total_cov().lines.covered != 0:
            curr_max_cov = Coverage.union_all([curr_max_cov, strict_unique])
            append_coverage_to_file(test_name, strict_unique, smallest_output_file)
            logger.info(
                f"New smallest unique test: {test_name} with unique coverage {strict_unique.total_cov().lines.covered}"
            )


if __name__ == "__main__":
    r = run_one_test(Path("all_invalid/00bde779b9cd08cce98d085ccb60aa6c.move").read_text())
    print(f"{r.error_message}")
    print(f"{r.has_error}")
    print(f"{r.num_errors}")
    print(f"{r.has_bug}")
    print(f"{r.num_bugs}")
