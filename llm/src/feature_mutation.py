import random

from loguru import logger

from .config import cfg
from .feature import Feature, FeatureCombination, FeatureType
from .feature_store import FeatureComboStore
from .llm import LLMManager
from .prompt_store import PromptStore, PromptStoreName


def mate(
    parent1: FeatureCombination,
    parent2: FeatureCombination,
) -> tuple[FeatureCombination, FeatureCombination]:
    """Cross-over two feature combinations to create two new ones by randomly switching elements."""
    logger.trace(f"Performing cross-over between {parent1.id} and {parent2.id}.")

    if len(parent1.features) == 1 or len(parent2.features) == 1:
        logger.trace("One of the parents has only one feature, performing list mutation instead.")
        new_parent1 = mutate_list(parent1)
        new_parent2 = mutate_list(parent2)
        return (new_parent1, new_parent2)

    seen = set()
    all_features = []
    for feature in parent1.features + parent2.features:
        if feature.id not in seen:
            seen.add(feature.id)
            all_features.append(feature)

    if len(all_features) == 0:
        logger.trace("No unique features found after combining parents.")
        return (parent1, parent2)

    if len(all_features) > 2 * cfg.fuzz.mutation.combo_size_max:
        all_features = random.sample(list(all_features), 2 * cfg.fuzz.mutation.combo_size_max)

    # Shuffle all features first, then split in half
    random.shuffle(all_features)
    mid_point = len(all_features) // 2
    child1_features = all_features[:mid_point]
    child2_features = all_features[mid_point:]

    child1 = FeatureCombination.new_combination(child1_features)
    child2 = FeatureCombination.new_combination(child2_features)

    logger.trace(
        f"Created two children from cross-over: {child1.id} ({len(child1.features)} features) and {child2.id} ({len(child2.features)} features)."
    )

    return (child1, child2)


def mutate(
    combo: FeatureCombination,
) -> FeatureCombination:
    """Return a list of semantically mutated feature combinations"""
    logger.trace(f"Mutating FeatureCombo {combo.id}.")

    mutated = False

    if random.random() < cfg.fuzz.mutation.list_mutation_rate:
        mutated = True
        combo = mutate_list(combo)

    if random.random() < cfg.fuzz.mutation.merge_mutation_rate and len(combo.features) >= 2:
        mutated = True
        indices = random.sample(range(len(combo.features)), k=2)
        feature1 = combo.features[indices[0]]
        feature2 = combo.features[indices[1]]
        merged_feature = merge_two_features(feature1, feature2)
        new_features = [f for i, f in enumerate(combo.features) if i not in indices]
        new_features.append(merged_feature)
        combo = FeatureCombination.new_combination(new_features)

    if random.random() < cfg.fuzz.mutation.semantic_mutation_rate and len(combo.features) > 0:
        mutated = True
        indices_to_mutate = set(random.sample(range(len(combo.features)), k=random.randint(1, len(combo.features))))
        new_features = []
        for idx in range(len(combo.features)):
            original_feature = combo.features[idx]
            if idx in indices_to_mutate:
                mutated_feature = mutate_single_feature(original_feature)
                new_features.append(mutated_feature)
            else:
                new_features.append(original_feature)
        combo = FeatureCombination.new_combination(new_features)

    if mutated:
        logger.trace(f"Created mutated combination {combo.id} with {len(combo.features)} features.")
    else:
        logger.trace(f"No mutation applied to {combo.id}.")

    return combo


def merge_two_features(feature1: Feature, feature2: Feature) -> Feature:
    """Merge two features into a new feature."""
    logger.trace(f"Performing merge on features {feature1.id} and {feature2.id}.")

    llm_mgr = LLMManager.new(cfg.logs_dir / "merge_mutation")

    feats_str = f"Feature 1: {feature1.description}\nFeature 2: {feature2.description}"

    system_msg = """You are an expert in the Aptos Move programming language. Your task is to merge two Move language features into a single, more complex feature that demonstrates their interaction.

The merged feature should:
1. Combine both original features in a meaningful way
2. Show how they interact or work together
3. Be more comprehensive than either feature alone
4. Remain testable and implementable in Move

Focus on creating realistic interactions between the features rather than just listing them separately."""

    msg = f"""Merge these two Move language features into a single, more complex feature:

{feats_str}

Please provide the merged feature description in a concise manner.
"""

    model = llm_mgr.get_model_by_name(cfg.models.default.name, cfg.models.default.temperature)
    (_, response) = model.invoke(msg, system_message=system_msg)
    description = response.strip()

    merged_feature = Feature.new_feature(description=description, content=feats_str, type=FeatureType.MERGE)

    logger.trace(f"Created merged feature {merged_feature.id}: {description}")
    return merged_feature


def mutate_single_feature(feature: Feature) -> Feature:
    """Mutate a single feature's semantic by changing its description or content."""
    logger.trace(f"Performing semantic mutation on Feature {feature.id}.")

    prompt_store = PromptStore()
    all_mutation_prompts = prompt_store.get_all_prompts(PromptStoreName.MUTATIONS)
    selected_prompt = random.choice(all_mutation_prompts)
    logger.trace(f"Selected mutation prompt: {selected_prompt.id}")

    llm_mgr = LLMManager.new(cfg.logs_dir / "single_mutation")

    system_msg = """You are an expert in the Aptos Move programming language. Your task is to mutate a Move language feature according to the given mutation instruction.

Follow the mutation instruction precisely and apply it to transform the original feature description. The result should be a valid, testable Move language feature that follows the mutation pattern."""

    msg = f"""Apply the following mutation instruction to transform this Move language feature:

MUTATION INSTRUCTION:
{selected_prompt.content}

ORIGINAL FEATURE:
{feature.description}

Please provide only the mutated feature description as your response. Keep it concise and focused on the mutation applied."""

    model = llm_mgr.get_model_by_name(cfg.models.default.name, cfg.models.default.temperature)
    (_, response) = model.invoke(msg, system_message=system_msg)
    mutated_description = response.strip()

    mutated_feature = Feature.new_feature(
        description=mutated_description,
        content=f"Mutated from: {feature.description}\nBy: {selected_prompt.content}",
        type=FeatureType.MUTATION,
    )

    logger.trace(f"Created mutated feature {mutated_feature.id}: {mutated_description}")
    return mutated_feature


def mutate_list(
    combo: FeatureCombination,
) -> FeatureCombination:
    """List-level mutation of a feature combination."""
    logger.trace(f"Performing list mutation on FeatureCombo {combo.id}.")
    combo_store = FeatureComboStore("running")

    if len(combo.features) >= 3:
        operation = random.choice(["remove", "similar", "append"])
    else:
        operation = random.choice(["similar", "append"])

    new_features = combo.features.copy()
    max_combo_size = cfg.fuzz.mutation.combo_size_max

    to_add = []

    if operation == "remove" and len(new_features) > 1:
        num_to_remove = random.randint(1, min(len(new_features) - 1, len(new_features) // 2))
        indices_to_remove = random.sample(range(len(new_features)), num_to_remove)
        new_features = [f for i, f in enumerate(new_features) if i not in indices_to_remove]
        logger.trace(f"Removed {num_to_remove} features from combination.")
    elif operation == "similar":
        similar_combos = combo_store.search_with_combo(combo, top_k=3)
        if similar_combos:
            similar_combo = random.choice(similar_combos)
            to_add = similar_combo.features
            logger.trace(f"Added similar features from combination {similar_combo.id}.")
    elif operation == "append":
        all_combo_keys = combo_store.get_all_keys()
        if all_combo_keys:
            random_combo_id = random.choice(all_combo_keys)
            random_combo = combo_store.get_item(random_combo_id)
            to_add = random_combo.features
            logger.trace(f"Appended features from combination {random_combo_id}.")

    # Add features from to_add list, avoiding duplicates
    for feature in to_add:
        if feature.id not in set(f.id for f in new_features):
            new_features.append(feature)

    if len(new_features) > max_combo_size:
        new_features = random.sample(new_features, max_combo_size)

    mutated_combo = FeatureCombination.new_combination(new_features)
    logger.trace(f"Created mutated combination {mutated_combo.id} with {len(mutated_combo.features)} features.")

    return mutated_combo
