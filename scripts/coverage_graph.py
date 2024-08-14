import re
import sys
import matplotlib.pyplot as plt
from pathlib import Path
import os
import datetime

def parse_libfuzzer_output(output_lines):
    coverage = []
    time_pass = []
    lines = [line for line in output_lines if line.startswith("#")]
    for idx, line in enumerate(lines):
        match = re.search(r"cov: (\d+)", line)
        if match:
            num = int(match.group(1))
        else:
            continue
        time_match = re.search(r"time: (\d+)", line)
        if time_match:
            tim = int(time_match.group(1)) / 3600
        else:
            continue
        if num != 0:
            if (
                len(coverage) != 0
                and num == coverage[-1]
                and idx != len(lines) - 1
            ):
                continue
            else:
                coverage.append(num)
                time_pass.append(tim)
    return time_pass, coverage


def plot_coverage(time_pass, coverage):
    plt.figure(figsize=(10, 6))
    plt.plot(time_pass, coverage, marker="o", linestyle="-", color="b")
    plt.xlabel("Hours")
    plt.ylabel("Block Coverage")
    plt.title("Coverage Over Time")
    plt.grid(True)
    plt.savefig("coverage.svg")
    plt.close()
    print("Coverage graph saved as 'coverage.svg'")

def name_to_time(x):
    date = x[0]
    if date == "running":
        dt = datetime.datetime.now()
    else:
        date = "-".join(date.split("-")[:2])
        dt = datetime.datetime.strptime(date, "%b-%d")

    return dt

def draw_comparison(wkd: Path):
    plt.figure(figsize=(12, 6))
    plt.xlabel("Hours")
    plt.ylabel("Block Coverage")
    plt.title("Coverage Over Time")
    plt.grid(True)

    data = []
    max_hour = 24
    for log in wkd.rglob("fuzz.log"):
        log = log.absolute()
        if "afl" in log.as_posix():
            continue
        run_name = log.parent.name

        output = open(log).readlines()
        time_pass, coverage = parse_libfuzzer_output(output)

        if run_name == "running":
            max_hour = time_pass[-1]

        data.append((run_name, time_pass, coverage))

    data.sort(key=name_to_time, reverse=True)

    # Read env variable to get the max hour
    env_max = os.getenv("MAX_HOUR")
    if env_max is not None:
        max_hour = int(env_max)
    else:
        max_hour += 0.01
    for (run_name, time_pass, coverage) in data:
        time_pass = [t for t in time_pass if t <= max_hour]
        coverage = coverage[: len(time_pass)]
        plt.plot(time_pass, coverage, marker="o", linestyle="-", label=run_name)
    plt.legend(loc=(1.04, 0))
    plt.tight_layout(rect=[0, 0, 0.9, 1])
    plt.savefig("coverage-comparison.svg")
    plt.close()
    print("Coverage graph saved as 'coverage-comparison.svg'")


if __name__ == "__main__":
    if len(sys.argv) == 1:
        draw_comparison(Path.cwd() / "vm-results")
    else:
        libfuzzer_output = open(sys.argv[1]).readlines()
        time_pass, coverage = parse_libfuzzer_output(libfuzzer_output)
        plot_coverage(time_pass, coverage)
