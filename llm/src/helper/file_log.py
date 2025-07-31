import os
import time
from pathlib import Path

from loguru import logger


class FileLog:
    def __init__(self, work_dir, extension="log") -> None:
        self.work_dir = Path(work_dir)
        self.work_dir.mkdir(parents=True, exist_ok=True)
        self.extension = extension

    def new_log(self, name: str, content: str, extension: str = "") -> Path:
        """Create a new log file with process-local ordering."""
        pid = os.getpid()
        curr_time = int(time.time())
        ext = extension if extension else self.extension

        filename = f"{pid}_{curr_time}_{name}.{ext}"
        log_file = self.work_dir / filename

        log_file.write_text(content)
        logger.trace(f"New log file written to: {log_file}")
        return log_file
