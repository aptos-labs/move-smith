from __future__ import annotations

from pydantic import BaseModel


class Task(BaseModel):
    goals: list[str]
    features: list[str]
    interesting_files: list[str]
    seed_store: str

    @classmethod
    def empty(cls) -> Task:
        return cls(goals=[], features=[], interesting_files=[], seed_store="")
