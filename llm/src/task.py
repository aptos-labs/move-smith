from __future__ import annotations

from pathlib import Path

from pydantic import BaseModel


class Task(BaseModel):
    """
    Represents a task with a name, description, and an optional list of features.
    """

    descriptions: list[str]
    code: list[Path]

    @classmethod
    def empty(cls) -> Task:
        return cls(descriptions=[], code=[])
