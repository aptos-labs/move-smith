import sys
from pathlib import Path

from ..llm import LLMRecord

K = 20


def show_cost_of_llm_log_dir(log_dir: Path):
    total_cost = 0.0
    log_costs = []

    num_logs = 0
    for f in log_dir.rglob("*"):
        if not f.is_file():
            continue
        try:
            content = f.read_text(encoding="utf-8")
            record = LLMRecord.model_validate_json(content)
            cost = record.cost
            total_cost += cost
            log_costs.append((f, cost))
            num_logs += 1
        except Exception:
            print(f"Error reading file {f}: skipping...")
            continue

    print(f"Total cost for {num_logs} logs in {log_dir}: ${total_cost:.6f}")

    if num_logs > 0:
        avg_cost = total_cost / num_logs
        print(f"Average cost per log: ${avg_cost:.6f}")

        # Sort by cost (descending) and show top 5
        log_costs.sort(key=lambda x: x[1], reverse=True)
        top_k = log_costs[:K]

        print(f"\nTop {K} logs with highest cost:")
        for i, (path, cost) in enumerate(top_k, 1):
            print(f"{i}. ${cost:.6f} - {path}")
    else:
        print("No valid logs found.")


if __name__ == "__main__":
    log_dir = Path(sys.argv[1])
    show_cost_of_llm_log_dir(log_dir)
