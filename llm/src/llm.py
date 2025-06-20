from __future__ import annotations

import hashlib
import json
from dataclasses import dataclass
from multiprocessing import Pool
from pathlib import Path
from typing import Any, Literal, Optional

import tiktoken
from jinja2 import Template
from langchain_core.messages.ai import AIMessage
from langchain_core.messages.tool import ToolMessage
from langchain_core.tools import tool
from langchain_openai import ChatOpenAI
from langgraph.prebuilt import create_react_agent
from loguru import logger
from pydantic import BaseModel
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.metrics.pairwise import cosine_similarity

from .store import Monitor
from .utils import FileLog

MILLION = 1_000_000

MODEL_PRICING = {
    "gpt-4o": {"prompt": 2.50 / MILLION, "completion": 10.00 / MILLION},
    "gpt-4o-mini": {"prompt": 0.15 / MILLION, "completion": 0.60 / MILLION},
    "gpt-4.1": {"prompt": 2.00 / MILLION, "completion": 8.00 / MILLION},
    "gpt-4.1-mini": {"prompt": 0.40 / MILLION, "completion": 1.60 / MILLION},
    "gpt-4.1-nano": {"prompt": 0.10 / MILLION, "completion": 0.40 / MILLION},
    "gpt-4.5-preview": {"prompt": 75.00 / MILLION, "completion": 150.00 / MILLION},
    "codex-mini-latest": {"prompt": 1.50 / MILLION, "completion": 6.00 / MILLION},
}


def num_tokens_from_string(string, model_name) -> int:
    try:
        encoding = tiktoken.encoding_for_model(model_name)
    except KeyError:
        logger.warning(f"Warning: Model {model_name} not found. Using cl100k_base encoding.")
        encoding = tiktoken.get_encoding("cl100k_base")

    num_tokens = len(encoding.encode(string))
    return num_tokens


def cosine_sim(str1, str2) -> float:
    vect = TfidfVectorizer().fit_transform([str1, str2])
    return cosine_similarity(vect[0:1], vect[1:2])[0][0]


def get_content_hash(content) -> str:
    """Generate a hash for the content to use as a key."""
    return hashlib.md5(content.encode("utf-8")).hexdigest()


def run_in_parallel(jobs, function, args) -> list[Any]:
    with Pool(jobs) as p:
        results = p.starmap(function, args)
    return results


class BooleanAnswer(BaseModel):
    answer: bool


class IntegerAnswer(BaseModel):
    answer: int


def turn_idx_to_english(idx: int) -> str:
    """Turn 0-based index to english ordinal"""
    if idx == 0:
        return "first"
    elif idx == 1:
        return "second"
    elif idx == 2:
        return "third"
    else:
        return f"{idx + 1}th"


def load_prompt(prompt_file: str | Path, replacement: dict) -> str:
    prompt_path = Path(prompt_file)
    content = Path(prompt_path).read_text()
    template = Template(content)
    populated_prompt = template.render(replacement)
    return populated_prompt


def get_llm(model, temperature, _server, base_url=None) -> ChatOpenAI:
    # if server == "ollama":
    #     return ChatOllama(model=model, temperature=temperature, keep_alive="12h", base_url=base_url, num_ctx=64000)
    # elif server == "openai":
    if "o1" or "o3" in model:
        return ChatOpenAI(model=model, base_url=base_url)
    else:
        return ChatOpenAI(model=model, temperature=temperature, base_url=base_url)


def extract_last_markdown_code_block(text: str) -> tuple[bool, str]:
    """
    Extracts the last code block from markdown text.
    """
    blocks = extract_markdown_code_blocks(text)
    if blocks:
        return (True, blocks[-1])
    return (False, "Failed to extract code from LLM response")


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


class ModelConfig(BaseModel):
    model: str
    temperature: float
    server: Literal["openai", "ollama"]
    base_url: Optional[str]

    @staticmethod
    def get_by_name(name: str) -> ModelConfig:
        if name == "gpt-4o":
            return ModelConfig.gpt_4o()
        elif name == "gpt-4o-mini":
            return ModelConfig.gpt_4o_mini()
        elif name == "o3-mini":
            return ModelConfig.o3_mini()
        elif name == "gpt-4.1-nano":
            return ModelConfig.gpt_41_nano()
        else:
            raise ValueError(f"Unknown model name: {name}")

    @staticmethod
    def gpt_41_nano() -> ModelConfig:
        return ModelConfig(
            model="gpt-4.1-nano",
            temperature=0.5,
            server="openai",
            base_url=None,
        )

    @staticmethod
    def gpt_4o() -> ModelConfig:
        return ModelConfig(
            model="gpt-4o",
            temperature=0.5,
            server="openai",
            base_url=None,
        )

    @staticmethod
    def gpt_4o_mini() -> ModelConfig:
        return ModelConfig(
            model="gpt-4o-mini",
            temperature=0.5,
            server="openai",
            base_url=None,
        )

    @staticmethod
    def o3_mini() -> ModelConfig:
        return ModelConfig(
            model="o3-mini",
            temperature=0.5,
            server="openai",
            base_url=None,
        )


class LLMRecord(BaseModel):
    model: str
    prompt_tokens: int
    completion_tokens: int
    total_tokens: int
    reasoning_tokens: int
    prompt: str
    response: str | dict | list[dict]
    local_path: Path

    def cost_usd(self) -> tuple[float, float, float]:
        """
        Returns:
            tuple[float, float, float]: total_cost, prompt_cost, completion_cost (including reasoning tokens)
        """
        if self.model not in MODEL_PRICING:
            raise ValueError(f"Unknown model: {self.model}")

        pricing = MODEL_PRICING[self.model]

        prompt_cost = self.prompt_tokens * pricing["prompt"]
        completion_cost = self.completion_tokens * pricing["completion"] + self.reasoning_tokens * pricing["completion"]
        total = prompt_cost + completion_cost

        return total, prompt_cost, completion_cost

    def total_cost_usd(self) -> float:
        total, _, _ = self.cost_usd()
        return total

    @classmethod
    def from_file(cls, file_path: str | Path) -> LLMRecord:
        file_path = Path(file_path)
        if not file_path.exists():
            raise FileNotFoundError(f"File not found: {file_path}")
        content = json.loads(file_path.read_text(encoding="utf-8"))
        content["local_path"] = file_path
        return cls(**content)

    @classmethod
    def from_dir(cls, dir_path: str | Path) -> list[LLMRecord]:
        dir_path = Path(dir_path)
        if not dir_path.exists() or not dir_path.is_dir():
            raise ValueError(f"Path is not a directory: {dir_path}")

        records = []
        for file in dir_path.glob("llm_record_*.json"):
            record = cls.from_file(file)
            records.append(record)
        return records


@dataclass
class LLMManager:
    file_log: FileLog
    records: list[LLMRecord]

    @staticmethod
    def new(wkd: str | Path) -> LLMManager:
        file_log = FileLog(wkd, extension="json")
        return LLMManager(file_log=file_log, records=[])

    def get_model_by_name(self, name: str, temperature: float = 0.5) -> ModelWrapper:
        config = ModelConfig(model=name, temperature=temperature, server="openai", base_url=None)
        wrapper = ModelWrapper.from_config(config)
        if not wrapper:
            logger.error(f"Failed to get model by name: {name}")
            exit(1)
        wrapper.mgr = self
        return wrapper

    def get_model_by_config(self, config: ModelConfig) -> Optional[ModelWrapper]:
        wrapper = ModelWrapper.from_config(config)
        if not wrapper:
            return None
        wrapper.mgr = self
        return wrapper

    def record_prompt(self, prompt: str):
        self.file_log.new_log("prompt", prompt)

    def record_response(self, response: str):
        self.file_log.new_log("response", response)

    def record(
        self,
        model: str,
        prompt: str,
        response: str | dict | list[dict],
        prompt_tokens: int,
        completion_tokens: int,
        reasoning_tokens: int,
    ):
        record = LLMRecord(
            model=model,
            prompt=prompt,
            response=response,
            prompt_tokens=prompt_tokens,
            completion_tokens=completion_tokens,
            total_tokens=prompt_tokens + completion_tokens,
            reasoning_tokens=reasoning_tokens,
            local_path=Path("temp"),
        )
        self.save_record(record)

    def record_with_usage(self, model: str, prompt: str, response: str | dict | list[dict], usage: dict):
        if "completion_tokens_details" in usage:
            reasoning_tokens = usage["completion_tokens_details"].get("reasoning_tokens", 0)
        else:
            reasoning_tokens = 0
        record = LLMRecord(
            model=model,
            prompt=prompt,
            response=response,
            prompt_tokens=usage["prompt_tokens"],
            completion_tokens=usage["completion_tokens"],
            total_tokens=usage["total_tokens"],
            reasoning_tokens=reasoning_tokens,
            local_path=Path("temp"),
        )
        self.save_record(record)

    def save_record(self, record: LLMRecord):
        record.local_path = self.file_log.new_log("llm_record", record.model_dump_json(indent=4))
        self.records.append(record)
        monitor = Monitor()
        monitor.record_llm(record)

    def record_tool_use(self, model: str, prompt: str, msg: AIMessage | ToolMessage):
        if isinstance(msg, AIMessage):
            if not msg.tool_calls:
                return
            content = []
            for call in msg.tool_calls:
                d = {
                    "name": call["name"],
                    "args": call["args"],
                }
                content.append(d)
            # tool_call_msg = json.dumps(content)
            usage = msg.response_metadata["token_usage"]
            self.record_with_usage(
                model,
                prompt,
                content,
                usage=usage,
            )
        if isinstance(msg, ToolMessage):
            content = msg.content
            if not isinstance(content, str | dict):
                return
            self.record(model, "tool return", content, 0, 0, 0)


@dataclass
class ModelWrapper:
    model: str
    llm: ChatOpenAI
    mgr: Optional[LLMManager] = None
    code_retry_limit: int = 3

    @staticmethod
    def from_config(config: ModelConfig) -> Optional[ModelWrapper]:
        llm = get_llm(config.model, config.temperature, config.server, config.base_url)
        if not llm:
            return None
        wrapper = ModelWrapper(llm=llm, model=config.model)
        return wrapper

    def invoke_strucutred(self, message: str, response_format) -> tuple[Any, Any]:
        """Return (response, extracted message)"""
        if self.mgr:
            self.mgr.record_prompt(message)
        structured = self.llm.with_structured_output(response_format, include_raw=True)
        response = structured.invoke(message)
        parsed = response["parsed"]
        usage = response["raw"].response_metadata["token_usage"]
        if self.mgr:
            self.mgr.record_response(f"{parsed}")
            self.mgr.record_with_usage(
                model=self.model,
                prompt=message,
                response=parsed.__dict__,
                usage=usage,
            )
        return (response, parsed)

    def invoke_agent(self, message: str, tools, response_format=None, recursion_limit: int = 50) -> tuple[Any, Any]:
        """Return (response, extracted message)"""
        if self.mgr:
            self.mgr.record_prompt(message)
        agent = create_react_agent(self.llm, tools, response_format=response_format)
        response = agent.invoke({"messages": [("user", message)]}, {"recursion_limit": recursion_limit})

        last_msg = response["messages"][-1]
        content = last_msg.content
        for msg in response["messages"]:
            if isinstance(msg, AIMessage | ToolMessage) and self.mgr:
                self.mgr.record_tool_use(
                    model=self.model,
                    prompt=message,
                    msg=msg,
                )

        if self.mgr:
            self.mgr.record_response(content)
            self.mgr.record_with_usage(
                model=self.model,
                prompt=message,
                response=content,
                usage=last_msg.response_metadata["token_usage"],
            )
        if response_format is not None:
            return (last_msg, response["structured_response"])
        else:
            return (last_msg, content)

    def invoke_agent_code(self, message: str, tools, recursion_limit: int = 50) -> tuple[Any, str]:
        raw_content = ""
        code = ""
        retry_cnt = self.code_retry_limit
        while retry_cnt > 0:
            _, raw_content = self.invoke_agent(message, tools, recursion_limit=recursion_limit)
            (r, code) = extract_last_markdown_code_block(raw_content)
            if r:
                return (raw_content, code)
            logger.error("Failed to extract code from LLM response, retrying...")
            retry_cnt -= 1
        return (raw_content, code)

    def invoke(self, message: str) -> tuple[Any, str]:
        """Return (response, extracted message)"""
        if self.mgr:
            self.mgr.record_prompt(message)
        response = self.llm.invoke(message)
        content = response.content
        usage = response.response_metadata["token_usage"]
        if not isinstance(content, str):
            logger.error("Failed to get response content of type str")
            exit(1)
        if self.mgr:
            self.mgr.record_response(content)
            self.mgr.record_with_usage(
                model=self.model,
                prompt=message,
                response=content,
                usage=usage,
            )
        return (response, content)

    def invoke_code(self, message) -> tuple[str, str]:
        """Return (raw message, extracted code)"""
        raw_content = ""
        code = ""
        retry_cnt = self.code_retry_limit
        while retry_cnt > 0:
            _, raw_content = self.invoke(message)
            (r, code) = extract_last_markdown_code_block(raw_content)
            if r:
                return (raw_content, code)
            logger.error("Failed to extract code from LLM response, retrying...")
            retry_cnt -= 1
        return (raw_content, code)


@tool
def multiply(first_int: int, second_int: int) -> int:
    """Multiply two integers together."""
    print(f"Calling multiply with {first_int} and {second_int}")
    return first_int * second_int


@tool
def add(first_int: int, second_int: int) -> int:
    "Add two integers."
    print(f"Calling add with {first_int} and {second_int}")
    return first_int + second_int


@tool
def exponentiate(base: int, exponent: int) -> int:
    "Exponentiate the base to the exponent power."
    print(f"Calling exponentiate with {base} and {exponent}")
    return base**exponent


class Answer(BaseModel):
    answer: str


if __name__ == "__main__":
    mgr = LLMManager.new("test/llm")
    # model = mgr.get_model_by_name("gpt-4o-mini")
    model = mgr.get_model_by_name("o3-mini")
    if not model:
        exit(1)

    msg = "Write the code to calculate the factorial of a number in Python. The code should be put into a markdown code block."
    (raw_content, code) = model.invoke_code(msg)
    print(code)

    msg = "What is the capital of France?"
    (response, answer) = model.invoke_strucutred(msg, response_format=Answer)
    print(answer)

    tools = [multiply, add, exponentiate]
    msg = "Raise 3 to the power of 4, add 5 to the result, then multiply by 2. What is the final result? You should make tool calls."
    (response, content) = model.invoke_agent(msg, tools=tools)
    print(content)

    (response, answer) = model.invoke_agent(msg, tools=tools, response_format=Answer)
    print(answer)
    print(type(answer))

    msg = "If a red house is made of red bricks and a blue house is made of blue bricks, what is a greenhouse made of?"
    (response, answer) = model.invoke(msg)
    print(response)
    print(answer)
