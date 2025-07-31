import json
import subprocess
from pathlib import Path
from typing import Optional

from loguru import logger
from pydantic import BaseModel

from ..config import APTOS_CORE_DIR, DATA_DIR, cfg
from ..feature import Feature, FeatureType
from ..feature_store import FeatureComboStore
from ..helper import run_in_parallel
from .common import COMMON_PROMPT, common_invoke_llm

FEATURE_RUST_FILE = DATA_DIR / "feature_rust.json"
RUST_DOC_DIR = APTOS_CORE_DIR / "target/doc"

PACKAGES = [
    "move_compiler_v2",
    "legacy_move_compiler",
]


def build_rustdoc(package: str) -> Path:
    """
    Build the rustdoc for the given package.
    """
    logger.info(f"Building rustdoc for {package}")
    cmd = [
        "cargo",
        "+nightly",
        "rustdoc",
        "--output-format",
        "json",
        "-Z",
        "unstable-options",
        "-p",
        package.replace("_", "-"),
        "--",
        "--document-private-items",
    ]
    subprocess.run(
        cmd,
        cwd=APTOS_CORE_DIR,
        check=True,
    )

    doc_file = RUST_DOC_DIR / f"{package}.json"
    if not doc_file.exists():
        raise FileNotFoundError(f"Doc file not found after building: {doc_file}")
    return doc_file


def load_rustdoc_json(package: str) -> Optional[dict]:
    """
    Load the rustdoc JSON file from the given path.

    Args:
        path (Path): The path to the rustdoc JSON file.

    Returns:
        dict: The contents of the rustdoc JSON file as a dictionary.
    """
    doc_file = build_rustdoc(package)
    content = doc_file.read_text(encoding="utf-8")

    if not content:
        return None
    parsed = json.loads(content)
    return parsed


def load_span_content(base_dir: Path, span: dict) -> str:
    path = base_dir / span["filename"]
    begin_line = span["begin"][0]
    end_line = span["end"][0]

    with path.open("r", encoding="utf-8") as f:
        lines = f.readlines()
    return "".join(lines[begin_line - 1 : end_line])


class FeatureSummaries(BaseModel):
    features: list[str]


def process_doc_item(base_dir: Path, docs: dict, index: str) -> Optional[list[Feature]]:
    if index not in docs["paths"]:
        return None
    if docs["paths"][index]["kind"] != "function":
        return None

    doc_item = docs["index"][index]
    code = load_span_content(base_dir, doc_item["span"])

    content = ""
    if "docs" in doc_item and doc_item["docs"]:
        content += f"Doc:\n{doc_item['docs']}\n"
    content += f"File: {doc_item['span']['filename']}\n"
    content += f"Code:\n```\n{code}\n```\n"

    logger.info(f"Extracting feature from {doc_item['name']}")
    msg = f"""Below is a Rust function in the Aptos Move compiler/runtime implementation:

```
{content}
```

Note that if the code change is only internal to the compiler or runtime, and not easily understandable by Move users, you should not generate a description.

{COMMON_PROMPT}"""

    response = common_invoke_llm(
        name=doc_item["name"],
        prompt=msg,
        estimated_cost_limit=0.01,
    )

    if response is None:
        logger.warning(f"No features summarized for {doc_item['name']}")
        return None

    features = []
    for desc in response.descriptions:
        features.append(Feature.new_feature(description=desc, content=content, type=FeatureType.SOURCE_CODE))

    logger.trace(f"Extracted {len(features)} features from {doc_item['name']}")
    return features


def extract_features_from_rust(regenerate: bool) -> FeatureComboStore:
    if FEATURE_RUST_FILE.exists() and not regenerate:
        logger.info(f"Loading features from {FEATURE_RUST_FILE}")
        feature_combo_store = FeatureComboStore("rust")
        feature_combo_store.load_individual_features_from_file(FEATURE_RUST_FILE)
        num_features = len(feature_combo_store.get_all_keys())

        logger.info(f"Loaded {num_features} features from {FEATURE_RUST_FILE}")
        return feature_combo_store

    if regenerate:
        logger.info("Regenerating features for Rust code")
    else:
        logger.info("Generating features for Rust code")

    args = []
    for package in PACKAGES:
        docs = load_rustdoc_json(package)
        if docs is None:
            raise ValueError("No documentation found in the provided JSON file.")
        for idx in docs["index"].keys():
            args.append((APTOS_CORE_DIR, docs, idx))
    features_list = run_in_parallel(cfg.fuzz.jobs, process_doc_item, args)

    feature_combo_store = FeatureComboStore("rust")
    for features in features_list:
        if features:
            for feature in features:
                feature_combo_store.add_individual_feature(feature)
    feature_combo_store.save_local(FEATURE_RUST_FILE, overwrite=True)
    logger.info(f"Saved {len(feature_combo_store.get_all_keys())} features to {FEATURE_RUST_FILE}")
    return feature_combo_store
