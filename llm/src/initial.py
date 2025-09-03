import json
import random
import re
from dataclasses import dataclass
from pathlib import Path

from loguru import logger
from pydantic import BaseModel

from .config import cfg
from .feature import Feature, FeatureCombination, FeatureType
from .feature_extraction.pr import extract_feature_from_diff_block
from .feature_store import FeatureComboStore
from .fixer import fix_test_with_error_message, static_fix_syntax, static_fix_syntax_llm
from .generate_test import generate_new_tests
from .helper import get_content_hash, run_in_parallel
from .llm import LLMWrapper, Message
from .pr_analysis import PRInfo
from .runner import run_one_test
from .store import Monitor
from .task import Task
from .test_enhancer import enhance_existing_move_files

SAVED_PR_TESTS_DIR = "pr_generated_tests"
SAVED_PR_TASK_FILE = "pr_task.json"
SAVED_PR_SEED_FEATURE_STORE_FILE = "pr_initial_store.json"

SAVED_CONCEPTS_FILE = "pr_concepts.txt"
SAVED_SELECTED_FEATURES_FILE = "pr_selected_features.txt"

NEW_COMBO_STORE_NAME = "pr_initial_store"

SAVED_PR_FEATURES_FILE = "pr_generated_features.json"
SAVED_NEGATIVE_TEST_INFO_FILE = "pr_negative_test_info.json"


class NegativeTestInfo(BaseModel):
    needs_negative_tests: bool
    expected_behaviors: list[str]
    error_patterns: list[str]

    def save_to_file(self, file_path: Path) -> None:
        """Save negative test info to JSON file."""
        file_path.write_text(self.model_dump_json(indent=2))


def extract_move_files_from_pr(pr_info: PRInfo) -> list[str]:
    """Extract list of .move files changed in the PR."""
    move_files = []
    for file_change in pr_info.files_changed:
        if file_change.filename.endswith(".move"):
            move_files.append(file_change.filename)
    return move_files


def generate_pr_features(pr_info: PRInfo) -> tuple[list[Feature], list[Feature]]:
    """Generate features from PR concepts and diff blocks."""
    logger.info(f"Generating features from PR #{pr_info.number}")

    # 1. Convert concepts from PR analysis to Features
    concepts = analyze_pr_for_concepts(pr_info)
    concept_features = []
    for concept in concepts:
        feature = Feature.new_feature(
            description=concept,
            content=f"PR #{pr_info.number} concept: {pr_info.title}\nDescription: {pr_info.description}\nURL: {pr_info.url}",
            type=FeatureType.PR,
        )
        concept_features.append(feature)
    logger.info(f"Created {len(concept_features)} features from PR concepts")

    # 2. Generate 1 feature per diff block
    diff_features = []
    for file_change in pr_info.files_changed:
        feature = extract_feature_from_diff_block(pr_info, file_change)
        if feature:
            diff_features.append(feature)
    logger.info(f"Created {len(diff_features)} features from diff blocks")

    return concept_features, diff_features


def save_pr_features(features: list[Feature]) -> FeatureComboStore:
    """Save PR-generated features to a FeatureComboStore."""
    logger.info(f"Saving {len(features)} PR-generated features")

    store = FeatureComboStore("pr_generated_features")
    for feature in features:
        store.add_individual_feature(feature)

    # Save to files
    features_file = cfg.work_dir / SAVED_PR_FEATURES_FILE
    store.save_local(features_file, overwrite=True)
    readable_file = features_file.with_suffix(".md")
    store.save_as_human_readable_file(readable_file)

    logger.success(f"Saved PR features to {features_file} and {readable_file}")
    return store


def analyze_pr_for_negative_tests(pr_info: PRInfo) -> NegativeTestInfo:
    """Analyze PR to determine if negative tests are needed."""
    logger.info(f"Analyzing PR #{pr_info.number} for negative test requirements")

    # Conservative approach: only consider negative tests if PR has .exp files
    if not pr_info.exp_files_content:
        logger.info("No .exp files found, no negative tests needed")
        return NegativeTestInfo(needs_negative_tests=False, expected_behaviors=[], error_patterns=[])

    # Prepare content for analysis
    pr_summary = f"Title: {pr_info.title}\n\nDescription: {pr_info.description}\n"

    exp_content = "\n\n".join([f"File: {filename}\n{content}" for filename, content in pr_info.exp_files_content])
    move_content = "\n\n".join([f"File: {filename}\n{content}" for filename, content in pr_info.move_files_content])

    system_msg = """You are an expert at analyzing Move compiler changes and test expectations.
Given a Pull Request with .exp files that show expected errors, determine if this PR requires negative tests
that are EXPECTED to fail with specific error patterns.

Analyze the .exp files to determine:
1. needs_negative_tests: true if the .exp files clearly show error patterns that indicate this PR is testing error conditions, false otherwise
2. expected_behaviors: list of descriptions of behaviors that should be wrong (causing compilation or runtime errors) 
3. error_patterns: list of specific error patterns from the .exp files (mention patterns of the error message or error code)

Be CONSERVATIVE - only set needs_negative_tests to true if the .exp files contain errors."""

    user_msg = f"""Analyze this Pull Request and determine if negative tests are needed:

PR Summary:
{pr_summary}

Move Files Content:
{move_content}

Expected Output Files (.exp):
{exp_content}

Please analyze and provide the structured response."""

    llm = LLMWrapper.new(cfg.logs_dir / "negative_test_analysis")
    msgs = Message.new_sys_and_user(system_msg, user_msg)

    negative_test_info = llm.invoke_structured(
        cfg.models.init.name, cfg.models.init.temperature, msgs, NegativeTestInfo
    )

    if negative_test_info is None:
        logger.warning("Failed to get structured response, falling back to no negative tests")
        negative_test_info = NegativeTestInfo(needs_negative_tests=False, expected_behaviors=[], error_patterns=[])

    logger.info(
        f"Negative test analysis: needs={negative_test_info.needs_negative_tests}, behaviors={len(negative_test_info.expected_behaviors)}, patterns={len(negative_test_info.error_patterns)}"
    )
    return negative_test_info


def analyze_pr_for_concepts(pr_info: PRInfo) -> list[str]:
    """Analyze PR content and summarize the related concepts."""
    logger.info(f"Analyzing PR #{pr_info.number} for relevant features")

    pr_summary = f"Title: {pr_info.title}\n\nDescription: {pr_info.description}\n\nChanges:\n{pr_info.get_all_diffs()}"

    system_msg = """You are an expert at analyzing Move compiler & runtime code changes.
Given a Pull Request, identify the Move language concepts affected by this PR, specific Move program patterns that
would be most relevant for generating comprehensive tests.
Focus on Move language features and patterns that trigger different compiler behaviors and virtual machine executions.

Respond with a concise list of key concepts and features, one per line."""

    user_msg = f"""Analyze this Pull Request and identify the Move language concepts, features,
and patterns that should be tested:

{pr_summary}

Please list at least {cfg.initial.soft_number_of_concepts_per_pr} main concepts, features, and patterns
that comprehensive tests should cover."""

    llm = LLMWrapper.new(cfg.logs_dir / "pr_analysis")
    msgs = Message.new_sys_and_user(system_msg, user_msg)
    response = llm.invoke(cfg.models.init.name, cfg.models.init.temperature, msgs)

    concepts = [
        line.strip() for line in response.content.split("\n") if line.strip() and not line.strip().startswith("#")
    ]
    logger.info(f"Identified {len(concepts)} key concepts from PR analysis")
    return concepts


def find_relevant_features_for_diff_features(
    diff_features: list[Feature], combo_store: FeatureComboStore
) -> dict[str, list[FeatureCombination]]:
    """Find relevant features for each diff-extracted feature."""
    logger.info(f"Finding relevant features for {len(diff_features)} diff-extracted features")

    relevant_features_map = {}
    features_per_diff_feature = 5  # Limit per diff feature
    similarity_pool_size = features_per_diff_feature * 10

    for diff_feature in diff_features:
        logger.debug(f"Processing diff feature: {diff_feature.description[:100]}...")

        candidate_features = combo_store.search_with_str(diff_feature.description, top_k=similarity_pool_size)
        logger.debug(f"Found {len(candidate_features)} candidate features for diff feature")

        random.shuffle(candidate_features)

        selected_features = []
        processed_count = 0
        batch_size = 10

        while len(selected_features) < features_per_diff_feature and processed_count < len(candidate_features):
            batch_end = min(processed_count + batch_size, len(candidate_features))
            batch_features = candidate_features[processed_count:batch_end]
            if not batch_features:
                break

            batch_selected = _select_relevant_features_with_llm(diff_feature.description, batch_features)
            selected_features.extend(batch_selected)
            processed_count = batch_end

            if len(selected_features) >= features_per_diff_feature:
                break

        selected_features = selected_features[:features_per_diff_feature]
        relevant_features_map[diff_feature.id] = selected_features
        logger.success(f"Selected {len(selected_features)} relevant features for diff feature")

    return relevant_features_map


def find_relevant_features(concepts: list[str], combo_store: FeatureComboStore) -> list[FeatureCombination]:
    """Find features in the store that match the given concepts."""

    logger.info(f"Finding relevant features for {len(concepts)} concepts")

    relevant_features = []
    features_per_concept = cfg.initial.number_of_features_per_concept
    similarity_pool_size = features_per_concept * 10
    batch_size = 10

    for concept in concepts:
        logger.debug(f"Processing concept: {concept}")

        candidate_features = combo_store.search_with_str(concept, top_k=similarity_pool_size)
        logger.debug(f"Found {len(candidate_features)} candidate features for concept: {concept}")

        random.shuffle(candidate_features)

        selected_features = []
        processed_count = 0
        while len(selected_features) < features_per_concept and processed_count < len(candidate_features):
            batch_end = min(processed_count + batch_size, len(candidate_features))
            batch_features = candidate_features[processed_count:batch_end]
            if not batch_features:
                break

            batch_selected = _select_relevant_features_with_llm(concept, batch_features)
            selected_features.extend(batch_selected)
            processed_count = batch_end

            if len(selected_features) >= features_per_concept:
                break

        selected_features = selected_features[:features_per_concept]
        relevant_features.extend(selected_features)
        logger.success(f"Selected {len(selected_features)} relevant features for concept: {concept}")
    logger.success(f"Found {len(relevant_features)} total relevant features across all concepts")
    return relevant_features


def _select_relevant_features_with_llm(concept: str, combos: list[FeatureCombination]) -> list[FeatureCombination]:
    combo_descriptions = []
    for i, combo in enumerate(combos):
        combo_descriptions.append(f"<combination_{i+1}>\n{combo.dump_for_llm()}\n<>")
    combo_text = "\n".join(combo_descriptions)

    system_msg = """You are an expert at identifying relevant Move language features for testing specific concepts.

Given a concept and a list of Move features, select the features that are most relevant for testing that concept.

Focus on:
- Features that directly relate to the concept
- Features that commonly interact with the concept in real Move code
- Features that might reveal edge cases or bugs when combined with the concept
- Features that test different aspects of the same underlying system

Avoid selecting duplicates or features that are too similar to each other.

Respond with only the numbers of the selected features (e.g., "1, 3, 5"), separated by commas."""

    user_msg = f"""Concept to test: {concept}

Available features:
{combo_text}

Select the most relevant feature numbers:"""

    llm = LLMWrapper.new(cfg.logs_dir / "init_feature_selection")
    msgs = Message.new_sys_and_user(system_msg, user_msg)
    response = llm.invoke(cfg.models.init.name, cfg.models.init.temperature, msgs)

    selected_features = []
    numbers = re.findall(r"\b(\d+)\b", response.content)

    for num_str in numbers:
        try:
            index = int(num_str) - 1
            if 0 <= index < len(combos):
                selected_features.append(combos[index])
        except ValueError:
            logger.warning(f"Failed to parse feature number: {num_str}")
            continue

    logger.debug(f"LLM selected {len(selected_features)} features for concept '{concept}' from batch of {len(combos)}")
    return selected_features


def generate_combinations_with_base_features(
    pr_features: list[Feature], existing_features: list[FeatureCombination], new_combo_store: FeatureComboStore
):
    """Generate feature combinations with each PR feature as a base."""
    logger.info(
        f"Generating combinations with {len(pr_features)} PR base features and {len(existing_features)} existing features"
    )

    for pr_feature in pr_features:
        logger.debug(f"Generating combinations for base PR feature: {pr_feature.description[:100]}...")

        # Create descriptions for existing features
        combo_descriptions = []
        for i, combo in enumerate(existing_features):
            combo_descriptions.append(f"<feature_{i+1}>\n{combo.dump_for_llm()}\n</>")
        combo_text = "\n".join(combo_descriptions)

        system_msg = """You are an expert at creating Move test combinations.

You will receive:
1. A BASE FEATURE (from the current PR) that will be included in every combination
2. Available existing features to combine with

Generate combinations that test the base feature with complementary existing features.

Respond with feature numbers to combine with the base feature (e.g., "1, 3" or "2, 5, 7").
Each line should be one combination."""

        user_msg = f"""BASE FEATURE (included automatically):
{pr_feature.description}

Available features to combine with:
{combo_text}

Generate {cfg.initial.combinations_per_pr_feature} different combinations. Each line should contain feature numbers to add to the base feature."""

        llm = LLMWrapper.new(cfg.logs_dir / "init_combo_base_selection")
        msgs = Message.new_sys_and_user(system_msg, user_msg)
        response = llm.invoke(cfg.models.init.name, cfg.models.init.temperature, msgs)

        # Parse response and create combinations
        combinations_created = 0
        for line in response.content.split("\n"):
            line = line.strip()
            if not line or line.startswith("#"):
                continue

            numbers = re.findall(r"\b(\d+)\b", line)
            try:
                indices = [int(num) - 1 for num in numbers if 1 <= int(num) <= len(existing_features)]

                # Create combination with PR feature as base
                features_to_combine = [pr_feature]  # Start with PR feature
                for idx in indices:
                    features_to_combine.extend(existing_features[idx].features)

                if len(features_to_combine) > 0:
                    combo = FeatureCombination.new_combination(features_to_combine)
                    new_combo_store.add_combo(combo)
                    combinations_created += 1
                    logger.debug(f"Created combination with PR base + {len(indices)} existing features: {combo.id}")

                    if combinations_created >= cfg.initial.combinations_per_pr_feature:
                        break
            except (ValueError, IndexError) as e:
                logger.warning(f"Failed to parse combination from line: {line} - {e}")
                continue

        # Ensure at least one combination per PR feature (just the PR feature alone)
        if combinations_created == 0:
            combo = FeatureCombination.new_combination([pr_feature])
            new_combo_store.add_combo(combo)
            logger.debug(f"Created single PR feature combination: {combo.id}")

    total_combos = new_combo_store.vstore.num_items()
    logger.success(f"Generated {total_combos} feature combinations with PR base features")


def generate_feature_combinations(combos: list[FeatureCombination], new_combo_store: FeatureComboStore):
    """Generate interesting feature combinations using LLM guidance."""
    logger.info(f"Generating feature combinations from {len(combos)} features")

    combo_descriptions = []
    for i, combo in enumerate(combos):
        combo_descriptions.append(f"<combination_{i+1}>\n{combo.dump_for_llm()}\n<>")
    combo_text = "\n".join(combo_descriptions)

    system_msg = f"""You are an expert at creating comprehensive Move test strategies. Given a list of Move features or
patterns combinations, identify the most interesting and valuable combinations of features to test together.

Focus on:
- Features that commonly interact in real code
- Edge cases that arise when features are combined
- Complex scenarios that might reveal bugs
- Features that test different aspects of the same underlying system

Respond with new combinations as numbered lists of existing combination indices (e.g., "1, 3, 5" for <combination_1>,
<combination_3>, and <combination_5>).

Generate about {cfg.initial.soft_final_number_of_combos} different combinations, varying in size from 2-4 each."""

    user_msg = f"""Given these Move language features or patterns, suggest the most interesting and valuable
combinations to test together:

{combo_text}

Please provide combinations as lists of feature numbers (e.g., "1, 3, 5"), each combination on a new line."""

    llm = LLMWrapper.new(cfg.logs_dir / "init_combo_generation")
    msgs = Message.new_sys_and_user(system_msg, user_msg)
    response = llm.invoke(cfg.models.init.name, cfg.models.init.temperature, msgs)

    num_new_combos = 0
    for line in response.content.split("\n"):
        line = line.strip()
        if not line or line.startswith("#"):
            continue

        numbers = re.findall(r"\b(\d+)\b", line)
        if len(numbers) >= 2:
            try:
                indices = [int(num) - 1 for num in numbers if 1 <= int(num) <= len(combos)]
                if len(indices) >= 2:
                    selected_combos = [combos[i] for i in indices]
                    combo = FeatureCombination.merge_combinations(selected_combos)
                    new_combo_store.add_combo(combo)
                    logger.debug(f"Created combination with {len(combo.features)} features: {combo.id}")
                    num_new_combos += 1
            except (ValueError, IndexError) as e:
                logger.warning(f"Failed to parse combination from line: {line} - {e}")
                continue

    logger.success(f"Generated {num_new_combos} feature combinations")


def generate_and_fix_tests(combo_store: FeatureComboStore, negative_test_info: NegativeTestInfo = None) -> int:
    combination_keys = combo_store.get_all_keys()

    """Generate tests for combinations and attempt to fix compilation errors."""
    logger.info(f"Generating tests for {len(combination_keys)} feature combinations")

    tests_dir = cfg.work_dir / SAVED_PR_TESTS_DIR
    tests_dir.mkdir(parents=True, exist_ok=True)

    args = [(key, negative_test_info) for key in combination_keys]
    results = run_in_parallel(cfg.fuzz.jobs, _generate_and_fix_one_test, args)
    successful_tests = [res for res in results if res]

    logger.success(f"Successfully generated {len(successful_tests)} compilable tests")
    return len(successful_tests)


def _generate_and_fix_one_test(combo_key: str, negative_test_info: NegativeTestInfo = None) -> bool:
    combo_store = FeatureComboStore(NEW_COMBO_STORE_NAME)
    combo = combo_store.get_item(combo_key)

    logger.info(f"Processing combination: {combo.id}")

    tests_dir = cfg.work_dir / SAVED_PR_TESTS_DIR
    combo_success = False

    for gen_attempt in range(cfg.initial.generation_attempt_limit):
        if combo_success:
            break

        logger.debug(
            f"Generation attempt {gen_attempt + 1}/{cfg.initial.generation_attempt_limit}"
            f" for combination {combo.id}"
        )

        try:
            test_codes = generate_new_tests(combo, num_tests=1)
            if not test_codes:
                logger.warning(f"No test code generated for combination {combo.id} on attempt {gen_attempt + 1}")
                continue

            test_code = test_codes[0]
            current_code = test_code

            for fix_attempt in range(cfg.initial.fix_attempt_limit):
                current_code = static_fix_syntax(current_code)
                current_code = static_fix_syntax_llm(current_code)

                logger.debug(
                    f"Testing compilation for combination {combo.id} (gen {gen_attempt + 1}, fix {fix_attempt + 1})"
                )
                result = run_one_test(current_code)

                if not result.has_error:
                    logger.success(
                        f"Test compiled successfully for combination {combo.id} (gen {gen_attempt + 1},"
                        f" fix {fix_attempt + 1})"
                    )
                    file_hash = get_content_hash(current_code)
                    test_file = tests_dir / f"{file_hash}.move"
                    test_file.write_text(current_code, encoding="utf-8")
                    logger.debug(f"Saved test for combination {combo.id} to {test_file}")

                    combo_success = True
                    break
                else:
                    if fix_attempt < cfg.initial.fix_attempt_limit - 1:
                        logger.debug(
                            f"Attempting to fix compilation errors for combination {combo.id}"
                            f" (attempt {fix_attempt + 1}/{cfg.initial.fix_attempt_limit})"
                        )
                        # Pass negative test info to fixer
                        expected_behaviors = negative_test_info.expected_behaviors if negative_test_info else None
                        error_patterns = negative_test_info.error_patterns if negative_test_info else None
                        fixed_code = fix_test_with_error_message(
                            current_code, result.error_message, expected_behaviors, error_patterns
                        )

                        if fixed_code != current_code:
                            current_code = fixed_code
                            logger.debug(f"Applied fix for combination {combo.id} (attempt {fix_attempt + 1})")
                        else:
                            logger.debug(f"No fix generated for combination {combo.id} (attempt {fix_attempt + 1})")
                    else:
                        # Check if this is an acceptable negative test error on final attempt
                        if (
                            negative_test_info
                            and negative_test_info.needs_negative_tests
                            and negative_test_info.expected_behaviors
                            and negative_test_info.error_patterns
                        ):
                            from .fixer import is_expected_negative_test_error

                            if is_expected_negative_test_error(
                                result.error_message,
                                negative_test_info.expected_behaviors,
                                negative_test_info.error_patterns,
                            ):
                                logger.success(
                                    f"Accepting negative test for combination {combo.id} - expected error pattern matched"
                                )
                                file_hash = get_content_hash(current_code)
                                test_file = tests_dir / f"{file_hash}.move"
                                test_file.write_text(current_code, encoding="utf-8")
                                combo_success = True
                                break

                        logger.warning(
                            f"All fix attempts failed for combination {combo.id} generation {gen_attempt + 1}"
                        )

        except Exception as e:
            logger.error(f"Error processing combination {combo.id} (gen {gen_attempt + 1}): {e}")
            continue

    if not combo_success:
        logger.warning(
            f"Failed to generate compilable test for combination {combo.id} after"
            " 3 generations with 3 fix attempts each"
        )
    return combo_success


def generate_llm_goals(pr_info: PRInfo, new_combo_store: FeatureComboStore) -> list[str]:
    """Generate relevant goals using LLM based on PR and successful test combinations."""
    logger.info("Generating LLM-based goals for fuzzing task")

    features_summary = new_combo_store.dump_combos_for_llm(new_combo_store.get_all_keys())

    pr_summary = f"Title: {pr_info.title}\nDescription: {pr_info.description}"

    system_msg = """You are an expert at defining comprehensive testing goals for Move compiler and runtime fuzzing.

    Given a Pull Request and a list of Move features or patterns that will be tested, generate 3-5 specific, actionable
    goals that would help search for more related features based on semantic similarity.

    Focus on:
    - Specific aspects of the PR that need thorough testing
    - Common patterns and practices in Move code that should be validated
    - Coverage gaps that fuzzing should address
    - Regression testing for the changes made

    Respond with goals as a simple numbered list, one goal per line.
    Each goal should be a simple sentence within 100 words."""

    user_msg = f"""Based on this Pull Request and the features that will be tested, generate specific fuzzing goals:

PR Information:
{pr_summary}

Features that will be tested:
{features_summary}

Please provide at least {cfg.initial.soft_number_of_goals} specific, actionable goals for fuzzing this codebase."""

    llm = LLMWrapper.new(cfg.logs_dir / "goal_generation")
    msgs = Message.new_sys_and_user(system_msg, user_msg)
    response = llm.invoke(cfg.models.init.name, cfg.models.init.temperature, msgs)

    goals = []
    for line in response.content.split("\n"):
        line = line.strip()
        if line and not line.startswith("#"):
            clean_line = re.sub(r"^[\d]+[.)\s]+", "", line)
            clean_line = re.sub(r"^[-*•]\s*", "", clean_line)
            if clean_line:
                goals.append(clean_line)

    if not goals:
        goals = [
            "Improve code coverage through comprehensive feature testing",
            "Discover edge cases and potential bugs in compiler and VM",
        ]

    logger.success(f"Generated {len(goals)} LLM-based goals")
    return goals


def save_store_and_create_task(pr_info: PRInfo, new_combo_store: FeatureComboStore) -> None:
    logger.info(f"Creating fuzzing task for PR #{pr_info.number}")

    interesting_files = [
        "move-compiler-v2/src/bytecode_generator.rs",
        "move-compiler-v2/src/env_pipeline",
        "move-compiler-v2/src/file_format_generator",
        "move-compiler-v2/src/lib.rs",
        "move-compiler-v2/src/pipeline",
    ]

    for file_change in pr_info.files_changed:
        if file_change.filename.endswith(".rs") and file_change.status != "removed":
            filepath = Path(file_change.filename)
            rust_file = f"{filepath.parent.name}/{filepath.name}"

            if rust_file not in interesting_files:
                logger.debug(f"Added PR Rust file to interesting files: {rust_file}")
                interesting_files.append(rust_file)

    goals = generate_llm_goals(pr_info, new_combo_store)

    new_combo_store_file = cfg.work_dir / SAVED_PR_SEED_FEATURE_STORE_FILE
    new_combo_store.save_local_and_readable_file(new_combo_store_file, overwrite=True)
    logger.success(f"Saved {new_combo_store.vstore.num_items()} combinations to {new_combo_store_file}")

    task = Task(
        goals=goals, features=[], interesting_files=interesting_files, seed_store=new_combo_store_file.as_posix()
    )

    task_file = cfg.work_dir / SAVED_PR_TASK_FILE
    task_file.write_text(task.model_dump_json(indent=2), encoding="utf-8")
    logger.success(f"Created fuzzing task with {len(goals)} goals")


def run_from_pr(pr_number: int):
    logger.info("Loading PR information...")
    pr_info = PRInfo.new_aptos(pr_number)
    logger.success(f"Loaded PR #{pr_info.number}: {pr_info.title}")

    # Step 0: Analyze if PR needs negative tests
    negative_test_info = analyze_pr_for_negative_tests(pr_info)
    negative_test_info.save_to_file(cfg.work_dir / SAVED_NEGATIVE_TEST_INFO_FILE)

    # Step 1: Generate features from PR (concepts + diff blocks)
    concept_features, diff_features = generate_pr_features(pr_info)
    all_pr_features = concept_features + diff_features
    save_pr_features(all_pr_features)
    logger.success(
        f"Generated {len(all_pr_features)} features from PR ({len(concept_features)} concepts, {len(diff_features)} diff blocks)"
    )

    # Extract concepts for logging
    concepts = [f.description for f in concept_features]
    (cfg.work_dir / SAVED_CONCEPTS_FILE).write_text("\n".join(concepts), encoding="utf-8")

    # Step 2: Load existing features
    logger.info("Loading existing features...")
    existing_combo_store = FeatureComboStore("pr_analysis_running")
    for feat_file in cfg.initial.features:
        if Path(feat_file).exists():
            existing_combo_store.load_combo_store_from_file(feat_file)
            logger.debug(f"Loaded features from {feat_file}")
    total_existing = existing_combo_store.vstore.num_items()
    logger.success(f"Loaded {total_existing} existing features")

    if total_existing == 0:
        logger.error("No existing features found. Please run feature extraction first.")
        return

    # Step 3: Find relevant existing features based on concepts
    relevant_existing_features_for_concepts = find_relevant_features(concepts, existing_combo_store)
    features_list = [f.dump_for_llm() for f in relevant_existing_features_for_concepts]
    (cfg.work_dir / SAVED_SELECTED_FEATURES_FILE).write_text("\n===========\n".join(features_list), encoding="utf-8")
    logger.success(f"Found {len(relevant_existing_features_for_concepts)} relevant existing features for concepts")

    # Step 4: Find relevant existing features for each diff-extracted feature
    relevant_features_for_diff = find_relevant_features_for_diff_features(diff_features, existing_combo_store)
    logger.success(f"Found relevant features for {len(relevant_features_for_diff)} diff-extracted features")

    # Step 5: Generate combinations with PR features as base
    new_combo_store = FeatureComboStore(NEW_COMBO_STORE_NAME)
    all_relevant_features = relevant_existing_features_for_concepts.copy()
    for diff_relevant in relevant_features_for_diff.values():
        all_relevant_features.extend(diff_relevant)
    generate_combinations_with_base_features(all_pr_features, all_relevant_features, new_combo_store)

    # Step 6: Generate and fix tests from combinations
    num_tests = generate_and_fix_tests(new_combo_store, negative_test_info)

    if num_tests == 0:
        logger.error("No compilable tests were generated. Exiting.")
        return

    # Step 7: Enhance existing .move files with new test cases and apply fixing
    combo_keys = new_combo_store.get_all_keys()
    combo_items = []
    for key in combo_keys:
        combo_items.append(new_combo_store.get_item(key))

    # Pass relevant features for diff-extracted features to the enhancer
    enhanced_count = enhance_existing_move_files(pr_info, combo_items, relevant_features_for_diff)
    logger.success(f"Enhanced and validated {enhanced_count} existing Move files")

    save_store_and_create_task(pr_info, new_combo_store)

    # Report results to user
    print("\n/**************************************************/\n")
    print(f"Successfully processed PR #{pr_number}")
    print(f"Title: {pr_info.title}")
    print(f"URL: {pr_info.url}")
    print(f"Task configuration saved to: {cfg.work_dir / SAVED_PR_TASK_FILE}")
    print(f"Feature combinations saved to: {(cfg.work_dir / SAVED_PR_SEED_FEATURE_STORE_FILE).with_suffix('.md')}")

    print("------")
    print(f"Generated {len(all_pr_features)} PR-specific features")
    print(f"PR features saved to: {(cfg.work_dir / SAVED_PR_FEATURES_FILE).with_suffix('.md')}")
    print(f"Found {len(relevant_existing_features_for_concepts)} relevant existing features")
    if negative_test_info.needs_negative_tests:
        print(
            f"Negative test analysis: {len(negative_test_info.expected_behaviors)} expected behaviors, {len(negative_test_info.error_patterns)} error patterns"
        )
        print(f"Negative test info saved to: {cfg.work_dir / SAVED_NEGATIVE_TEST_INFO_FILE}")

    print("------")
    print(f"Generated {num_tests} compilable tests")
    print(f"Tests saved to: {cfg.work_dir / SAVED_PR_TESTS_DIR}")
    if enhanced_count > 0:
        print(f"Enhanced and validated {enhanced_count} existing Move files")
        print(f"Enhanced files saved to: {cfg.work_dir / 'enhanced_move_files'}")
        print("Enhanced files went through the same fixing process as newly generated tests")

    print("To see coverage results for the generated tests, run:")
    print(
        f"python -m src.main coverage -d {cfg.work_dir / SAVED_PR_TESTS_DIR} -o {cfg.work_dir}/coverage -b data/baseline.lcov"
    )

    print("------")
    print("🚀 Ready to start fuzzing with these combinations as initial population!")
    print(f"Run: python -m src.main fuzz --task {cfg.work_dir / SAVED_PR_TASK_FILE} --work-dir {cfg.work_dir}/fuzz")

    monitor = Monitor()
    print(f"Total cost so far: {monitor.get_total_cost_usd()}")
