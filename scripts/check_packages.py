import subprocess
from pathlib import Path
from concurrent.futures import ThreadPoolExecutor, as_completed
import sys
import threading

done_lock = threading.Lock()
done_count = 0


def compile_move_project(directory: Path, total: int):
    global done_count
    if not directory.is_dir():
        return None

    print(f"Processing: {directory}")
    aptos_bin = Path("~/aptos-core/target/release/aptos").expanduser()
    try:
        result = subprocess.run(
            [aptos_bin.as_posix(), "move", "compile", "--language-version", "2.2"],
            cwd=directory,
            stdout=subprocess.PIPE,
            stderr=subprocess.STDOUT,
            text=True,
        )
        output_file = directory / ("compile.success" if result.returncode == 0 else "compile.error")
        output_file.write_text(result.stdout)

        with done_lock:
            done_count += 1
            print(f"\033[92mDone {done_count}/{total}:\033[0m {directory}")

        return None if result.returncode == 0 else str(directory)

    except Exception as e:
        error_file = directory / "compile.error"
        error_file.write_text(str(e))
        with done_lock:
            done_count += 1
            print(f"\033[92mDone {done_count}/{total}:\033[0m {directory}")

        return str(directory)


def main(base_path):
    base_dir = Path(base_path)
    if not base_dir.is_dir():
        print(f"Error: {base_path} is not a valid directory.")
        sys.exit(1)

    subdirs = [d for d in base_dir.iterdir() if d.is_dir()]
    total = len(subdirs)
    failed = []

    with ThreadPoolExecutor(max_workers=24) as executor:
        future_to_dir = {executor.submit(compile_move_project, d, total): d for d in subdirs}
        for future in as_completed(future_to_dir):
            result = future.result()
            if result:
                failed.append(result)

    subprocess.run("cat **/compile.error > combined.error", shell=True, cwd=base_dir)
    subprocess.run('grep "bug" combined.error | sort | uniq > bugs.txt', shell=True, cwd=base_dir)
    subprocess.run('grep "error" combined.error | sort | uniq > errors.txt', shell=True, cwd=base_dir)
    print(f"Combined errors written to {base_dir / 'combined.error'}")
    print(f"Bugs written to {base_dir / 'bugs.txt'}")
    print(f"Errors written to {base_dir / 'errors.txt'}")

    if failed:
        print("The following directories failed to compile:")
        for d in failed:
            print(d)
    else:
        print("All directories compiled successfully.")
    (base_dir / "failed_packages.txt").write_text("\n".join(failed))

    failed_count = len(failed)
    print(f"Compilation rate: {total - failed_count}/{total} ({100 * (total - failed_count) / total:.2f}%)")


if __name__ == "__main__":
    if len(sys.argv) != 2:
        print(f"Usage: {sys.argv[0]} <directory_path>")
        sys.exit(1)

    main(sys.argv[1])
