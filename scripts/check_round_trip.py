import os
import subprocess
import multiprocessing as mp
import glob
import logging
from pathlib import Path
import shutil
from typing import Tuple, Optional
import re
import argparse

ROOT = Path(__file__).resolve().parent.parent

MSMITH_BIN = (ROOT / "target/debug/msmith").resolve()
MAX_WORKERS = mp.cpu_count() // 2

logging.basicConfig(level=logging.INFO, format="%(asctime)s - %(levelname)s - %(message)s")
logger = logging.getLogger(__name__)


def setup_directories(meta_work_dir: str):
    """Create necessary directories."""
    work_dir_base = os.path.join(meta_work_dir, "processing")
    error_log_file = os.path.join(meta_work_dir, "compilation_errors.log")
    failed_dirs_file = os.path.join(meta_work_dir, "failed_decompilation_dirs.txt")
    detailed_errors_file = os.path.join(meta_work_dir, "decompilation_errors_detailed.txt")

    os.makedirs(work_dir_base, exist_ok=True)
    os.makedirs(meta_work_dir, exist_ok=True)

    # Clear all log files
    with open(error_log_file, "w") as f:
        f.write("Compilation Error Report\n")
        f.write("=" * 50 + "\n\n")

    with open(failed_dirs_file, "w") as f:
        f.write("Directories with decompilation failures (normal compiled but decompiled failed):\n")
        f.write("=" * 80 + "\n")

    with open(detailed_errors_file, "w") as f:
        f.write("Detailed decompilation errors:\n")
        f.write("=" * 50 + "\n\n")

    return work_dir_base, error_log_file, failed_dirs_file, detailed_errors_file


def convert_cov_to_move(cov_file: str) -> Optional[str]:
    """Convert .cov file to .move file using msmith raw2move."""
    try:
        result = subprocess.run(
            [MSMITH_BIN, "raw2move", cov_file],
            capture_output=True,
            text=True,
            timeout=60,
        )
        if result.returncode == 0:
            return result.stdout
        else:
            logger.error(f"Failed to convert {cov_file}: {result.stderr}")
            return None
    except subprocess.TimeoutExpired:
        logger.error(f"Timeout converting {cov_file}")
        return None
    except Exception as e:
        logger.error(f"Error converting {cov_file}: {e}")
        return None


def check_compilation_errors(log_content: str) -> bool:
    """Check if compilation log contains errors (not just warnings)."""
    lines = log_content.strip().split("\n")
    for line in lines:
        # Look for actual errors, not warnings
        if re.search(r"\berror\b.*:", line, re.IGNORECASE):
            return True
        # Look for compilation failure indicators
        if re.search(
            r"(compilation failed|failed to compile|error occurred)",
            line,
            re.IGNORECASE,
        ):
            return True
    return False


def run_move_file(move_file_path: str, work_dir: str) -> Tuple[bool, bool]:
    """
    Run a Move file to check compilation.
    Returns (original_compiled, decompiled_compiled).
    """
    try:
        # Run with UB=1 to get both original and decompiled compilation logs
        env = os.environ.copy()
        env["UB"] = "1"
        subprocess.run(
            [MSMITH_BIN, "run", move_file_path, "-w", work_dir],
            capture_output=True,
            text=True,
            env=env,
            timeout=120,
        )

        # Check original compilation from outer .exp file
        original_log_path = f"{work_dir}/{Path(move_file_path).stem}.exp"
        original_compiled = False
        if os.path.exists(original_log_path):
            with open(original_log_path, "r") as f:
                log_content = f.read()
                # Consider it compiled if no compilation errors (warnings are OK)
                original_compiled = not check_compilation_errors(log_content)

        # Check decompiled compilation from round-trip directory
        decompiled_log_path = f"{work_dir}/round-trip/{Path(move_file_path).stem}.decompiled.exp"
        decompiled_compiled = False

        if os.path.exists(decompiled_log_path):
            with open(decompiled_log_path, "r") as f:
                log_content = f.read()
                # Consider it compiled if no compilation errors (warnings are OK)
                decompiled_compiled = not check_compilation_errors(log_content)

        return original_compiled, decompiled_compiled

    except subprocess.TimeoutExpired:
        logger.error(f"Timeout running {move_file_path}")
        return False, False
    except Exception as e:
        logger.error(f"Error running {move_file_path}: {e}")
        return False, False


def extract_error_lines(log_file_path: str) -> str:
    """Extract only the unique error lines from a log file."""
    if not os.path.exists(log_file_path):
        return "Log file not found"

    try:
        with open(log_file_path, "r") as f:
            content = f.read()

        error_lines = set()  # Use set to automatically deduplicate
        for line in content.split("\n"):
            line_stripped = line.strip()
            # Look for actual errors, not warnings
            if re.search(r"\berror\b.*:", line, re.IGNORECASE):
                error_lines.add(line_stripped)
            # Look for compilation failure indicators
            elif re.search(
                r"(compilation failed|failed to compile|error occurred)",
                line,
                re.IGNORECASE,
            ):
                error_lines.add(line_stripped)

        # Convert back to sorted list for consistent output
        unique_error_lines = sorted(list(error_lines)) if error_lines else []
        return "\n".join(unique_error_lines) if unique_error_lines else "No specific error lines found"
    except Exception as e:
        return f"Error reading log file: {e}"


def process_cov_file(args_tuple) -> Tuple[str, bool, bool, bool, str, str]:
    """
    Process a single .cov file.
    Returns (filename, original_compiled, decompiled_compiled, error_occurred, work_dir, error_details).
    """
    cov_file, work_dir_base = args_tuple
    filename = os.path.basename(cov_file)
    logger.info(f"Processing {filename}")

    work_dir = ""
    error_details = ""

    try:
        # Create work directory for this file
        work_dir = os.path.join(work_dir_base, filename.replace(".", "_"))
        os.makedirs(work_dir, exist_ok=True)

        # Convert .cov to .move
        move_content = convert_cov_to_move(cov_file)
        if move_content is None:
            return (
                filename,
                False,
                False,
                True,
                work_dir,
                "Failed to convert .cov to .move",
            )

        # Write .move file
        move_file_path = os.path.join(work_dir, f"{Path(filename).stem}.move")
        with open(move_file_path, "w") as f:
            f.write(move_content)

        # Run compilation tests
        original_compiled, decompiled_compiled = run_move_file(move_file_path, work_dir)

        # Check for inconsistency
        error_occurred = original_compiled and not decompiled_compiled

        if error_occurred:
            logger.warning(f"INCONSISTENCY: {filename} - original compiled but decompiled failed")
            # Extract error details from decompiled log
            decompiled_log_path = f"{work_dir}/round-trip/{Path(move_file_path).stem}.decompiled.exp"
            error_details = extract_error_lines(decompiled_log_path)

        return (
            filename,
            original_compiled,
            decompiled_compiled,
            error_occurred,
            work_dir,
            error_details,
        )

    except Exception as e:
        logger.error(f"Unexpected error processing {filename}: {e}")
        return filename, False, False, True, work_dir, f"Unexpected error: {e}"
    finally:
        # Only clean up work directory if NOT an inconsistency case
        # (normal compiled but decompiled failed should preserve the directory)
        if os.path.exists(work_dir):
            original_compiled = False
            decompiled_compiled = False
            try:
                # Re-check compilation status to decide whether to clean up
                move_file_path = os.path.join(work_dir, f"{Path(filename).stem}.move")
                if os.path.exists(move_file_path):
                    original_compiled, decompiled_compiled = run_move_file(move_file_path, work_dir)
            except:
                pass

            # Only remove if it's NOT the case where original compiled but decompiled failed
            if not (original_compiled and not decompiled_compiled):
                shutil.rmtree(work_dir, ignore_errors=True)


def log_error(
    error_log_file: str,
    filename: str,
    original_compiled: bool,
    decompiled_compiled: bool,
):
    """Log compilation error to file."""
    with open(error_log_file, "a") as f:
        f.write(f"File: {filename}\n")
        f.write(f"Original compiled: {original_compiled}\n")
        f.write(f"Decompiled compiled: {decompiled_compiled}\n")
        f.write("-" * 30 + "\n")


def log_decompilation_failure(
    failed_dirs_file: str,
    detailed_errors_file: str,
    filename: str,
    work_dir: str,
    error_details: str,
):
    """Log decompilation failure details to tracking files."""
    # Log directory path to the failed dirs file
    with open(failed_dirs_file, "a") as f:
        f.write(f"{work_dir}\n")

    # Log detailed error information
    with open(detailed_errors_file, "a") as f:
        f.write(f"Work Dir: {work_dir}\n")
        f.write(f"File: {filename}\n")
        f.write("Decompilation Errors:\n")
        f.write(f"{error_details}\n")
        f.write("-" * 60 + "\n\n")


def process_single_file_wrapper(args_tuple):
    """Wrapper function for multiprocessing."""
    return process_cov_file(args_tuple)


def parse_args():
    """Parse command line arguments."""
    parser = argparse.ArgumentParser(description="Process .cov files to check compilation consistency")
    parser.add_argument("--input-dir", help="Directory containing .cov files")
    parser.add_argument("--work-dir", help="Work directory for all processing files")
    parser.add_argument(
        "--limit",
        type=int,
        default=None,
        help="Limit number of files to process (default: process all files)",
    )
    parser.add_argument(
        "--jobs",
        type=int,
        default=MAX_WORKERS,
        help=f"Number of parallel processes (default: {MAX_WORKERS})",
    )
    return parser.parse_args()


def main():
    """Main processing function."""
    args = parse_args()
    work_dir_base, error_log_file, failed_dirs_file, detailed_errors_file = setup_directories(args.work_dir)
    cov_files = sorted(glob.glob(os.path.join(args.input_dir, "*.cov")))
    if args.limit:
        cov_files = cov_files[: args.limit]
        logger.info(f"Limiting to first {args.limit} files")

    logger.info(f"Found {len(cov_files)} .cov files to process")
    logger.info(f"Input directory: {args.input_dir}")
    logger.info(f"Work directory: {args.work_dir}")
    logger.info(f"Using {args.jobs} processes for parallel execution")

    if not cov_files:
        logger.error(f"No .cov files found in {args.input_dir}")
        return

    process_args = [(cov_file, work_dir_base) for cov_file in cov_files]
    results = []
    inconsistencies = []
    preserved_dirs = []

    with mp.Pool(processes=args.jobs) as pool:
        try:
            results_raw = pool.map(process_single_file_wrapper, process_args)
            for result in results_raw:
                (
                    filename,
                    original_compiled,
                    decompiled_compiled,
                    error_occurred,
                    work_dir,
                    error_details,
                ) = result
                results.append(result)
                if original_compiled and not decompiled_compiled:
                    inconsistencies.append(filename)
                    preserved_dirs.append(work_dir)
                    log_error(error_log_file, filename, original_compiled, decompiled_compiled)
                    log_decompilation_failure(
                        failed_dirs_file,
                        detailed_errors_file,
                        filename,
                        work_dir,
                        error_details,
                    )
        except KeyboardInterrupt:
            logger.info("Interrupted by user, terminating processes...")
            pool.terminate()
            pool.join()
            return
        except Exception as e:
            logger.error(f"Error in multiprocessing: {e}")
            return

    total_files = len(results)
    original_success = sum(1 for _, orig, _, _, _, _ in results if orig)
    decompiled_success = sum(1 for _, _, decomp, _, _, _ in results if decomp)
    inconsistent = len(inconsistencies)

    print("\n" + "=" * 60)
    print("PROCESSING SUMMARY")
    print("=" * 60)
    print(f"Total files processed: {total_files}")
    print(f"Original compilation success: {original_success}/{total_files} ({original_success/total_files*100:.1f}%)")
    print(
        f"Decompiled compilation success: {decompiled_success}/{total_files}"
        f" ({decompiled_success/total_files*100:.1f}%)"
    )
    print(f"Inconsistencies (orig OK, decomp failed): {inconsistent}")
    print(f"Preserved directories for manual inspection: {len(preserved_dirs)}")
    print(f"Error log saved to: {error_log_file}")
    print(f"Failed directories list saved to: {failed_dirs_file}")
    print(f"Detailed error information saved to: {detailed_errors_file}")
    print(f"All files contained in: {args.work_dir}")

    if inconsistencies:
        print(f"\nInconsistent files ({len(inconsistencies)}):")
        for filename in inconsistencies[:10]:  # Show first 10
            print(f"  - {filename}")
        if len(inconsistencies) > 10:
            print(f"  ... and {len(inconsistencies) - 10} more")

        print("\nPreserved directories for manual inspection:")
        for dir_path in preserved_dirs[:5]:  # Show first 5
            print(f"  - {dir_path}")
        if len(preserved_dirs) > 5:
            print(f"  ... and {len(preserved_dirs) - 5} more (see {failed_dirs_file} for full list)")


if __name__ == "__main__":
    mp.set_start_method("spawn", force=True)
    main()
