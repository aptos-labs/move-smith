from __future__ import annotations

import json
import pickle
import shutil
import subprocess
import time
from datetime import datetime, timezone
from pathlib import Path
from typing import Any, Type, TypeVar

import redis
from loguru import logger
from pydantic import BaseModel

from .config import ROOT, cfg
from .coverage import AggregatedCoverage
from .feature import Feature

T = TypeVar("T")

DOCKER_DIR = (ROOT / "docker").as_posix()
COMPOSE_FILE = "docker-compose.yml"
COMPOSE_OVERRIDE_FILE = "docker-compose.override.yml"


def docker_up(name: str) -> None:
    logger.info(f"Starting service: {name}")
    subprocess.run(
        ["docker-compose", "-f", COMPOSE_FILE, "up", "-d", name],
        check=True,
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        cwd=DOCKER_DIR,
    )


def docker_down(name: str) -> None:
    logger.info(f"Stopping and removing service: {name}")
    subprocess.run(
        ["docker-compose", "-f", COMPOSE_FILE, "stop", name],
        check=True,
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        cwd=DOCKER_DIR,
    )
    subprocess.run(
        ["docker-compose", "-f", COMPOSE_FILE, "rm", "-f", name],
        check=True,
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        cwd=DOCKER_DIR,
    )


def redis_up_with_override(dump_rdb_path: Path) -> None:
    if not dump_rdb_path.exists():
        logger.error(f"Dump file {dump_rdb_path} does not exist. Cannot start Redis with override.")
        exit(1)

    logger.info(f"Starting Redis with {dump_rdb_path}")

    dump_copy = dump_rdb_path.with_suffix(".copy.rdb")
    shutil.copy(dump_rdb_path, dump_copy)

    subprocess.run(
        [
            "docker-compose",
            "-f",
            COMPOSE_FILE,
            "-f",
            COMPOSE_OVERRIDE_FILE,
            "up",
            "-d",
            "redis",
        ],
        check=True,
        env={"DUMP_PATH": dump_copy.absolute().as_posix()},
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        cwd=DOCKER_DIR,
    )
    logger.info("Docker container started with override.")


class LLMUsageStreamEntry(BaseModel):
    model: str
    prompt_tokens: int
    completion_tokens: int
    reasoning_tokens: int
    total_tokens: int
    cost_usd: float
    record_path: str
    timestamp: str


class CoverageStreamEntry(BaseModel):
    function: float
    line: float
    branch: float
    timestamp: str


class RedisStore:
    def __init__(self) -> None:
        self.host = "localhost"
        self.port = 6379
        self.db = 0

        self.client = redis.Redis(host=self.host, port=self.port, db=self.db)
        logger.trace(f"Connecting to Redis server at {self.host}:{self.port}")
        self.wait_for_redis()
        logger.trace(f"Connected to Redis server at {self.host}:{self.port}")

    def wait_for_redis(self) -> None:
        while not self.is_redis_running():
            logger.trace("Waiting for Redis to start...")
            time.sleep(1)

    def is_redis_running(self) -> bool:
        try:
            self.client.ping()
            return True
        except redis.ConnectionError:
            return False

    def has_key(self, key: str) -> bool:
        return self.client.exists(key) > 0

    def set(self, key: str, value: Any) -> None:
        self.client.set(key, value)

    def set_pickle(self, key: str, value: Any) -> None:
        serialized_value = pickle.dumps(value)
        self.client.set(key, serialized_value)

    def mset(self, mapping: dict[str, Any]) -> None:
        self.client.mset(mapping)

    def get(self, key, expected_type: Type[T]) -> T:
        val = self.client.get(key)
        if expected_type in (str, int, float, bool):
            str_val = val.decode()
            return expected_type(str_val)
        else:
            obj = pickle.loads(val)
            if not isinstance(obj, expected_type):
                raise TypeError(f"Expected {expected_type}, got {type(obj)}")
            return obj

    def dump_to_local(self, local_dump_path: str | Path) -> None:
        self.client.save()
        local_dump_path = Path(local_dump_path)
        subprocess.run(["docker", "cp", "redis:/data/dump.rdb", local_dump_path.as_posix()], check=True)
        if local_dump_path.exists():
            logger.info(f"Dumped Redis data to {local_dump_path.as_posix()}")
        else:
            logger.error(f"Failed to dump Redis data to {local_dump_path.as_posix()}")


class Monitor:
    LLM_USAGE_STREAM_KEY = "llm_usage_stream"
    UNIQ_COVERAGE_STREAM_KEY = "unique_coverage_stream"
    ALL_COVERAGE_STREAM_KEY = "all_coverage_stream"
    TOTAL_COST_KEY = "total_cost_usd"
    COST_LIMIT_KEY = "cost_usd_limit"

    def __init__(self) -> None:
        self.store = RedisStore()

    def record_llm(self, llm_record) -> None:
        file_created_time = llm_record.local_path.stat().st_ctime
        timestamp = datetime.fromtimestamp(file_created_time, timezone.utc).isoformat()

        entry = LLMUsageStreamEntry(
            model=llm_record.model,
            prompt_tokens=llm_record.prompt_tokens,
            completion_tokens=llm_record.completion_tokens,
            reasoning_tokens=llm_record.reasoning_tokens,
            total_tokens=llm_record.total_tokens,
            cost_usd=llm_record.total_cost_usd(),
            record_path=llm_record.local_path.as_posix(),
            timestamp=timestamp,
        )
        self.store.client.xadd(self.LLM_USAGE_STREAM_KEY, entry.model_dump())
        self.store.client.incrbyfloat(self.TOTAL_COST_KEY, entry.cost_usd)

    def __record_coverage_stream(self, key: str, coverage: AggregatedCoverage) -> None:
        entry = CoverageStreamEntry(
            function=coverage.functions.percent,
            line=coverage.lines.percent,
            branch=coverage.branches.percent,
            timestamp=datetime.now(timezone.utc).isoformat(),
        )
        self.store.client.xadd(key, entry.model_dump())

    def record_coverage(self, coverage: AggregatedCoverage) -> None:
        self.__record_coverage_stream(self.ALL_COVERAGE_STREAM_KEY, coverage)

    def record_unique_coverage(self, coverage: AggregatedCoverage) -> None:
        self.__record_coverage_stream(self.UNIQ_COVERAGE_STREAM_KEY, coverage)

    def get_total_cost_usd(self) -> float:
        if not self.store.has_key(self.TOTAL_COST_KEY):
            self.store.set(self.TOTAL_COST_KEY, 0.0)
        return self.store.get(self.TOTAL_COST_KEY, float)

    def reached_total_cost_limit(self) -> bool:
        if self.store.has_key(self.COST_LIMIT_KEY):
            limit = self.store.get(self.COST_LIMIT_KEY, float)
        else:
            limit = cfg.fuzz.cost_usd_limit
            self.store.set(self.COST_LIMIT_KEY, limit)

        total_cost = self.get_total_cost_usd()
        if total_cost >= limit:
            logger.warning(f"Total cost has reached the limit: ${total_cost:.6f} >= ${limit:.6f}")
            return True
        return False

    def incr_counter(self, key: str, amount: int = 1) -> None:
        self.store.client.incrby(key, amount)


class FeatureStore:
    FEATURE_STORE_KEY: str = "feature_store"

    def __init__(self) -> None:
        self.store = RedisStore()

    def load_features_from_file(self, path: str | Path) -> None:
        path = Path(path)
        if not path.exists():
            raise FileNotFoundError(f"File not found: {path}")

        data = json.loads(path.read_text(encoding="utf-8"))
        self.store.client.hset(self.FEATURE_STORE_KEY, mapping=data)
        logger.success(f"Loaded {self.num_features()} features from {path}")

    def save_local(self, path: str | Path, overwrite: bool = False) -> None:
        path = Path(path)
        if path.exists() and not overwrite:
            logger.error(f"File already exists: {path}. Use overwrite=True to replace it.")
            return None
        raw_data = self.store.client.hgetall(self.FEATURE_STORE_KEY)
        data = {k.decode(): v.decode() for k, v in raw_data.items()}
        path.write_text(json.dumps(data, indent=2), encoding="utf-8")

        logger.success(f"Saved {len(data)} features to {path}")

    def get_all_keys(self) -> list[str]:
        return [k.decode() for k in self.store.client.hkeys(self.FEATURE_STORE_KEY)]

    def num_features(self) -> int:
        return self.store.client.hlen(self.FEATURE_STORE_KEY)

    def add_feature(self, feature: Feature) -> None:
        logger.trace(f"Adding {feature.type} feature: {feature.description[:20]}...")
        self.store.client.hset(self.FEATURE_STORE_KEY, feature.id, feature.model_dump_json())

    def get_feature(self, feature_id: str) -> Feature:
        feature_data = self.store.client.hget(self.FEATURE_STORE_KEY, feature_id)
        return Feature.model_validate_json(feature_data.decode())

    def remove_feature(self, feature_id: str) -> None:
        if self.store.client.hexists(self.FEATURE_STORE_KEY, feature_id):
            self.store.client.hdel(self.FEATURE_STORE_KEY, feature_id)
            logger.trace(f"Removed feature with ID: {feature_id}")
        else:
            logger.warning(f"Feature with ID {feature_id} does not exist in the store.")

    def load_from_old_json(self, path: str | Path):
        """
        Load the feature store from a local file.
        """
        path = Path(path)
        if not path.exists():
            raise FileNotFoundError(f"File not found: {path}")
        if not path.is_file():
            raise ValueError(f"Path is not a file: {path}")

        feat_dict = json.loads(path.read_text(encoding="utf-8"))["features"]
        for key, value in feat_dict.items():
            feature = Feature(**value)
            self.add_feature(feature)

        logger.success(f"Loaded {len(feat_dict)} features from {path}")
