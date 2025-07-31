from pathlib import Path

from loguru import logger

from ..config import DATA_DIR, cfg
from ..feature_store import FeatureComboStore
from ..helper import run_in_parallel
from .aptos_source import extract_features_from_rust
from .aptos_txnal import extract_features_from_transactional_tests
from .move_book import extract_features_from_markdown_files
from .pr import extract_feature_from_pr, get_move_pr_data

DEFAULT_FEATURE_FILE_PR = DATA_DIR / "feature_pr.json"


def extract_features(name: str, store_file: Path, get_data, extractor) -> FeatureComboStore:
    """
    Expecting:
    data() -> list[Data]
    extractor(data: Data) -> list[Feature]
    """
    logger.info(f"Extracting features for {name}...")
    if store_file.exists():
        logger.info(f"Loading features from {store_file}")
        feature_combo_store = FeatureComboStore(name)
        feature_combo_store.load_combo_store_from_file(store_file)
        num_features = len(feature_combo_store.get_all_keys())
        logger.info(f"Loaded {num_features} features from {store_file}")

    logger.info(f"Generating features for {name}")

    store = FeatureComboStore(name)
    data = get_data()
    if not data:
        logger.error(f"No data found for {name}.")
        return store

    logger.info(f"Found {len(data)} items to process for {name}")
    args = [(item,) for item in data]

    feature_lists = run_in_parallel(cfg.fuzz.jobs, extractor, args)
    new_feature_cnt = 0
    for features in feature_lists:
        for feature in features:
            store.add_individual_feature(feature)
            new_feature_cnt += 1
    store.save_local(store_file, overwrite=True)
    readable_file = store_file.with_suffix(".md")
    store.save_as_human_readable_file(readable_file)
    logger.info(f"Extracted {new_feature_cnt} new features for {name}")
    return store


def register_extraction_args(extract_parser) -> None:
    extract_parser.add_argument("--regenerate", action="store_true", help="Regenerate even if features already exist")
    extract_parser.add_argument(
        "--compiler-code", action="store_true", help="Extract features from compiler source code"
    )
    extract_parser.add_argument(
        "--transactional-test", action="store_true", help="Extract features from transactional tests"
    )
    extract_parser.add_argument("--pr", action="store_true", help="Extract features from Move-related PRs")
    extract_parser.add_argument("--markdown", action="store_true", help="Extract features from markdown documentation")


def handle_extract(args) -> None:
    if args.compiler_code:
        logger.info("Extracting features from compiler source code...")
        extract_features_from_rust(args.regenerate)

    if args.transactional_test:
        logger.info("Extracting features from transactional tests...")
        extract_features_from_transactional_tests(args.regenerate)

    if args.markdown:
        logger.info("Extracting features from markdown documentation...")
        extract_features_from_markdown_files(args.regenerate)

    if args.pr:
        extract_features("FeatureExtract_MovePR", DEFAULT_FEATURE_FILE_PR, get_move_pr_data, extract_feature_from_pr)
