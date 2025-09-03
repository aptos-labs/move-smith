import subprocess
from pathlib import Path
from concurrent.futures import ThreadPoolExecutor, as_completed
import sys
import threading

done_lock = threading.Lock()
done_count = 0

CURR_FILE = Path(__file__).resolve()
MSMITH = CURR_FILE.parent.parent / "target/debug/msmith"

TO_IGNORE = ["graph.rs:396", "graph.rs:397"]


def run_move_file(base_dir: Path, file: Path, total: int):
    global done_count
    if not file.is_file():
        return None

    print(f"Processing: {file}")
    try:
        result = subprocess.run(
            [MSMITH.as_posix(), "--run", "v2-only", "run", file.absolute().as_posix(), "-o", "raw"],
            cwd=base_dir,
            stdout=subprocess.PIPE,
            stderr=subprocess.STDOUT,
            env={"TO_IGNORE_PATH": "NONE"},
            text=True,
        )
        ok = "Failure" not in result.stdout

        output_file = base_dir / (f"{file.stem}.success" if ok else f"{file.stem}.error")
        output_file.write_text(result.stdout)

        with done_lock:
            done_count += 1
            print(f"\033[92mDone {done_count}/{total}:\033[0m {file}")

        count_as_failed = not ok
        for ignore_pat in TO_IGNORE:
            if ignore_pat in result.stdout:
                count_as_failed = False
                break

        if count_as_failed:
            return str(file)
        else:
            return None

    except Exception as e:
        error_file = base_dir / f"{file.stem}.error"
        error_file.write_text(str(e))
        with done_lock:
            done_count += 1
            print(f"\033[92mDone {done_count}/{total}:\033[0m {file}")

        return str(file)


def main(base_path):
    base_dir = Path(base_path)
    if not base_dir.is_dir():
        print(f"Error: {base_path} is not a valid directory.")
        sys.exit(1)

    subdirs = [f for f in base_dir.glob("*.move") if f.is_file()]
    total = len(subdirs)
    failed = []

    with ThreadPoolExecutor(max_workers=32) as executor:
        future_to_dir = {executor.submit(run_move_file, base_dir, d, total): d for d in subdirs}
        for future in as_completed(future_to_dir):
            result = future.result()
            if result:
                failed.append(result)

    subprocess.run("cat *.error> combined.error", shell=True, cwd=base_dir)
    subprocess.run('grep "bug" combined.error | sort | uniq > bugs.txt', shell=True, cwd=base_dir)
    subprocess.run('grep "error" combined.error | sort | uniq > errors.txt', shell=True, cwd=base_dir)
    print(f"Combined errors written to {base_dir / 'combined.error'}")
    print(f"Bugs written to {base_dir / 'bugs.txt'}")
    print(f"Errors written to {base_dir / 'errors.txt'}")

    if failed:
        print("The following files failed to compile:")
        for f in failed:
            print(f)
    else:
        print("All files compiled successfully.")
    (base_dir / "failed_files.txt").write_text("\n".join(failed))

    failed_count = len(failed)
    print(f"Compilation rate: {total - failed_count}/{total} ({100 * (total - failed_count) / total:.2f}%)")


if __name__ == "__main__":
    if len(sys.argv) != 2:
        print(f"Usage: {sys.argv[0]} <directory_path>")
        sys.exit(1)

    main(sys.argv[1])
