from __future__ import annotations

from enum import Enum
from pathlib import Path

from loguru import logger
from pydantic import BaseModel

from .embedding import encode_text
from .embedding_store import EmbeddingStore, ItemWithEmbedding
from .llm import get_content_hash


class PromptPiece(BaseModel, ItemWithEmbedding):
    id: str
    content: str
    embedding: list[float] = []

    @classmethod
    def from_file(cls, file_path: str | Path) -> PromptPiece:
        file_path = Path(file_path)
        content = file_path.read_text(encoding="utf-8")
        id = get_content_hash(content)
        embedding = encode_text(content)
        logger.info(f"Loaded prompt piece from {file_path} with ID {id}")
        return cls(id=id, content=content, embedding=embedding)

    # For ItemWithEmbedding interface
    def get_id(self) -> str:
        return self.id

    def get_embedding(self) -> list[float]:
        return self.embedding

    def to_redis_payload(self) -> str:
        return self.model_dump_json()

    @classmethod
    def from_redis_payload(cls, payload: str) -> PromptPiece:
        item = cls.model_validate_json(payload)
        item.embedding = encode_text(item.content)
        return item


class PromptStoreName(str, Enum):
    MOVE_EXAMPLES = "move_examples"
    STATIC_ERROR_FIXES = "static_error_fixes"
    DYNAMIC_ERROR_FIXES = "dynamic_error_fixes"
    MUTATIONS = "mutations"


class PromptStore:
    def __init__(self) -> None:
        self.stores = {}
        for store_name in PromptStoreName:
            store_name_str = store_name.value
            self.stores[store_name_str] = EmbeddingStore(store_name_str, PromptPiece)

    def load_prompts_in_dir(self, store_name: PromptStoreName, path: str | Path) -> None:
        path = Path(path)
        store = self.get_store(store_name)
        logger.info(f"Loading prompts into prompt store: {store_name}")

        # For all files regardless of type, create a PromptPiece and store it
        cnt = 0
        for file_path in path.glob("*"):
            prompt_piece = PromptPiece.from_file(file_path)
            store.add_item(prompt_piece)
            cnt += 1

        logger.info(f"Loaded {cnt} prompts into store: {store_name}")

    def get_related_prompts(self, store_name: PromptStoreName, query: str, top_k: int) -> list[PromptPiece]:
        store = self.get_store(store_name)
        results = store.search(query, top_k=top_k)
        return results

    def get_all_prompts(self, store_name: PromptStoreName) -> list[PromptPiece]:
        store = self.get_store(store_name)
        return store.get_all_items()

    def get_store(self, store_name: PromptStoreName) -> EmbeddingStore[PromptPiece]:
        store = self.stores.get(store_name.value)
        if not store:
            raise ValueError(f"Prompt store {store_name.value} not found.")
        return store


if __name__ == "__main__":
    prompt_store = PromptStore()
    prompt_store.load_prompts_in_dir(PromptStoreName.MOVE_EXAMPLES, "/home/zijie/move-smith/llm/prompts/move_examples")
    related_prompts = prompt_store.get_related_prompts(
        PromptStoreName.MOVE_EXAMPLES, "Create a struct with drop ability.", top_k=5
    )
    for prompt in related_prompts:
        print(f"Found related prompt: {prompt.id} - {prompt.content[:50]}...")
