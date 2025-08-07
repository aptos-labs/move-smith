from pathlib import Path
from typing import List

from loguru import logger

from .config import cfg
from .feature import FeatureCombination
from .fixer import fix_test_with_error_message, static_fix_syntax, static_fix_syntax_llm
from .generate_test import get_feature_prompt
from .helper import get_content_hash, run_in_parallel
from .llm import LLMWrapper, Message, load_extra_prompts_from_files
from .pr_analysis import PRInfo
from .runner import run_one_test


def _enhance_and_fix_one_file(
    filename: str,
    original_content: str,
    feature_combinations: List[FeatureCombination],
    enhanced_dir: Path,
    relevant_features: List[FeatureCombination] = [],
) -> int:
    """Enhance one file and apply fixing process similar to _generate_and_fix_one_test."""
    logger.info(f"Processing enhancement for {filename}")

    llm = LLMWrapper.new(cfg.logs_dir / "test_enhancement")
    safe_filename = Path(filename).name

    # Use configurable number of feature combinations
    max_features = cfg.initial.max_enhancement_features

    # Select relevant feature combinations for this file - prefer relevant_features if available
    if relevant_features:
        available_combinations = relevant_features[:max_features]  # Use relevant features first
        logger.debug(f"Using {len(available_combinations)} relevant features for enhancement selection")
    else:
        available_combinations = feature_combinations[:max_features]  # Fallback to general combinations
        logger.debug(f"Using {len(available_combinations)} general features for enhancement selection")

    if not available_combinations:
        logger.warning(f"No feature combinations available for {filename}")
        return 0

    # First pass: Ask model to select the most relevant feature combinations
    system_msg = load_extra_prompts_from_files(cfg.prompt.generation_system)

    # Create feature descriptions for selection
    features_descriptions = []
    for i, combo in enumerate(available_combinations):
        features_descriptions.append(f"Feature Set {i+1}: {get_feature_prompt(combo)}")
    features_text = "\n\n".join(features_descriptions)

    selection_msg = f"""You are given an existing Move file and multiple feature sets to choose from for enhancement.

Original Move file ({filename}):
```move
{original_content}
```

Available feature sets:
{features_text}

Analyze the original file and select the most relevant feature sets that would create meaningful test enhancements. Consider:
1. Which features would test aspects not already covered in the original file
2. Which features are most compatible with the existing code structure
3. Which features would add the most value for testing

Respond with ONLY the numbers of the selected feature sets (e.g., "1, 3, 5"), selecting up to {min(len(available_combinations), cfg.initial.max_enhancement_features)} feature sets."""

    try:
        selection_msgs = Message.new_sys_and_user(system_msg, selection_msg)
        selection_response = llm.invoke(
            cfg.models.default.name, cfg.models.default.temperature, selection_msgs, retry_attempts=3
        )

        # Parse the selection response
        selected_indices = []
        if selection_response:
            try:
                # Extract numbers from the response
                import re

                numbers = re.findall(r"\b(\d+)\b", selection_response)
                selected_indices = [int(n) - 1 for n in numbers if 1 <= int(n) <= len(available_combinations)]
            except:
                logger.warning(f"Failed to parse feature selection for {safe_filename}, using first features")
                selected_indices = list(range(min(3, len(available_combinations))))

        if not selected_indices:
            logger.warning(f"No valid features selected for {safe_filename}, using first features")
            selected_indices = list(range(min(3, len(available_combinations))))

        selected_combinations = [available_combinations[i] for i in selected_indices]
        logger.debug(f"Selected {len(selected_combinations)} feature combinations for {safe_filename}")

    except Exception as e:
        logger.error(f"Error in feature selection for {safe_filename}: {e}, using first features")
        selected_combinations = available_combinations[: min(3, len(available_combinations))]

    # Second pass: Generate one enhanced test for each selected combination
    successful_tests = 0

    for combo_idx, combo in enumerate(selected_combinations):
        logger.debug(f"Generating enhanced test {combo_idx + 1}/{len(selected_combinations)} for {safe_filename}")

        combo_success = False
        feature_desc = get_feature_prompt(combo)

        for gen_attempt in range(cfg.initial.generation_attempt_limit):
            if combo_success:
                break

            logger.debug(
                f"Generation attempt {gen_attempt + 1}/{cfg.initial.generation_attempt_limit} for {safe_filename} combo {combo_idx + 1}"
            )

            try:
                prefix = load_extra_prompts_from_files(cfg.prompt.generation_prefix)
                prefix = f"You should follow the following guidelines and example:\n{prefix}" if prefix else ""

                user_msg = f"""Here are the guidelines:
{prefix}

You are given an existing Move file and a specific feature to test. Create an enhanced version that:
1. Keeps all existing functionality intact
2. Adds comprehensive test cases for the specific feature
3. Follows the same style and structure as the original
4. Uses proper transactional test format

Original Move file ({filename}):
```move
{original_content}
```

Feature to test:
{feature_desc}

Generate an enhanced version of this Move file that includes the original content plus new test cases for this specific feature.

Please reply with the complete enhanced Move file within a markdown code block."""

                msgs = Message.new_sys_and_user(system_msg, user_msg)
                enhanced_content = llm.invoke_and_extract_code(
                    cfg.models.default.name, cfg.models.default.temperature, msgs, retry_attempts=3
                )

                if not enhanced_content:
                    logger.warning(
                        f"No enhanced content generated for {safe_filename} combo {combo_idx + 1} on attempt {gen_attempt + 1}"
                    )
                    continue

                current_code = enhanced_content

                # Apply the same fixing process as _generate_and_fix_one_test
                for fix_attempt in range(cfg.initial.fix_attempt_limit):
                    current_code = static_fix_syntax(current_code)
                    current_code = static_fix_syntax_llm(current_code)

                    logger.debug(
                        f"Testing compilation for {safe_filename} combo {combo_idx + 1} (gen {gen_attempt + 1}, fix {fix_attempt + 1})"
                    )
                    result = run_one_test(current_code)

                    if not result.has_error:
                        logger.success(
                            f"Enhanced file compiled successfully: {safe_filename} combo {combo_idx + 1} (gen {gen_attempt + 1}, fix {fix_attempt + 1})"
                        )

                        # Save the successfully compiled enhanced file
                        file_hash = get_content_hash(current_code)
                        enhanced_file = (
                            enhanced_dir / f"{file_hash}_{safe_filename.replace('.move', '')}_{combo_idx + 1}.move"
                        )
                        enhanced_file.write_text(current_code, encoding="utf-8")
                        logger.debug(f"Saved enhanced file to {enhanced_file}")

                        combo_success = True
                        successful_tests += 1
                        break
                    else:
                        if fix_attempt < cfg.initial.fix_attempt_limit - 1:
                            logger.debug(
                                f"Attempting to fix compilation errors for {safe_filename} combo {combo_idx + 1} (attempt {fix_attempt + 1}/{cfg.initial.fix_attempt_limit})"
                            )
                            fixed_code = fix_test_with_error_message(current_code, result.error_message)

                            if fixed_code != current_code:
                                current_code = fixed_code
                                logger.debug(
                                    f"Applied fix for {safe_filename} combo {combo_idx + 1} (attempt {fix_attempt + 1})"
                                )
                            else:
                                logger.debug(
                                    f"No fix generated for {safe_filename} combo {combo_idx + 1} (attempt {fix_attempt + 1})"
                                )
                        else:
                            logger.warning(
                                f"All fix attempts failed for {safe_filename} combo {combo_idx + 1} generation {gen_attempt + 1}"
                            )

            except Exception as e:
                logger.error(f"Error processing {safe_filename} combo {combo_idx + 1} (gen {gen_attempt + 1}): {e}")
                continue

        if not combo_success:
            logger.warning(
                f"Failed to generate compilable enhanced file for {safe_filename} combo {combo_idx + 1} after {cfg.initial.generation_attempt_limit} generations with {cfg.initial.fix_attempt_limit} fix attempts each"
            )

    return successful_tests


def enhance_existing_move_files(
    pr_info: PRInfo,
    feature_combinations: List[FeatureCombination],
    relevant_features_map: dict[str, List[FeatureCombination]] = None,
) -> int:
    """Enhance existing .move files from PR with additional test cases and apply fixing process."""
    logger.info(
        f"Enhancing {len(pr_info.move_files_content or [])} Move files with {len(feature_combinations)} feature combinations"
    )

    if not pr_info.move_files_content or not feature_combinations:
        logger.warning("No Move files or feature combinations available for enhancement")
        return 0

    # Create enhanced directory
    enhanced_dir = cfg.work_dir / "enhanced_move_files"
    enhanced_dir.mkdir(parents=True, exist_ok=True)

    # Collect all relevant features from the map for use in enhancement
    all_relevant_features = []
    if relevant_features_map:
        for diff_feature_relevant in relevant_features_map.values():
            all_relevant_features.extend(diff_feature_relevant)
        # Remove duplicates by converting to dict using id as key, then back to list
        unique_relevant_features = {}
        for feat in all_relevant_features:
            unique_relevant_features[feat.id] = feat
        all_relevant_features = list(unique_relevant_features.values())
        logger.info(f"Using {len(all_relevant_features)} unique relevant features for enhancement")

    args = [
        (filename, original_content, feature_combinations, enhanced_dir, all_relevant_features)
        for filename, original_content in pr_info.move_files_content
    ]

    results = run_in_parallel(cfg.fuzz.jobs, _enhance_and_fix_one_file, args)
    total_successful_tests = sum(results)

    logger.success(
        f"Successfully generated {total_successful_tests} enhanced tests from {len(pr_info.move_files_content)} Move files"
    )
    return total_successful_tests
