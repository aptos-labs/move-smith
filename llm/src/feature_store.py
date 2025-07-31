from __future__ import annotations

import json
from pathlib import Path

from loguru import logger

from .embedding_store import EmbeddingStore
from .feature import Feature, FeatureCombination
from .store import RedisStore


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


class FeatureComboStore:
    def __init__(self, name: str = "default") -> None:
        self.name = name
        store_name = f"feature_combo_{name}"
        self.vstore: EmbeddingStore[FeatureCombination] = EmbeddingStore(store_name, FeatureCombination)

    def load_individual_features_from_file(self, path: str | Path) -> None:
        path = Path(path)
        data = json.loads(path.read_text(encoding="utf-8"))
        for _, value in data.items():
            feature = Feature.from_redis_payload(value)
            self.add_individual_feature(feature)

    def load_combo_store_from_file(self, path: str | Path) -> None:
        path = Path(path)
        if not path.exists():
            raise FileNotFoundError(f"File not found: {path}")

        data = json.loads(path.read_text(encoding="utf-8"))
        count = 0
        for _, combo_data in data.items():
            combo = FeatureCombination.from_redis_payload(combo_data)
            self.vstore.add_item(combo)
            count += 1

        logger.success(f"Loaded {count} feature combinations from {path}")

    def save_local(self, path: str | Path, overwrite: bool = False) -> None:
        path = Path(path)
        if path.exists() and not overwrite:
            logger.error(f"File already exists: {path}. Use overwrite=True to replace it.")
            return

        data = {}
        all_keys = self.vstore.get_all_keys()
        for combo_id in all_keys:
            combo = self.vstore.get_item(combo_id)
            data[combo_id] = combo.to_redis_payload()

        path.write_text(json.dumps(data, indent=2), encoding="utf-8")
        logger.success(f"Saved {len(data)} feature combinations to {path}")

    def add_individual_feature(self, feature: Feature) -> None:
        combo = FeatureCombination.new_combination([feature])
        self.vstore.add_item(combo)

    def add_combo(self, combo: FeatureCombination) -> None:
        self.vstore.add_item(combo)

    def get_item(self, combo_id: str) -> FeatureCombination:
        return self.vstore.get_item(combo_id)

    def get_all_keys(self) -> list[str]:
        return self.vstore.get_all_keys()

    def remove_item(self, combo_id: str) -> None:
        self.vstore.remove_item(combo_id)

    def search_with_combo(self, query_combo: FeatureCombination, top_k: int = 5) -> list[FeatureCombination]:
        query_str = "\n".join([f.description for f in query_combo.features])
        results = self.vstore.search(query_str, top_k)
        return results

    def search_with_str(self, query_str: str, top_k: int = 5) -> list[FeatureCombination]:
        results = self.vstore.search(query_str, top_k)
        return results

    def save_as_human_readable_file(self, path: str | Path) -> None:
        path = Path(path)

        output = []
        all_keys = self.vstore.get_all_keys()
        for combo_id in all_keys:
            combo = self.get_item(combo_id)
            output.append(f"# Combination ID: {combo.id}")
            for feat in combo.features:
                output.append(f"Feature ID: {feat.id}, Description: {feat.description}")
            output.append("\n\n")
        path.write_text("\n".join(output), encoding="utf-8")
