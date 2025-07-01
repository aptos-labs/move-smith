from pathlib import Path

from .config import cfg
from .fast_coverage import FastCoverage
from .llm import run_in_parallel
from .runner import RunResult, run_one_test


def get_result_for_one_move_file(move_file_path: str) -> RunResult:
    code = Path(move_file_path).read_text()
    return run_one_test(code)


def reduced_set_achieving_unique_coverage(
    tests: list[Path], results: list[RunResult], covs: list[FastCoverage], baseline: FastCoverage
) -> list[tuple[Path, RunResult, FastCoverage, FastCoverage]]:
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
    return has_additional


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

    perfect_count = sum(1 for result in results if not result.has_error)
    line = f"Perfect tests: {perfect_count}/{len(results)} ({perfect_count / len(results) * 100:.2f}%)"
    print(line)
    report_lines.append(line)
    report_lines.append("")

    covs = [result.coverage for result in results]
    union = FastCoverage.union_all(covs)

    print(f"Baseline coverage: {baseline_cov.total_cov()}")
    report_lines.append("Baseline Coverage:")
    report_lines.append(baseline_cov.total_cov().pprint())
    report_lines.append("")
    print(f"Union of all tests coverage: {union.total_cov()}")
    report_lines.append("Union Coverage from all tests:")
    report_lines.append(union.total_cov().pprint())
    report_lines.append("")

    union_uniq = union.unique_cov(baseline_cov)
    print(f"All {len(covs)} tests in total uniquely covered: {union_uniq.total_cov()}")
    report_lines.append("Unique Coverage from all tests:")
    report_lines.append(union_uniq.total_cov().pprint())
    report_lines.append("")

    reduced_set = reduced_set_achieving_unique_coverage(move_files, results, covs, baseline_cov)
    line = f"{len(reduced_set)}/{len(move_files)} tests are needed to achieve all the unique coverage."
    print(line)
    report_lines.append(line)

    cnt = min(10, len(reduced_set))
    print(f"Top {cnt} tests (file: perfect, unique line cnt, unique branch cnt):")
    report_lines.append("# Reduced File Set -- (file: perfect, unique line cnt, unique branch cnt)")
    for test, result, _, uniq_cov in reduced_set:
        line = f"{test}: {not result.has_error}, {uniq_cov.total_cov().lines_covered()}, {uniq_cov.total_cov().branches_covered()}"
        if cnt > 0:
            print(line)
            cnt -= 1
        report_lines.append(line)

    report_lines.append("")
    report_lines.append("")
    report_lines.append("# Detailed unique lines for each test:")
    for test, result, _, uniq_cov in reduced_set:
        uniq_cov.copy_mappings(result_with_mapping.coverage)
        report_lines.append(f"## {test}")
        report_lines.append(f"Perfect: {result.has_error}")
        report_lines.append(uniq_cov.dump_lines())
        report_lines.append("")

    report_file.write_text("\n".join(report_lines))
