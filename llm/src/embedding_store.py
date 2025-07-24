from __future__ import annotations

from abc import ABC, abstractmethod
from typing import Any, Generic, TypeVar, cast

import numpy as np
from loguru import logger
from redis.commands.search.field import TextField, VectorField
from redis.commands.search.index_definition import IndexDefinition, IndexType
from redis.commands.search.query import Query

from .embedding import encode_text
from .store import RedisStore


class ItemWithEmbedding(ABC):
    @abstractmethod
    def get_id(self) -> str:
        pass

    @abstractmethod
    def get_embedding(self) -> list[float]:
        pass

    @abstractmethod
    def to_redis_payload(self) -> Any:
        pass

    @classmethod
    @abstractmethod
    def from_redis_payload(cls, payload: Any) -> ItemWithEmbedding:
        pass


T = TypeVar("T", bound=ItemWithEmbedding)


class EmbeddingStore(Generic[T]):
    VECTOR_DIM = 768

    def __init__(self, name: str, item_cls: type[T] | None = None) -> None:
        self.store = RedisStore()
        name = name.lower()
        self.item_store_name = f"{name}_store"
        self.index_name = f"{name}_index"
        self._item_cls = item_cls

        self._create_index()

    def _create_index(self) -> None:
        try:
            self.store.client.ft(self.index_name).info()
        except:
            self.store.client.ft(self.index_name).create_index(
                [
                    TextField("item_id"),
                    TextField("item_score"),
                    VectorField(
                        "embedding", "HNSW", {"TYPE": "FLOAT32", "DIM": self.VECTOR_DIM, "DISTANCE_METRIC": "COSINE"}
                    ),
                ],
                definition=IndexDefinition(prefix=[f"{self.index_name}:"], index_type=IndexType.HASH),
            )

    def _index_item_key(self, item_id: str) -> str:
        return f"{self.index_name}:{item_id}"

    def add_item(self, item: ItemWithEmbedding):
        # Store embedding in vector index
        item_id = item.get_id()
        item_key = self._index_item_key(item_id)
        embedding = np.array(item.get_embedding(), dtype=np.float32).tobytes()

        self.store.client.hset(
            item_key,
            mapping={
                "item_id": item_id,
                "embedding": embedding,
            },
        )

        # Store item in item store
        self.store.client.hset(self.item_store_name, item_id, item.to_redis_payload())

    def get_item(self, item_id: str) -> T:
        data = self.store.client.hget(self.item_store_name, item_id)
        if data is None:
            raise KeyError(f"Item {item_id} not found")
        if isinstance(data, bytes):
            data = data.decode()

        return cast(T, self._item_cls.from_redis_payload(data))

    def remove_item(self, item_id: str) -> None:
        item_key = self._index_item_key(item_id)
        if self.store.client.exists(item_key):
            self.store.client.delete(item_key)
            self.store.client.hdel(self.item_store_name, item_id)

    def get_all_keys(self) -> list[str]:
        return [k.decode() for k in self.store.client.hkeys(self.item_store_name)]

    def get_all_items(self) -> list[T]:
        keys = self.get_all_keys()
        items = []
        for key in keys:
            item = self.get_item(key)
            items.append(item)
        return items

    def num_items(self) -> int:
        return self.store.client.hlen(self.item_store_name)

    def search(self, query_str: str, top_k: int = 5) -> list[T]:
        query_vector = np.array(encode_text(query_str), dtype=np.float32).tobytes()

        query = (
            Query(f"(*)=>[KNN {top_k} @embedding $query_vector AS similarity_score]")
            .sort_by("similarity_score")
            .return_fields(
                "item_id",
                "similarity_score",
            )
            .paging(0, top_k)
            .dialect(2)
        )

        results = self.store.client.ft(self.index_name).search(
            query,
            {
                "query_vector": query_vector,
            },
        )

        output = []
        for doc in results.docs:
            item_id = doc.item_id
            item = self.get_item(item_id)
            score = doc.similarity_score
            logger.trace(f"Search result: {item_id} with score {score}")
            output.append(item)
        return output
