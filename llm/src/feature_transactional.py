from loguru import logger

from .config import APTOS_CORE_DIR, DATA_DIR, cfg
from .feature import Feature, FeatureType
from .feature_store import FeatureStore
from .llm import LLMManager, run_in_parallel

FEATURE_TRANSACTIONAL_FILE = DATA_DIR / "feature_transactional.json"
TXNAL_TEST_DIR = APTOS_CORE_DIR / "third_party/move/move-compiler-v2/transactional-tests"


def extract_feature(test_file) -> str:
    """
    Extracts the feature tested by a transactional test.
    """
    llm_mgr = LLMManager.new(cfg.logs_dir)
    logger.info(f"Extracting feature from {test_file}")
    code = test_file.read_text()
    model = llm_mgr.get_model_by_name(cfg.models.extract.name, cfg.models.extract.temperature)
    msg = f"""
    Below is some Move module(s) and script(s).
    They are transactional tests that test a specific feature or bug fix for the Aptos Move language.

    ```
    {code}
    ```

    Please summarize the feature tested by this code with a single imperative sentence as if you are telling a developer what to test.
    """

    (_response, feature) = model.invoke(msg)
    return feature.strip()


def extract_features_from_transactional_tests(regenerate: bool) -> FeatureStore:
    """
    Extract features from transactional tests.
    """

    all_transactional_tests = list(TXNAL_TEST_DIR.rglob("*.move"))

    if FEATURE_TRANSACTIONAL_FILE.exists() and not regenerate:
        logger.info(f"Loading features from {FEATURE_TRANSACTIONAL_FILE}")
        feature_store = FeatureStore()
        feature_store.load_features_from_file(FEATURE_TRANSACTIONAL_FILE)
        num_features = feature_store.num_features()

        logger.info(f"Loaded {num_features} features from {FEATURE_TRANSACTIONAL_FILE}")
        if num_features != len(all_transactional_tests):
            logger.warning(
                f"Number of features ({num_features}) does not match number of tests ({len(all_transactional_tests)})"
            )
        return feature_store

    if regenerate:
        logger.info(f"Regenerating features for {len(all_transactional_tests)} tests")
    else:
        logger.info(f"Generating features for {len(all_transactional_tests)} tests")

    args = [(test_file,) for test_file in all_transactional_tests]
    descriptions = run_in_parallel(cfg.fuzz.jobs, extract_feature, args)
    logger.info(f"Extracted {len(descriptions)} features from the tests")

    feature_store = FeatureStore()
    for desc, test_file in zip(descriptions, all_transactional_tests):
        if not desc:
            logger.warning(f"Failed to extract feature from {test_file}")
            continue
        code = test_file.read_text(encoding="utf-8")
        content = f"File: {test_file.relative_to(APTOS_CORE_DIR)}\nCode:\n```\n{code}\n```\n"

        feature = Feature.new_feature(
            description=desc,
            content=content,
            type=FeatureType.TRANSACTIONAL_TEST,
        )
        feature_store.add_feature(feature)
    feature_store.save_local(FEATURE_TRANSACTIONAL_FILE, overwrite=True)
    logger.success(f"Saved {feature_store.num_features()} features to {FEATURE_TRANSACTIONAL_FILE}")
    return feature_store
