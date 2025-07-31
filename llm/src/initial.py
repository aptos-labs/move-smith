import random
import re
from pathlib import Path

from loguru import logger

from .config import cfg
from .feature import FeatureCombination
from .feature_store import FeatureComboStore
from .fixer import fix_test_with_error_message, static_fix_syntax, static_fix_syntax_llm
from .generate_test import generate_new_tests
from .helper import get_content_hash, run_in_parallel
from .llm import LLMWrapper, Message
from .pr_analysis import PRInfo
from .runner import run_one_test
from .store import Monitor
from .task import Task

SAVED_PR_TESTS_DIR = "pr_generated_tests"
SAVED_PR_TASK_FILE = "pr_task.json"
SAVED_PR_SEED_FEATURE_STORE_FILE = "pr_initial_store.json"

SAVED_CONCEPTS_FILE = "pr_concepts.txt"
SAVED_SELECTED_FEATURES_FILE = "pr_selected_features.txt"

NEW_COMBO_STORE_NAME = "pr_initial_store"


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


def generate_and_fix_tests(combo_store: FeatureComboStore) -> int:
    combination_keys = combo_store.get_all_keys()

    """Generate tests for combinations and attempt to fix compilation errors."""
    logger.info(f"Generating tests for {len(combination_keys)} feature combinations")

    tests_dir = cfg.work_dir / SAVED_PR_TESTS_DIR
    tests_dir.mkdir(parents=True, exist_ok=True)

    args = [(key,) for key in combination_keys]
    results = run_in_parallel(cfg.fuzz.jobs, _generate_and_fix_one_test, args)
    successful_tests = [res for res in results if res]

    logger.success(f"Successfully generated {len(successful_tests)} compilable tests")
    return len(successful_tests)


def _generate_and_fix_one_test(combo_key: str) -> bool:
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
                        fixed_code = fix_test_with_error_message(current_code, result.error_message)

                        if fixed_code != current_code:
                            current_code = fixed_code
                            logger.debug(f"Applied fix for combination {combo.id} (attempt {fix_attempt + 1})")
                        else:
                            logger.debug(f"No fix generated for combination {combo.id} (attempt {fix_attempt + 1})")
                    else:
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

    logger.info("Loading existing features...")
    combo_store = FeatureComboStore("pr_analysis_running")
    for feat_file in cfg.initial.features:
        if Path(feat_file).exists():
            combo_store.load_combo_store_from_file(feat_file)
            logger.debug(f"Loaded features from {feat_file}")
    total_features = combo_store.vstore.num_items()
    logger.success(f"Loaded {total_features} existing features")

    if total_features == 0:
        logger.error("No existing features found. Please run feature extraction first.")
        return

    concepts = analyze_pr_for_concepts(pr_info)
    (cfg.work_dir / SAVED_CONCEPTS_FILE).write_text("\n".join(concepts), encoding="utf-8")

    relevant_features = find_relevant_features(concepts, combo_store)
    features_list = [f.dump_for_llm() for f in relevant_features]
    (cfg.work_dir / SAVED_SELECTED_FEATURES_FILE).write_text("\n===========\n".join(features_list), encoding="utf-8")

    new_combo_store = FeatureComboStore(NEW_COMBO_STORE_NAME)
    generate_feature_combinations(relevant_features, new_combo_store)

    num_tests = generate_and_fix_tests(new_combo_store)

    if num_tests == 0:
        logger.error("No compilable tests were generated. Exiting.")
        return

    save_store_and_create_task(pr_info, new_combo_store)

    # Report results to user
    print("\n/**************************************************/\n")
    print(f"Successfully processed PR #{pr_number}")
    print(f"Title: {pr_info.title}")
    print(f"URL: {pr_info.url}")
    print(f"Task configuration saved to: {cfg.work_dir / SAVED_PR_TASK_FILE}")
    print(f"Feature combinations saved to: {(cfg.work_dir / SAVED_PR_SEED_FEATURE_STORE_FILE).with_suffix('.md')}")

    print("------")
    print(f"Generated {num_tests} compilable tests")
    print(f"Tests saved to: {cfg.work_dir / SAVED_PR_TESTS_DIR}")
    print("To see coverage results for the generated tests, run:")
    print(
        f"python -m src.main coverage -d {cfg.work_dir / SAVED_PR_TESTS_DIR} -o {cfg.work_dir}/coverage -b data/baseline.lcov"
    )

    print("------")
    print("🚀 Ready to start fuzzing with these combinations as initial population!")
    print(f"Run: python -m src.main fuzz --task {cfg.work_dir / SAVED_PR_TASK_FILE} --work-dir {cfg.work_dir}/fuzz")

    monitor = Monitor()
    print(f"Total cost so far: {monitor.get_total_cost_usd()}")
