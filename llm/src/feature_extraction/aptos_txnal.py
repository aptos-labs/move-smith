from loguru import logger

from ..config import APTOS_CORE_DIR, DATA_DIR, cfg
from ..feature import Feature, FeatureType
from ..feature_store import FeatureComboStore
from ..helper import run_in_parallel
from .common import COMMON_PROMPT, common_invoke_llm

FEATURE_TRANSACTIONAL_FILE = DATA_DIR / "feature_transactional.json"
TXNAL_TEST_DIR = APTOS_CORE_DIR / "third_party/move/move-compiler-v2/transactional-tests"


def extract_feature(test_file) -> list[str]:
    """
    Extracts the feature tested by a transactional test.
    """

    logger.info(f"Extracting feature from {test_file}")
    code = test_file.read_text()
    msg = f"""Below is some Move module(s) and script(s).
They are transactional tests that test a specific feature or bug fix for the Aptos Move language.

```
{code}
```

{COMMON_PROMPT}
    """

    response = common_invoke_llm("transactional", msg, 0.01)
    if response is None:
        logger.error(f"Failed to extract feature from {test_file}")
        return []

    return response.descriptions


def extract_features_from_transactional_tests(regenerate: bool) -> FeatureComboStore:
    """
    Extract features from transactional tests.
    """

    all_transactional_tests = list(TXNAL_TEST_DIR.rglob("*.move"))

    if FEATURE_TRANSACTIONAL_FILE.exists() and not regenerate:
        logger.info(f"Loading features from {FEATURE_TRANSACTIONAL_FILE}")
        feature_combo_store = FeatureComboStore("transactional")
        feature_combo_store.load_individual_features_from_file(FEATURE_TRANSACTIONAL_FILE)
        num_features = len(feature_combo_store.get_all_keys())

        logger.info(f"Loaded {num_features} features from {FEATURE_TRANSACTIONAL_FILE}")
        if num_features != len(all_transactional_tests):
            logger.warning(
                f"Number of features ({num_features}) does not match number of tests ({len(all_transactional_tests)})"
            )
        return feature_combo_store

    if regenerate:
        logger.info(f"Regenerating features for {len(all_transactional_tests)} tests")
    else:
        logger.info(f"Generating features for {len(all_transactional_tests)} tests")

    args = [(test_file,) for test_file in all_transactional_tests]
    description_lists = run_in_parallel(cfg.fuzz.jobs, extract_feature, args)
    descriptions = [desc for sublist in description_lists for desc in sublist if desc]
    logger.info(f"Extracted {len(descriptions)} features from the tests")

    feature_combo_store = FeatureComboStore("transactional")
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
        feature_combo_store.add_individual_feature(feature)
    feature_combo_store.save_local(FEATURE_TRANSACTIONAL_FILE, overwrite=True)
    logger.success(f"Saved {len(feature_combo_store.get_all_keys())} features to {FEATURE_TRANSACTIONAL_FILE}")
    return feature_combo_store
