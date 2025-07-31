from __future__ import annotations

from dataclasses import dataclass
from pathlib import Path
from typing import Optional, Type, TypeVar

from litellm import completion
from litellm.cost_calculator import completion_cost, cost_per_token
from litellm.utils import token_counter
from loguru import logger
from pydantic import BaseModel

from .helper import write_log_file
from .store import Monitor

T = TypeVar("T", bound=BaseModel)


def load_extra_promts_from_files(files: list[str | Path]) -> str:
    prompts = []
    for file in files:
        file_path = Path(file)
        content = file_path.read_text(encoding="utf-8")
        prompts.append(content)
    return "\n".join(prompts)


def extract_markdown_code_blocks(text: str) -> list[str]:
    """
    Extracts the first code block from markdown text.
    """
    blocks = [[]]
    in_code_block = False

    for line in text.splitlines():
        if line.startswith("```"):
            in_code_block = not in_code_block
            if not in_code_block:
                blocks.append([])
        else:
            if in_code_block:
                blocks[-1].append(line)

    return ["\n".join(block) for block in blocks if block]


class Message(BaseModel):
    role: str
    content: str

    @classmethod
    def from_litellm_message(cls, msg) -> Message:
        return Message(role=msg.role, content=msg.content)

    @classmethod
    def new_messages(cls, messages: list[tuple[str, str]]) -> list[Message]:
        return [cls(role=role, content=content) for role, content in messages]

    @classmethod
    def new_sys_and_user(cls, system: str, user: str) -> list[Message]:
        return [
            cls(role="system", content=system),
            cls(role="user", content=user),
        ]

    @classmethod
    def to_dicts(cls, messages: list[Message]) -> list[dict[str, str]]:
        return [msg.model_dump() for msg in messages]

    def to_type(self, typ: Type[T]) -> T:
        return typ.model_validate_json(self.content)

    def extract_last_code_block(self) -> Optional[str]:
        blocks = extract_markdown_code_blocks(self.content)
        return blocks[-1] if blocks else None


class LLMRecord(BaseModel):
    model: str
    temperature: float
    input: list[Message]
    output: Message
    cost: float

    def get_input_token_count(self) -> int:
        return token_counter(model=self.model, messages=Message.to_dicts(self.input))

    def get_output_token_count(self) -> int:
        return token_counter(model=self.model, messages=[self.output.model_dump()])


@dataclass
class LLMWrapper:
    log_dir: Path

    @classmethod
    def new(cls, log_dir: str | Path) -> LLMWrapper:
        log_dir = Path(log_dir)
        return cls(log_dir=log_dir)

    def save_record(self, record: LLMRecord) -> Path:
        monitor = Monitor()
        monitor.record_llm(record)
        return write_log_file(self.log_dir, "llm_record", record.model_dump_json(indent=2))

    def invoke(self, model: str, temperature: float, messages: list[Message]) -> Message:
        response = completion(
            model=model,
            messages=Message.to_dicts(messages),
            temperature=temperature,
        )

        cost = completion_cost(completion_response=response)
        output = Message.from_litellm_message(response.choices[0].message)

        record = LLMRecord(
            model=model,
            temperature=temperature,
            input=messages,
            output=output,
            cost=float(cost),
        )
        self.save_record(record)
        return record.output

    def invoke_structured(
        self, model: str, temperature: float, messages: list[Message], response_format: Type[T]
    ) -> Optional[T]:
        try_cnt = 0
        max_try = 3
        while try_cnt < max_try:
            item = self._invoke_structured(model, temperature, messages, response_format)
            if item is None:
                try_cnt += 1
                logger.error(f"Error generating structured output. Retrying {try_cnt}/{max_try}...")
                if try_cnt >= max_try:
                    logger.error("Max retry attempts reached. Returning None.")
                    return None
            else:
                return item

    def _invoke_structured(
        self, model: str, temperature: float, messages: list[Message], response_format: Type[T]
    ) -> Optional[T]:
        response = completion(
            model=model,
            messages=Message.to_dicts(messages),
            temperature=temperature,
            response_format=response_format,
        )

        cost = completion_cost(completion_response=response)
        output = Message.from_litellm_message(response.choices[0].message)

        record = LLMRecord(
            model=model,
            temperature=temperature,
            input=messages,
            output=output,
            cost=float(cost),
        )
        log_file = self.save_record(record)
        try:
            return output.to_type(response_format)
        except Exception:
            logger.error(f"Model failed to follow response format, logged to {log_file}")
            return None

    def invoke_and_extract_code(
        self, model: str, temperature: float, messages: list[Message], retry_attempts: int
    ) -> Optional[str]:
        retry_cnt = 0
        while retry_cnt < retry_attempts:
            msg = self.invoke(model, temperature, messages)
            code_block = msg.extract_last_code_block()
            if code_block:
                return code_block
            retry_cnt += 1
        return None

    def estimate_cost(self, model: str, messages: list[Message], estimate_output_tokens: int) -> float:
        input_tokens = token_counter(model=model, messages=Message.to_dicts(messages))
        in_cost, out_cost = cost_per_token(
            model=model, prompt_tokens=input_tokens, completion_tokens=estimate_output_tokens
        )
        return in_cost + out_cost


if __name__ == "__main__":
    import os

    from .config import cfg

    os.environ["ANTHROPIC_API_KEY"] = cfg.anthropic_api_key
    os.environ["OPENAI_API_KEY"] = cfg.openai_api_key

    model = "claude-sonnet-4-20250514"

    llm = LLMWrapper.new("test")
    msg = llm.invoke(model, 0.7, [Message(role="user", content="Hello!")])
    print(msg.content)

    code = llm.invoke_and_extract_code(
        model=model,
        temperature=0.5,
        messages=[Message(role="user", content="Write a Python function to add two numbers.")],
        retry_attempts=3,
    )
    print(code)

    class DivAnswer(BaseModel):
        quotient: int
        remainder: int

    response = llm.invoke_structured(
        model=model,
        temperature=0.5,
        messages=[Message(role="user", content="Divide 10 by 3.")],
        response_format=DivAnswer,
    )
    print(type(response))
    print(f"Received={response}")
