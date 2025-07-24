import json
import subprocess
from pathlib import Path
from typing import Optional

from loguru import logger
from pydantic import BaseModel

from .config import APTOS_CORE_DIR, DATA_DIR, cfg
from .feature import Feature, FeatureType
from .feature_store import FeatureStore
from .llm import LLMManager, run_in_parallel

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
    llm_mgr = LLMManager.new(cfg.logs_dir)
    model = llm_mgr.get_model_by_name(cfg.models.extract.name, cfg.models.extract.temperature)
    msg = f"""
    Below is a Rust function in the Aptos Move compiler implementation.

    ```
    {content}
    ```

    Please summarize the Move feature(s) implemented by this function.

    Summarize each feature in a single imperative sentence as if you are telling a Move developer to use this feature.
    For example, if the function checks for whether an inline function has a lambda argument, the feature should be "Create inline functions with lambda arguments".

    Normally a function implements many subtle sub-features of a larger feature, so please pay attention to the details in the code.

    If part of the functino is interacting with the compiler infrastructure, please ignore it.
    Only focus on the features that Move developers can use in their code.
    """

    (_response, summaries) = model.invoke_strucutred(msg, response_format=FeatureSummaries)
    if not summaries.features:
        logger.warning(f"No features summarized for {doc_item['name']}")
        return None
    features = []
    for summary in summaries.features:
        features.append(Feature.new_feature(description=summary, content=content, type=FeatureType.SOURCE_CODE))
    logger.trace(f"Extracted {len(features)} features from {doc_item['name']}")
    return features


def extract_features_from_rust(regenerate: bool) -> FeatureStore:
    if FEATURE_RUST_FILE.exists() and not regenerate:
        logger.info(f"Loading features from {FEATURE_RUST_FILE}")
        feature_store = FeatureStore()
        feature_store.load_features_from_file(FEATURE_TRANSACTIONAL_FILE)
        num_features = feature_store.num_features()

        logger.info(f"Loaded {num_features} features from {FEATURE_RUST_FILE}")
        return feature_store

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

    feature_store = FeatureStore()
    for features in features_list:
        if features:
            for feature in features:
                feature_store.add_feature(feature)
    feature_store.save_local(FEATURE_RUST_FILE, overwrite=True)
    logger.info(f"Saved {feature_store.num_features()} features to {FEATURE_RUST_FILE}")
    return feature_store
