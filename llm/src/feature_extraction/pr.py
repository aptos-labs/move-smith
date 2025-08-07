import random
import re
from typing import Optional

from loguru import logger

from ..feature import Feature, FeatureType
from ..pr_analysis import FileChange, PRInfo, get_move_related_prs
from .common import COMMON_PROMPT, common_invoke_llm


def _extract_from_pr_description(pr: PRInfo) -> list[Feature]:
    logger.info(f"Extracting enhanced features from PR description: {pr.number}")

    prompt = f"""The following is the description for a PR for Move compiler or runtime:

PR Title: {pr.title}
PR Description: {pr.description}

Analyze this PR description and identify specific Move language features, patterns, and behaviors that should be tested based on the changes described. Focus on:
1. New language features or syntax changes
2. Modified compiler or VM behaviors
3. Integration patterns that need testing
4. Edge cases or error conditions introduced
5. Performance or safety implications

{COMMON_PROMPT}
"""
    response = common_invoke_llm(
        name=f"PR-{pr.number}-description",
        prompt=prompt,
        estimated_cost_limit=0.02,
    )

    if response is None:
        logger.warning(f"No response from LLM for PR {pr.number}. Skipping feature extraction.")
        return []

    feats = []
    for desc in response.descriptions:
        feature = Feature.new_feature(
            description=desc,
            content=f"PR #{pr.number} description analysis: {pr.title}\n{pr.description}\nURL: {pr.url}",
            type=FeatureType.PR,
        )
        feats.append(feature)
    return feats


def _extract_from_code_diff(pr: PRInfo, file_change: FileChange) -> list[Feature]:
    logger.info(f"Extracting features from code changes in PR: {pr.number} -- {file_change.filename}")
    prompt = f"""The following are code changes in a PR for Move compiler or runtime:

PR Context:
Title: {pr.title}
Description: {pr.description}

File: {file_change.filename}
Status: {file_change.status}
Changes: +{file_change.additions} -{file_change.deletions}

Code Changes:
{file_change.render_patch()}

Analyze these specific code changes and identify Move language features, patterns, and behaviors that should be tested. Focus on:
1. New or modified Move language constructs
2. Changes in compiler behavior or error handling
3. Runtime or VM behavior modifications
4. Integration with existing Move features
5. Potential edge cases or error conditions

Note: If the changes are purely internal compiler implementation details not visible to Move developers, return an empty list.

{COMMON_PROMPT}
"""
    response = common_invoke_llm(
        name=f"PR-{pr.number}-{file_change.filename}",
        prompt=prompt,
        estimated_cost_limit=0.015,
    )

    if response is None:
        logger.warning(f"No response from LLM for PR {pr.number}. Skipping feature extraction.")
        return []

    feats = []
    for desc in response.descriptions:
        feature = Feature.new_feature(
            description=desc,
            content=f"PR #{pr.number} code changes in {file_change.filename}\n{file_change.render_patch()}\nURL: {pr.url}",
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


def extract_feature_from_diff_block(pr: PRInfo, file_change: FileChange) -> Optional[Feature]:
    """Extract one feature from a file's diff changes."""
    logger.info(f"Extracting feature from diff in {file_change.filename}")

    if not file_change.patch or len(file_change.patch.strip()) < 20:
        return None

    prompt = f"""Analyze this file's changes in a Move compiler/runtime PR:

PR Context:
Title: {pr.title}
File: {file_change.filename}
Status: {file_change.status}
Changes: +{file_change.additions} -{file_change.deletions}

Code Changes:
{file_change.render_patch()}

Create ONE feature that captures the most important Move language behavior or pattern that should be tested based on these changes.

{COMMON_PROMPT}
"""

    response = common_invoke_llm(
        name=f"PR-{pr.number}-{file_change.filename}",
        prompt=prompt,
        estimated_cost_limit=0.01,
    )

    if response is None or not response.descriptions:
        return None

    # Take the first (most important) description
    desc = response.descriptions[0]
    return Feature.new_feature(
        description=desc,
        content=f"PR #{pr.number} changes in {file_change.filename}\n{file_change.render_patch()}\nURL: {pr.url}",
        type=FeatureType.PR,
    )
