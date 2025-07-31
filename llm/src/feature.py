from __future__ import annotations

import hashlib
from enum import Enum

import numpy as np
from pydantic import BaseModel

from .config import ROOT
from .embedding import encode_text
from .embedding_store import ItemWithEmbedding

DEFAULT_FEATUIRE_STORE_PATH = ROOT / "data/features_store.json"


class FeatureType(str, Enum):
    USER = "User"
    TRANSACTIONAL_TEST = "TransactioanlTest"
    SOURCE_CODE = "SourceCode"
    DOCUMENTATION = "Documentation"
    PR = "PullRequest"
    MUTATION = "MUTATION"
    MERGE = "MERGE"


class Feature(BaseModel, ItemWithEmbedding):
    """
    Represents a feature.
    """

    id: str
    # Description is the "feature" that is summarized by the LLM.
    description: str = ""
    # Embedding is the vector representation of the description.
    embedding: list[float] = []

    # Content is what was summarized from
    content: str = ""

    type: FeatureType
    score: float = 1.0

    @classmethod
    def new_feature(cls, description: str, content: str, type: FeatureType) -> Feature:
        to_hash = f"{description}{content}{type}"
        id = hashlib.md5(to_hash.encode("utf-8")).hexdigest()
        item = cls(id=id, description=description, content=content, type=type, embedding=[])
        item._calculate_embedding()
        return item

    def short_repr(self) -> str:
        if len(self.description) < 50:
            return f"{self.id} ({self.type}): {self.description}"
        else:
            return f"{self.id} ({self.type}): {self.description[:50]}..."

    def _calculate_embedding(self) -> None:
        if len(self.embedding) == 0:
            self.embedding = encode_text(self.description)

    # ItemWithEmbedding interface methods
    def get_id(self) -> str:
        return self.id

    def get_embedding(self) -> list[float]:
        return self.embedding

    def get_score(self) -> float:
        return self.score

    def to_redis_payload(self) -> str:
        return self.model_dump_json()

    @classmethod
    def from_redis_payload(cls, payload: str) -> Feature:
        item = cls.model_validate_json(payload)
        item._calculate_embedding()
        return item


class FeatureCombination(BaseModel, ItemWithEmbedding):
    id: str
    features: list[Feature]
    embedding: list[float] = []

    @classmethod
    def new_combination(cls, features: list[Feature]) -> FeatureCombination:
        if len(features) == 0:
            raise ValueError("Cannot create a FeatureCombination with no features.")
        new_id = hashlib.md5("".join(f.get_id() for f in features).encode("utf-8")).hexdigest()
        item = cls(id=new_id, features=features, embedding=[])
        item._calculate_embedding()
        return item

    def _calculate_embedding(self) -> None:
        if len(self.embedding) == 0:
            self.embedding = np.mean([f.embedding for f in self.features], axis=0).tolist()

    def get_score(self) -> float:
        return float(np.mean([f.get_score() for f in self.features]))

    def short_repr(self) -> str:
        return "\n".join(f"{i+1}: {f.short_repr()}" for i, f in enumerate(self.features))

    def num_features(self) -> int:
        return len(self.features)

    # ItemWithEmbedding interface methods
    def get_id(self) -> str:
        return self.id

    def get_embedding(self) -> list[float]:
        return self.embedding

    def to_redis_payload(self) -> str:
        return self.model_dump_json()

    @classmethod
    def from_redis_payload(cls, payload: str) -> FeatureCombination:
        item = cls.model_validate_json(payload)
        item._calculate_embedding()
        return item
