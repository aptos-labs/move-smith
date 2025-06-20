import sys
from pathlib import Path

from .llm import LLMRecord


def estimate_costs() -> None:
    pass


def show_cost_of_llm_log_dir(log_dir: Path):
    total_cost = 0.0
    total_promt_cost = 0.0
    total_completion_cost = 0.0

    records = LLMRecord.from_dir(log_dir)
    for r in records:
        total, prompt, completion = r.cost_usd()
        total_cost += total
        total_promt_cost += prompt
        total_completion_cost += completion
        print(
            f"{r.local_path}: {r.model}, {r.prompt_tokens} prompt tokens = ${prompt:.6f}, "
            f"{r.completion_tokens} completion tokens = ${completion:.6f}, "
            f"total = ${total:.6f}"
        )

    print(f"Total cost for all logs in {log_dir}: ${total_cost:.6f}")
    print(f"Total prompt cost: ${total_promt_cost:.6f}")
    print(f"Total completion cost: ${total_completion_cost:.6f}")


if __name__ == "__main__":
    log_dir = Path(sys.argv[1])
    show_cost_of_llm_log_dir(log_dir)
