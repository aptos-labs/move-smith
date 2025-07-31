import hashlib
import os
from datetime import datetime
from multiprocessing import Pool
from pathlib import Path
from typing import Any

from loguru import logger


def write_log_file(work_dir, name, content, extension="log") -> Path:
    work_dir = Path(work_dir)
    work_dir.mkdir(parents=True, exist_ok=True)
    pid = os.getpid()
    timestamp = datetime.now().strftime("%Y%m%d_%H%M%S_%f")[:-3]  # YYYYMMDD_HHMMSS_mmm format

    filename = f"{timestamp}_{pid}_{name}.{extension}"
    log_file = work_dir / filename

    log_file.write_text(content)
    logger.trace(f"New log file written to: {log_file}")
    return log_file


def get_content_hash(content) -> str:
    """Generate a hash for the content to use as a key."""
    return hashlib.md5(content.encode("utf-8")).hexdigest()


def apply_func(args):
    func, real_args = args
    return func(*real_args)


def run_in_parallel(jobs, function, args) -> list[Any]:
    with Pool(jobs) as p:
        job_args = [(function, a) for a in args]
        results = list(p.imap(apply_func, job_args))
    return results
