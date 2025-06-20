from __future__ import annotations

import json
import os
import re
import socket
import subprocess
from collections import Counter, defaultdict
from pathlib import Path
from typing import Optional

import filelock
from loguru import logger


def next_available_port() -> int:
    """Find the next available port number for localhost."""
    sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    try:
        sock.bind(("localhost", 0))
        port = sock.getsockname()[1]
        sock.close()
        return int(port)
    except OSError:
        raise IOError("no free ports")


def create_new_env(env: Optional[dict]):
    if not env:
        return os.environ
    new_env = os.environ.copy()
    new_env.update(env)
    logger.info(f"Running with env: {env}")
    return new_env


def add_prefix_if_relative(prefix: Path, path: str | Path) -> Path:
    path = Path(path)
    if path.is_absolute():
        return path
    return prefix / path


def extract_top_level_sections(markdown_file: str | Path) -> dict[str, str]:
    sections = defaultdict(list)
    current_header = None

    content = Path(markdown_file).read_text()

    for line in content.splitlines():
        line = line.strip()

        # Match top-level header
        if re.match(r"^# [^#]", line):
            current_header = line[2:].strip()  # Extract header text
            sections[current_header] = []
        elif current_header:  # Collect content under the current header
            sections[current_header].append(line)

    # Convert list of lines into single strings
    return {header: "\n".join(content).strip() for header, content in sections.items()}


def generate_diff(left: str | Path, right: str | Path, diff_file: str | Path):
    diff_file = Path(diff_file)
    left_content = Path(left).read_text()
    right_content = Path(right).read_text()

    if left_content == right_content:
        diff_file.write_text("No diff")
    else:
        cmd = f"diff -U10000 -u {left} {right}  | diff2html -i stdin -F {diff_file} -s side -t Diff"
        subprocess.run(cmd, shell=True, check=True)


class FileLog:
    COUNTER_FILE = "counter.txt"

    def __init__(self, work_dir, extension="log") -> None:
        self.work_dir = Path(work_dir)
        self.work_dir.mkdir(parents=True, exist_ok=True)
        self.extension = extension
        self.load_counter()

    def save_counter(self) -> None:
        with filelock.FileLock(self.work_dir / "counter.lock"):
            counter_file = self.work_dir / self.COUNTER_FILE
            counter_file.write_text(json.dumps(self.counter, indent=2))

    def load_counter(self) -> None:
        with filelock.FileLock(self.work_dir / "counter.lock"):
            counter_file = self.work_dir / self.COUNTER_FILE
            if counter_file.exists():
                try:
                    self.counter = Counter(json.loads(counter_file.read_text()))
                except json.JSONDecodeError:
                    self.counter = Counter()
            else:
                logger.info(f"No counter file found at {counter_file}, starting with empty Counter.")
                self.counter = Counter()

    def new_log(self, name, content, extension="") -> Path:
        if extension:
            ext = extension
        else:
            ext = self.extension
        self.counter[name] += 1
        log_file = self.work_dir / f"{name}_{self.counter[name]}.{ext}"
        log_file.write_text(content)
        logger.trace(f"New log file written to: {log_file}")
        self.save_counter()
        return log_file
