from __future__ import annotations

import hashlib
from enum import Enum

from pydantic import BaseModel

from .config import ROOT

DEFAULT_FEATUIRE_STORE_PATH = ROOT / "data/features_store.json"


class FeatureType(str, Enum):
    TRANSACTIONAL_TEST = "TransactioanlTest"
    SOURCE_CODE = "SourceCode"
    DOCUMENTATION = "Documentation"
    MUTATION = "MUTATION"


class Feature(BaseModel):
    """
    Represents a feature.
    """

    id: str
    # Description is the "feature" that is summarized by the LLM.
    description: str = ""
    # Content is what was summarized
    content: str = ""
    type: FeatureType

    @classmethod
    def new_feature(cls, description: str, content: str, type: FeatureType) -> Feature:
        to_hash = f"{description}{content}{type}"
        id = hashlib.md5(to_hash.encode("utf-8")).hexdigest()
        return cls(id=id, description=description, content=content, type=type)
