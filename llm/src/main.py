from __future__ import annotations

import argparse
import json
import os
from pathlib import Path

from loguru import logger

from .config import cfg
from .feature_rust import extract_features_from_rust
from .feature_transactional import extract_features_from_transactional_tests
from .genetic import fuzzing_loop, show_fuzzing_stat
from .store import Monitor, docker_down, docker_up, redis_up_with_override
from .task import Task


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
    show_fuzzing_stat(save_unique_lines=False)


def handle_extract(args) -> None:
    if args.compiler_code:
        logger.info("Extracting features from compiler source code...")
        extract_features_from_rust(args.regenerate)

    if args.transactional_test:
        logger.info("Extracting features from transactional tests...")
        extract_features_from_transactional_tests(args.regenerate)


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

    # === Extract subcommand ===
    extract_parser = subparsers.add_parser("extract", help="Extract features")
    extract_parser.add_argument("--regenerate", action="store_true", help="Regenerate even if features already exist")
    extract_parser.add_argument(
        "--compiler-code", action="store_true", help="Extract features from compiler source code"
    )
    extract_parser.add_argument(
        "--transactional-test", action="store_true", help="Extract features from transactional tests"
    )

    # === Flush subcommand ===
    subparsers.add_parser("flush", help="Flush Redis store")

    for subparser in [fuzz_parser, inspect_parser, extract_parser]:
        subparser.add_argument(
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
    logger.debug(f"Current configuration: {cfg.to_dict()}")

    cfg.work_dir.mkdir(parents=True, exist_ok=True)

    if args.command == "fuzz":
        handle_fuzz(args)
    elif args.command == "inspect":
        handle_inspect(args)
    elif args.command == "extract":
        handle_extract(args)


if __name__ == "__main__":
    main()
