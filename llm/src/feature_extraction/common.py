from typing import Optional

from loguru import logger
from pydantic import BaseModel

from ..config import cfg
from ..llm import LLMWrapper, Message

COMMON_SYSTEM_PROMPT = """You are an Move on Aptos expert writing test descriptions.

You are tasked with writing concise descriptions of how you might test or use a Move language feature based on the provided content.

Each description should be a single imperative sentence.

If a feature is not testable by only writing Move code, or is not Move-related, you should not give a test description.
"""

COMMON_PROMPT = """
Please write the test descriptions based on the provided content.

Make sure the summaries are concise: each should be no longer than 200 words.

If you can summarize multiple descriptions from the provided content, please follow the given format and populate the `descriptions` list.

Make sure you are the JSON field `descriptions` is a list of strings, where each string is a test description.

If the provided content is irrelevant, not actionable, or does not contain any Move-related information, return an empty list.
"""


class TestDescriptions(BaseModel):
    descriptions: list[str]


def common_invoke_llm(name: str, prompt: str, estimated_cost_limit: float) -> Optional[TestDescriptions]:
    llm = LLMWrapper(cfg.logs_dir)
    msgs = Message.new_sys_and_user(COMMON_SYSTEM_PROMPT, prompt)
    estimated_cost = llm.estimate_cost(
        model=cfg.models.extract.name,
        messages=msgs,
        estimate_output_tokens=150,
    )

    if estimated_cost > estimated_cost_limit:
        logger.warning(f"Estimated cost {estimated_cost} exceeds max cost {estimated_cost_limit}. Skipping {name}.")
        return None

    response = llm.invoke_structured(
        model=cfg.models.extract.name,
        temperature=cfg.models.extract.temperature,
        messages=msgs,
        response_format=TestDescriptions,
    )

    return response
