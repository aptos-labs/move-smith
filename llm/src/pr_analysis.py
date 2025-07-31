from __future__ import annotations

from dataclasses import dataclass
from pathlib import Path
from typing import Optional

from github import Auth, Github
from loguru import logger

from .config import DATA_DIR, cfg
from .helper import run_in_parallel

APTOS_CORE = "aptos-labs/aptos-core"


@dataclass
class FileChange:
    filename: str
    status: str  # "added", "modified", "removed", "renamed"
    additions: int
    deletions: int
    changes: int
    patch: Optional[str] = None

    def render_patch(self) -> str:
        if self.status == "removed":
            return f"File removed: {self.filename} (-{self.deletions} lines)\n"
        elif self.status == "renamed":
            if " => " in self.filename:
                old_name, new_name = self.filename.split(" => ", 1)
                header = f"File renamed: {old_name.strip()} -> {new_name.strip()}"
            else:
                header = f"File renamed: {self.filename}"

            if self.patch:
                return f"{header}\n{self.patch}\n"
            else:
                return f"{header} (no content changes)\n"
        elif self.status == "added":
            header = f"New file: {self.filename} (+{self.additions} lines)"
            if self.patch:
                return f"{header}\n{self.patch}\n"
            else:
                return f"{header}\n"
        elif self.status == "modified":
            header = f"Modified: {self.filename} (+{self.additions} -{self.deletions})"
            if self.patch:
                return f"{header}\n{self.patch}\n"
            else:
                return f"{header} (no diff available)\n"
        else:
            header = f"{self.status}: {self.filename}"
            if self.patch:
                return f"{header}\n{self.patch}\n"
            else:
                return f"{header}\n"


FILTER_PATTERNS = [
    "mvir",
    ".exp",
    ".v2_exp",
    "Cargo.lock",
]


@dataclass
class PRInfo:
    number: int
    title: str
    description: str
    url: str
    files_changed: list[FileChange]

    @classmethod
    def new_aptos(cls, pr_number: int) -> PRInfo:
        return cls.new(APTOS_CORE, pr_number)

    @classmethod
    def new(cls, repo_name: str, pr_number: int) -> PRInfo:
        gh = Github(auth=Auth.Token(cfg.GITHUB_TOKEN))
        repo = gh.get_repo(repo_name)
        pr = repo.get_pull(pr_number)

        files_changed = []
        files = pr.get_files()

        for file in files:
            skip = False
            for pattern in FILTER_PATTERNS:
                if pattern in file.filename:
                    logger.trace(f"Skipping file {file.filename} due to filter pattern '{pattern}'")
                    skip = True
                    break
            if skip:
                continue
            files_changed.append(
                FileChange(
                    filename=file.filename,
                    status=file.status,
                    additions=file.additions,
                    deletions=file.deletions,
                    changes=file.changes,
                    patch=file.patch,
                )
            )

        return cls(
            number=pr.number,
            title=pr.title,
            description=pr.body or "No description provided",
            url=pr.html_url,
            files_changed=files_changed,
        )

    def get_all_diffs(self) -> str:
        """Return all code diffs as a single string"""
        all_diffs = ""
        for file_change in self.files_changed:
            rendered = file_change.render_patch()
            if rendered.strip():
                all_diffs += f"\n--- {rendered}"
        return all_diffs


def load_one(pr_num: int) -> PRInfo:
    logger.info(f"Loading PR #{pr_num}")
    return PRInfo.new(APTOS_CORE, pr_num)


def get_move_related_prs(scan_new: bool) -> list[PRInfo]:
    # PR_NUM_FILE = DATA_DIR / "move_prs.txt"
    # PR_NUM_FILE = DATA_DIR / "move_prs1.txt"
    # PR_NUM_FILE = DATA_DIR / "move_prs2.txt"
    PR_NUM_FILE = DATA_DIR / "move_prs3.txt"
    # PR_NUM_FILE = DATA_DIR / "move_prs4.txt"
    # PR_NUM_FILE = DATA_DIR / "move_prs5.txt"
    # PR_NUM_FILE = DATA_DIR / "move_prs6.txt"
    # PR_NUM_FILE = DATA_DIR / "move_prs7.txt"
    parsed_prs_content = PR_NUM_FILE.read_text().strip()
    parsed_pr_nums = [int(line) for line in parsed_prs_content.splitlines()]
    logger.info(f"Found {len(parsed_pr_nums)} previously recorded PRs: {parsed_pr_nums}")

    if scan_new:
        scan_stop = max(parsed_pr_nums) if parsed_pr_nums else 1
        new_prs = _scan_for_move_related_prs(scan_stop, PR_NUM_FILE)
        logger.info(f"Found {len(new_prs)} move-related PRs from scan.")
    else:
        new_prs = []

    logger.info(f"Loading {len(new_prs)} PR info.")

    parsed_prs = run_in_parallel(cfg.fuzz.jobs, load_one, [(pr_num,) for pr_num in parsed_pr_nums])
    new_prs.extend(parsed_prs)

    logger.info(f"Total move-related PRs: {len(new_prs)}")

    new_pr_nums = sorted([pr.number for pr in new_prs])
    PR_NUM_FILE.write_text("\n".join(map(str, new_pr_nums)))

    return new_prs


def _scan_for_move_related_prs(scan_stop: int, output_file: Path) -> list[PRInfo]:
    CHECK_PATH = [
        "move-compiler",
        "move-compiler-v2",
        "move-vm",
        "move-bytecode-verifier",
    ]
    gh = Github(auth=Auth.Token(cfg.GITHUB_TOKEN))
    repo = gh.get_repo(APTOS_CORE)
    prs = repo.get_pulls(state="closed", sort="created", base="main")

    move_related_prs = []

    for pr in prs.reversed:
        if pr.number <= scan_stop:
            logger.info(f"Reached PR #{pr.number}, stopping scan.")
            break

        if not pr.merged:
            continue

        logger.info(f"Checking PR #{pr.number}")
        done = False
        for file in pr.get_files():
            if done:
                break
            for to_check in CHECK_PATH:
                if done:
                    break
                if to_check in file.filename:
                    move_related_prs.append(PRInfo.new(APTOS_CORE, pr.number))
                    done = True
        if done:
            logger.info(f"PR #{pr.number} is move-related")
            with output_file.open("a") as f:
                f.write(f"{pr.number}\n")
        else:
            logger.info(f"PR #{pr.number} is not move-related")

    return move_related_prs


if __name__ == "__main__":
    get_move_related_prs(True)
