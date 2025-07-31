import random

from loguru import logger

from ..feature import Feature, FeatureType
from ..pr_analysis import FileChange, PRInfo, get_move_related_prs
from .common import COMMON_PROMPT, common_invoke_llm


def _extract_from_pr_description(pr: PRInfo) -> list[Feature]:
    logger.info(f"Extracting features from PR description: {pr.number}")

    prompt = f"""The following is the description for a PR for Move compiler or runtime:
{pr.description}

{COMMON_PROMPT}
"""
    response = common_invoke_llm(
        name=f"PR-{pr.number}",
        prompt=prompt,
        estimated_cost_limit=0.01,
    )

    if response is None:
        logger.warning(f"No response from LLM for PR {pr.number}. Skipping feature extraction.")
        return []

    feats = []
    for desc in response.descriptions:
        feature = Feature.new_feature(
            description=desc,
            content=f"just description for: {pr.url}",
            type=FeatureType.PR,
        )
        feats.append(feature)
    return feats


def _extract_from_code_diff(pr: PRInfo, file_change: FileChange) -> list[Feature]:
    logger.info(f"Extracting features from code changes in PR: {pr.number} -- {file_change.filename}")
    prompt = f"""The following are some code changes in a PR for Move compiler or runtime:

The PR description is:
{pr.description}

The code change is:
{file_change.render_patch()}

Note that if the code change is only internal to the compiler or runtime, and not easily understandable by Move users, you should not generate a description.

{COMMON_PROMPT}
"""
    response = common_invoke_llm(
        name=f"PR-{pr.number}-{file_change.filename}",
        prompt=prompt,
        estimated_cost_limit=0.01,
    )

    if response is None:
        logger.warning(f"No response from LLM for PR {pr.number}. Skipping feature extraction.")
        return []

    feats = []
    for desc in response.descriptions:
        feature = Feature.new_feature(
            description=desc,
            content=f"title+diffs for: {pr.url} -- {file_change.filename}",
            type=FeatureType.PR,
        )
        feats.append(feature)
    return feats


def get_move_pr_data() -> list[PRInfo]:
    return get_move_related_prs(False)


def extract_feature_from_pr(pr: PRInfo) -> list[Feature]:
    output = []
    output = _extract_from_pr_description(pr)
    if len(pr.files_changed) > 3:
        logger.warning(f"PR {pr.number} has {len(pr.files_changed)} files changed, sampling 3 for feature extraction.")
        files = random.sample(pr.files_changed, 3)
    else:
        files = pr.files_changed
    for file_change in files:
        code_diff_features = _extract_from_code_diff(pr, file_change)
        output.extend(code_diff_features)
    return output
