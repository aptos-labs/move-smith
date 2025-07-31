from __future__ import annotations

import argparse
import json
import os
from pathlib import Path

from loguru import logger

from .config import cfg
from .cov_report import report_coverage_for_dir
from .embedding import load_embedding_model
from .feature_extraction import handle_extract, register_extraction_args
from .genetic import fuzzing_loop, show_fuzzing_stat
from .initial import run_from_pr
from .store import Monitor, docker_down, docker_up, redis_up_with_override
from .task import Task


def handle_pr(args) -> None:
    run_from_pr(args.pr_number)


def handle_fuzz(args) -> None:
    task = Task(**json.loads(args.task.read_text()))
    cfg.set("task", task)

    docker_up("redis")
    docker_up("grafana")

    monitor = Monitor()
    if args.flush_redis:
        logger.info("Flushing Redis store...")
        monitor.store.client.flushdb()

    if monitor.reached_total_cost_limit():
        logger.warning("Total cost limit reached. Exiting.")
        return

    fuzzing_loop()
    print("Done fuzzing!")


def handle_inspect(args) -> None:
    dump_path = args.work_dir / "dump.rdb"
    if not dump_path.exists():
        logger.error(f"Dump file {dump_path} does not exist. Please run fuzzing first.")
        return

    docker_up("grafana")
    redis_up_with_override(dump_path)
    if not args.skip_report:
        show_fuzzing_stat(save_unique_lines=False)


def handle_coverage(args) -> None:
    report_coverage_for_dir(
        dir_path=args.work_dir,
        base_coverage_path=args.baseline,
        output_dir=args.output_dir,
    )


def handle_flush() -> None:
    docker_down("redis")
    docker_down("grafana")
    docker_up("redis")
    docker_up("grafana")
    Monitor()


def main() -> None:
    parser = argparse.ArgumentParser(description="Run the main script with specified parameters.")
    subparsers = parser.add_subparsers(dest="command", required=True, help="Sub-command to run")

    # === Fuzz subcommand ===
    fuzz_parser = subparsers.add_parser("fuzz", help="Run fuzzing")
    fuzz_parser.add_argument("--task", type=Path, required=True, help="Task info file to use")
    fuzz_parser.add_argument("--flush-redis", action="store_true", help="Clear Redis store")

    # === Inspect subcommand ===
    inspect_parser = subparsers.add_parser("inspect", help="Inspect a previous run")
    inspect_parser.add_argument("--skip-report", action="store_true", help="Skip reporting unique lines")

    # === Extract subcommand ===
    extract_parser = subparsers.add_parser("extract", help="Extract features")
    register_extraction_args(extract_parser)

    # === Coverage subcommand ===
    coverage_parser = subparsers.add_parser(
        "coverage", help="Report coverage of a corpus of Move tests against a baseline coverage"
    )
    coverage_parser.add_argument("-b", "--baseline", type=Path, required=True, help="Base coverage file in LCOV format")
    coverage_parser.add_argument("-o", "--output-dir", type=Path, required=True, help="Output directory for reports")

    # === PR subcommand ===
    pr_parser = subparsers.add_parser("pr", help="Generate tests and run fuzzing for a specific PR")
    pr_parser.add_argument("pr_number", type=int, help="Pull request number to run fuzzing for")

    # === Flush subcommand ===
    subparsers.add_parser("flush", help="Flush Redis store")

    for subparser in [fuzz_parser, inspect_parser, extract_parser, coverage_parser, pr_parser]:
        subparser.add_argument(
            "-d",
            "--work-dir",
            type=Path,
            default=Path("work"),
            help="Work directory (default: ./work)",
        )

    args = parser.parse_args()
    if args.command == "flush":
        handle_flush()
        return

    cfg.set("work_dir", args.work_dir.absolute())
    cfg.set("logs_dir", cfg.work_dir / "logs")
    os.environ["OPENAI_API_KEY"] = cfg.openai_api_key
    os.environ["ANTHROPIC_API_KEY"] = cfg.anthropic_api_key
    logger.debug(f"Current configuration: {cfg.to_dict()}")

    cfg.work_dir.mkdir(parents=True, exist_ok=True)

    load_embedding_model()

    if args.command == "fuzz":
        handle_fuzz(args)
    elif args.command == "inspect":
        handle_inspect(args)
    elif args.command == "extract":
        handle_extract(args)
    elif args.command == "coverage":
        handle_coverage(args)
    elif args.command == "pr":
        handle_pr(args)


if __name__ == "__main__":
    main()
