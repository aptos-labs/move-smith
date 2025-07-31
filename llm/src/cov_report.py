from pathlib import Path

from .config import cfg
from .fast_coverage import FastCoverage
from .helper import run_in_parallel
from .runner import RunResult, run_one_test


def get_result_for_one_move_file(move_file_path: str) -> RunResult:
    code = Path(move_file_path).read_text()
    return run_one_test(code)


def save_paths(output_file: str | Path, paths: list[Path]) -> None:
    output_file = Path(output_file)
    output_file.write_text("\n".join(path.as_posix() for path in paths))
    print(f"Saved {len(paths)} paths to {output_file}")


def reduced_set_achieving_unique_coverage(
    tests: list[Path], results: list[RunResult], covs: list[FastCoverage], baseline: FastCoverage
) -> tuple[list[tuple[Path, RunResult, FastCoverage, FastCoverage]], FastCoverage]:
    """
    Find a small subset of all tests that achieves maximum unique coverage against the baseline.
    Each test in the output set has unique coverage against the baseline.
    This set could include failed tests.
    """
    has_additional = []
    curr_total = baseline

    for test, result, cov in zip(tests, results, covs):
        uniq_against_total = cov.unique_cov(curr_total)
        if uniq_against_total.total_cov().is_empty():
            # skip test that does not add any unique coverage against current total
            continue
        else:
            has_additional.append((test, result, cov, uniq_against_total))
            curr_total = curr_total.merge(uniq_against_total)
    has_additional.sort(key=lambda x: x[-1].total_cov().lines_covered(), reverse=True)
    return has_additional, curr_total


def reduced_successful_tests(
    tests: list[Path], results: list[RunResult], covs: list[FastCoverage]
) -> tuple[list[tuple[Path, RunResult, FastCoverage]], FastCoverage]:
    """
    Find a small subset of all successful tests that achieves maximum coverage from all successful tests.
    """
    has_additional = []
    curr_total = FastCoverage.empty()

    for test, result, cov in zip(tests, results, covs):
        if result.has_error:
            continue  # skip failed tests
        uniq_against_total = cov.unique_cov(curr_total)
        if uniq_against_total.total_cov().is_empty():
            # skip test that does not add any unique coverage against current total
            continue
        else:
            has_additional.append((test, result, cov))
            curr_total = curr_total.merge(uniq_against_total)
    has_additional.sort(key=lambda x: x[-1].total_cov().lines_covered(), reverse=True)
    return has_additional, curr_total


def report_coverage_for_dir(dir_path: str | Path, base_coverage_path: str | Path, output_dir: str | Path) -> None:
    dir_path = Path(dir_path)
    base_coverage_path = Path(base_coverage_path)
    output_dir = Path(output_dir)

    assert dir_path.is_dir(), f"Directory {dir_path} does not exist."
    assert base_coverage_path.is_file(), f"Base coverage file {base_coverage_path} does not exist."

    output_dir.mkdir(parents=True, exist_ok=True)
    report_file = output_dir / "coverage_report.md"
    report_lines = []

    move_files = list(dir_path.rglob("*.move"))
    line = f"Found {len(move_files)} Move files in {dir_path}"
    print(line)
    report_lines.append(line)
    report_lines.append("")

    result_with_mapping = run_one_test("", keep_mapping=True)
    baseline_cov = FastCoverage.parse_lcov_with_mapping(
        base_coverage_path,
        root="third_party",
        keep_only=["third_party"],
    )
    baseline_cov.convert_to_other_mapping(result_with_mapping.coverage)

    print(f"Executing {len(move_files)} tests...")

    args = [(file.as_posix(),) for file in move_files]
    results = run_in_parallel(cfg.fuzz.jobs, get_result_for_one_move_file, args)

    print(f"Executed {len(results)} tests.")

    errors = []
    oks = []
    for file, result in zip(move_files, results):
        if result.has_error:
            errors.append(f"# {file}")
            errors.append(f"{result.error_message}")
            errors.append("")
        else:
            oks.append(f"# {file}")
            oks.append(result.error_message)
            oks.append("")
    (output_dir / "errors_output.txt").write_text("\n".join(errors))
    (output_dir / "oks_output.txt").write_text("\n".join(oks))

    perfect_count = sum(1 for result in results if not result.has_error)
    line = f"Perfect tests: {perfect_count}/{len(results)} ({perfect_count / len(results) * 100:.2f}%)"
    print(line)
    report_lines.append(line)
    report_lines.append("")

    tests_with_error = [file for file, result in zip(move_files, results) if result.has_error]
    save_paths(output_dir / "tests_with_error.txt", tests_with_error)

    covs = [result.coverage for result in results]
    union = FastCoverage.union_all(covs)

    print(f"Baseline coverage: {baseline_cov.total_cov()}")
    report_lines.append("Baseline Coverage:")
    report_lines.append(baseline_cov.total_cov().pprint())
    report_lines.append("")
    print(f"Total coverage from fuzzing: {union.total_cov()}")
    report_lines.append("Union Coverage from all tests:")
    report_lines.append(union.total_cov().pprint())
    report_lines.append("")

    uncovered = baseline_cov.unique_cov(union)
    union_uniq = union.unique_cov(baseline_cov)
    print(f"All {len(covs)} tests in total uniquely covered: {union_uniq.total_cov()}")
    report_lines.append("Unique Coverage from all tests:")
    report_lines.append(union_uniq.total_cov().pprint())
    report_lines.append("")

    import json

    from .task import Task

    task_file = Path("task_info.json")
    task = Task(**json.loads(task_file.read_text()))
    uniq_interesting = union_uniq.keep_only(task.interesting_files)
    print(f"Unique coverage in interesting files: {uniq_interesting.total_cov()}")
    report_lines.append("Unique Coverage in interesting files:")
    report_lines.append(uniq_interesting.total_cov().pprint())
    report_lines.append("")

    print(f"Uncovered lines compared to baseline: {uncovered.total_cov()}")
    report_lines.append("Uncovered lines compared to baseline:")
    report_lines.append(uncovered.total_cov().pprint())
    report_lines.append("")

    # Reporting smaller set of tests for successful tests
    reduced_successful, succ_total = reduced_successful_tests(move_files, results, covs)
    line = (
        f"{len(reduced_successful)}/{len(move_files)} successful tests are needed to achieve all successful coverage."
    )
    print(line)
    report_lines.append(line)
    print(f"Total coverage from successful tests: {succ_total.total_cov()}")
    report_lines.append("Total coverage from successful tests:")
    report_lines.append(succ_total.total_cov().pprint())
    save_paths(output_dir / "reduced_successful_tests.txt", [test[0] for test in reduced_successful])

    # Reporting smaller set of tests for maximum unique coverage
    reduced_set_uniq_cov, uniq_total = reduced_set_achieving_unique_coverage(move_files, results, covs, baseline_cov)
    line = f"{len(reduced_set_uniq_cov)}/{len(move_files)} tests are needed to achieve all the unique coverage."
    print(line)
    report_lines.append(line)
    print(f"Total unique coverage from reduced set: {uniq_total.total_cov()}")
    report_lines.append("Total unique coverage from reduced set:")
    report_lines.append(uniq_total.total_cov().pprint())
    save_paths(output_dir / "reduced_set_uniq_cov.txt", [test[0] for test in reduced_set_uniq_cov])

    cnt = min(10, len(reduced_set_uniq_cov))
    print(f"Top {cnt} tests (file: perfect, unique line cnt, unique branch cnt):")
    report_lines.append("# Reduced File Set -- (file: perfect, unique line cnt, unique branch cnt)")
    for test, result, _, uniq_cov in reduced_set_uniq_cov:
        line = f"{test}: {not result.has_error}, {uniq_cov.total_cov().lines_covered()}, {uniq_cov.total_cov().branches_covered()}"
        if cnt > 0:
            print(line)
            cnt -= 1
        report_lines.append(line)

    report_lines.append("")
    report_lines.append("")
    report_lines.append("# Detailed unique lines for each test:")
    for test, result, _, uniq_cov in reduced_set_uniq_cov:
        uniq_cov.copy_mappings(result_with_mapping.coverage)
        report_lines.append(f"## {test}")
        report_lines.append(f"Perfect: {result.has_error}")
        report_lines.append(uniq_cov.dump_lines())
        report_lines.append("")

    report_file.write_text("\n".join(report_lines))


if __name__ == "__main__":
    from .config import DATA_DIR
    from .coverage import Coverage
    from .genetic import CUMULATIVE_COVERAGE_KEY
    from .store import Monitor

    monitor = Monitor()
    total_cov = monitor.store.get(CUMULATIVE_COVERAGE_KEY, Coverage)
    baseline_cov = Coverage.parse(DATA_DIR / "baseline.lcov")

    print("Total coverage:")
    print(total_cov.total_cov().pprint())
    print("=" * 20)
    print("Baseline coverage:")
    print(baseline_cov.total_cov().pprint())
    print("=" * 20)

    unique = total_cov.unique_cov(baseline_cov)
    print("Unique coverage compared to baseline:")
    print(unique.total_cov().pprint())

    print(unique.dump_lines().splitlines()[:10])
    print(baseline_cov.dump_lines().splitlines()[:10])
