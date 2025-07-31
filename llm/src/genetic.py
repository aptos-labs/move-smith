from __future__ import annotations

import json
import multiprocessing
import random
import time
from dataclasses import dataclass
from typing import TypeAlias

from deap import base, creator, tools
from loguru import logger

from .config import DATA_DIR, cfg
from .embedding import similarity_score
from .fast_coverage import FastCoverage
from .feature import Feature, FeatureCombination, FeatureType
from .feature_mutation import mate, mutate
from .feature_store import FeatureComboStore
from .fixer import fix_test_with_error_message, static_fix_syntax, static_fix_syntax_llm
from .generate_test import generate_new_tests
from .helper import get_content_hash
from .prompt_store import PromptStore, PromptStoreName
from .runner import run_one_test
from .store import Monitor

# Fuzzing statistics keys
NUM_FEATURES_KEY = "num_features"
NUM_INDIVIDUALS_KEY = "num_individuals"
NUM_TESTS_KEY = "num_tests"
NUM_UNIQUE_TESTS_KEY = "num_unique_tests"
NUM_COMPILABLE_TESTS_KEY = "num_compilable_tests"
NUM_FIX_ATTEMPTS_KEY = "num_fix_attempts"
CURRENT_GENERATION_KEY = "current_generation"
TOTAL_GENERATION_KEY = "total_generation"
NUM_MUTATIONS_KEY = "num_mutations"
NUM_CROSSOVERS_KEY = "num_crossovers"

CUMULATIVE_COVERAGE_KEY = "cumulative_coverage"
CUMULATIVE_COVERAGE_LOCK = "lock:cumulative_coverage"
CUMULATIVE_COVERAGE_FILE_NAME = "cumulative_coverage.json"
FAST_COVERAGE_WITH_MAPPINGS_KEY = "fast_coverage_with_mappings"

# Type Definitions
Individual: TypeAlias = list[str]
FitnessValue: TypeAlias = tuple[float, float, float, float]
# (unique_coverage, code_similarity, interesting_coverage, feature_similarity)


def ind_to_combo(ind: Individual, combo_store: FeatureComboStore) -> FeatureCombination:
    return combo_store.get_item("".join(ind))


def ind_to_str(ind: Individual) -> str:
    return "".join(ind)


def combo_to_ind(combo: FeatureCombination) -> Individual:
    return list(combo.id)


def update_ind(ind: Individual, combo: FeatureCombination) -> Individual:
    ind.clear()
    ind.extend(list(combo.id))
    return ind


@dataclass
class ExecutionResult:
    test_coverage: FastCoverage
    unique_coverage: FastCoverage
    interesting_coverage: FastCoverage
    has_error: bool
    error_message: str


def run_test_and_calculate_coverages(test_code: str, combo: FeatureCombination) -> ExecutionResult:
    monitor = Monitor()
    run_result = run_one_test(test_code)
    monitor.record_coverage(run_result.coverage.total_cov())

    with monitor.store.client.lock(CUMULATIVE_COVERAGE_LOCK, timeout=10):
        start = time.perf_counter()
        total_coverage = monitor.store.get(CUMULATIVE_COVERAGE_KEY, FastCoverage)
        uniq_cov = run_result.coverage.unique_cov(total_coverage)
        uniq_cov_aggregated = uniq_cov.total_cov()
        monitor.record_time(Monitor.COVERAGE_TIME_KEY, start)

        if not uniq_cov_aggregated.is_empty():
            logger.success(f"Found unique coverage: {uniq_cov_aggregated}")
            save_unique_test(test_code, combo)

            start = time.perf_counter()
            total_coverage = total_coverage.merge(run_result.coverage)
            monitor.store.set_pickle(CUMULATIVE_COVERAGE_KEY, total_coverage)
            monitor.record_unique_coverage(total_coverage.total_cov())
            monitor.record_time(Monitor.COVERAGE_TIME_KEY, start)

            cov_file = cfg.work_dir / CUMULATIVE_COVERAGE_FILE_NAME
            cov_file.write_text(json.dumps(total_coverage.to_dict(), indent=2))
        else:
            if cfg.fuzz.save_all_tests:
                save_unique_test(test_code, combo)
            elif cfg.fuzz.save_all_compilable and not run_result.has_error:
                save_unique_test(test_code, combo)
            logger.trace("No unique coverage found.")

    interesting_cov = run_result.coverage.keep_only(cfg.task.interesting_files)

    return ExecutionResult(
        test_coverage=run_result.coverage,
        unique_coverage=uniq_cov,
        interesting_coverage=interesting_cov,
        has_error=run_result.has_error,
        error_message=run_result.error_message,
    )


def append_features_to_code(combo: FeatureCombination, code: str) -> str:
    features_str_list = []
    for feat in combo.features:
        features_str_list.append(f"// {feat.id}: {feat.description}")
    features_str = "\n".join(features_str_list)
    return f"{code}\n\n// Features:\n{features_str}\n"


def evaluate(individual: Individual) -> FitnessValue:
    monitor = Monitor()
    monitor.incr_counter(NUM_INDIVIDUALS_KEY)

    combo_store = FeatureComboStore("running")
    # Generate tests
    logger.trace(f"Evaluating individual: {ind_to_str(individual)}")
    combo = ind_to_combo(individual, combo_store)
    logger.trace(f"Retrieved individual: {ind_to_str(individual)}")

    start = time.perf_counter()
    tests_code = generate_new_tests(combo)
    tests_code = [static_fix_syntax(code) for code in tests_code]
    tests_code = [static_fix_syntax_llm(code) for code in tests_code]
    monitor.record_time(Monitor.LLM_TIME_KEY, start)
    monitor.incr_counter(NUM_TESTS_KEY, len(tests_code))

    tests_code = [append_features_to_code(combo, code) for code in tests_code]
    for code in tests_code:
        save_generated_test(code)

    # Evaluate each test
    score_list = [evaluate_test(test_code, combo) for test_code in tests_code]
    (obj1, obj2, obj3) = [sum(x) for x in zip(*score_list)]

    # Objective 4: Similarity to the feature combo
    start = time.perf_counter()
    feat_descs = [feat.description for feat in combo.features]
    feature_sim = similarity_score(feat_descs, cfg.task.goals)
    monitor.record_time(Monitor.GENETIC_TIME_KEY, start)

    return (obj1, obj2, obj3, feature_sim)


def evaluate_test(test_code: str, combo: FeatureCombination) -> tuple[float, float, float]:
    monitor = Monitor()
    result = run_test_and_calculate_coverages(test_code, combo)
    fix_cnt = 0
    while fix_cnt < cfg.fuzz.fix_attempt_limit and result.has_error:
        logger.warning("Test failed with error, attempting to fix...")
        start = time.perf_counter()
        fixed_code = fix_test_with_error_message(test_code, result.error_message)
        monitor.incr_counter(NUM_TESTS_KEY)
        fixed_code = static_fix_syntax(fixed_code)
        save_generated_test(fixed_code)
        monitor.record_time(Monitor.LLM_TIME_KEY, start)
        monitor.incr_counter(NUM_FIX_ATTEMPTS_KEY)
        test_code = fixed_code
        result = run_test_and_calculate_coverages(test_code, combo)
        fix_cnt += 1

    if not result.has_error:
        monitor.incr_counter(NUM_COMPILABLE_TESTS_KEY)
        logger.info("Generated a compilable test.")
    else:
        logger.warning("Generated a non-compilable test...")

    # Objective 1: general coverage improvement
    uniq_branch_cov = (
        result.unique_coverage.total_cov().lines_covered() + result.unique_coverage.total_cov().branches_covered()
    )

    monitor = Monitor()
    start = time.perf_counter()
    # Objective 2: code similarity to task goals
    code_similarity = similarity_score(test_code, cfg.task.goals)

    # Objective 3: coverage on interesting files
    covered_interesting_branches = (
        result.interesting_coverage.total_cov().lines_covered()
        + result.interesting_coverage.total_cov().branches_covered()
    )
    monitor.record_time(Monitor.GENETIC_TIME_KEY, start)

    return (uniq_branch_cov, code_similarity, covered_interesting_branches)


def save_unique_test(test_code: str, combo: FeatureCombination) -> None:
    monitor = Monitor()
    unique_tests_dir = cfg.work_dir / "unique_tests"
    unique_tests_dir.mkdir(parents=True, exist_ok=True)
    file_hash = get_content_hash(test_code)
    (unique_tests_dir / f"{file_hash}.move").write_text(test_code, encoding="utf-8")
    monitor.incr_counter(NUM_UNIQUE_TESTS_KEY)

    good_combo_store = FeatureComboStore("good")
    good_combo_store.add_combo(combo)
    logger.trace(f"Saved combo {combo.id} to good combo store for successful test {file_hash}")


def save_generated_test(test_code: str) -> None:
    generated_tests_dir = cfg.work_dir / "generated_tests"
    generated_tests_dir.mkdir(parents=True, exist_ok=True)
    file_hash = get_content_hash(test_code)
    (generated_tests_dir / f"{file_hash}.move").write_text(test_code, encoding="utf-8")


def mate_individuals(parent1: Individual, parent2: Individual) -> tuple[Individual, Individual]:
    combo_store = FeatureComboStore("running")
    parent1_combo = ind_to_combo(parent1, combo_store)
    parent2_combo = ind_to_combo(parent2, combo_store)

    child1, child2 = mate(parent1_combo, parent2_combo)
    combo_store.add_combo(child1)
    combo_store.add_combo(child2)
    update_ind(parent1, child1)
    update_ind(parent2, child2)

    return (parent1, parent2)


def mutate_individual(individual: Individual) -> Individual:
    combo_store = FeatureComboStore("running")
    curr_combo = ind_to_combo(individual, combo_store)

    mutated_combo = mutate(curr_combo)
    combo_store.add_combo(mutated_combo)

    logger.trace(f"Mutated individual {ind_to_str(individual)} to ==> {mutated_combo.id}")
    return update_ind(individual, mutated_combo)


def load_data_to_redis() -> None:
    logger.info("Loading data to Redis...")

    monitor = Monitor()

    logger.info("Creating and storing coverage mapping...")
    result = run_one_test("", keep_mapping=True)
    mapping_json = json.dumps(result.coverage.to_dict(), indent=2, default=lambda x: x.__dict__)
    (cfg.work_dir / "file_mapping.json").write_text(mapping_json, encoding="utf-8")

    monitor.store.set_pickle(FAST_COVERAGE_WITH_MAPPINGS_KEY, result.coverage)
    monitor.store.set_pickle(CUMULATIVE_COVERAGE_KEY, FastCoverage.empty())

    logger.info("Loading individual features from files...")
    combo_store = FeatureComboStore("running")
    for feat_file in cfg.fuzz.features:
        combo_store.load_combo_store_from_file(feat_file)
    logger.success(f"Loaded {combo_store.vstore.num_items()} individual features from {cfg.fuzz.features}")

    logger.info("Loading individual features from task...")
    for feat_str in cfg.task.features:
        feature = Feature.new_feature(description=feat_str, content="", type=FeatureType.USER)
        feature.score = 10.0
        combo_store.add_individual_feature(feature)
    logger.success(f"Added {len(cfg.task.features)} task specific features to the store.")

    _good_combo_store = FeatureComboStore("good")
    logger.info("Created empty good feature store")

    logger.info("Loading prompts...")
    prompt_store = PromptStore()
    for store_name in PromptStoreName:
        if store_name in cfg.prompt:
            dirs = cfg.prompt[store_name]
        else:
            continue
        for dir_path in dirs:
            prompt_store.load_prompts_in_dir(store_name, dir_path)
    logger.success(f"Loaded prompts into {len(prompt_store.stores)} stores.")


def fuzzing_loop() -> None:
    load_data_to_redis()
    monitor = Monitor()
    combo_store = FeatureComboStore("running")

    monitor.store.set(TOTAL_GENERATION_KEY, cfg.fuzz.generations)

    # Positive weights meaning we want to maximize these objectives
    creator.create("FitnessMin", base.Fitness, weights=(1.0, 1.0, 1.0, 1.0))
    creator.create("Individual", list, fitness=creator.FitnessMin)
    toolbox = base.Toolbox()

    init_combos = combo_store.search_with_str("\n".join(cfg.task.goals), top_k=cfg.fuzz.feature_combination.init)
    init_output_strs = [
        f"Init num is {cfg.fuzz.feature_combination.init}",
        f"Search returned {len(init_combos)} combinations",
    ]
    for combo in init_combos:
        for feature in combo.features:
            init_output_strs.append(f"{feature.id}: {feature.description}")
    (cfg.work_dir / "init_features.txt").write_text("\n".join(init_output_strs), encoding="utf-8")
    pop = [creator.Individual(combo_to_ind(combo)) for combo in init_combos]

    pool = multiprocessing.Pool(processes=cfg.fuzz.jobs)
    toolbox.register("map", pool.map)
    toolbox.register("mate", mate_individuals)
    toolbox.register("mutate", mutate_individual)
    toolbox.register("select", tools.selRoulette)
    toolbox.register("evaluate", evaluate)

    fitnesses = toolbox.map(toolbox.evaluate, pop)
    for ind, fit in zip(pop, fitnesses):
        ind.fitness.values = fit

    for g in range(cfg.fuzz.generations):
        logger.trace(f"Generation {g + 1}/{cfg.fuzz.generations}")
        monitor.incr_counter(CURRENT_GENERATION_KEY)
        if monitor.reached_total_cost_limit():
            logger.info("Reached total cost limit, stopping fuzzing loop.")
            break

        start = time.perf_counter()
        if len(pop) < cfg.fuzz.feature_combination.mu:
            parents = pop
        else:
            parents = toolbox.select(pop, cfg.fuzz.feature_combination.mu)
        monitor.record_time(Monitor.GENETIC_TIME_KEY, start)

        offspring = []
        while len(offspring) < cfg.fuzz.feature_combination.lam:
            start = time.perf_counter()
            p1, p2 = random.sample(parents, 2)
            logger.trace(f"Selected parent 1: {ind_to_str(p1)}")
            logger.trace(f"Selected parent 2: {ind_to_str(p2)}")
            child1, child2 = toolbox.clone(p1), toolbox.clone(p2)

            if random.random() < cfg.fuzz.mutation.cross_over_rate:
                logger.trace(f"Crossover between {ind_to_str(child1)} and {ind_to_str(child2)}")
                toolbox.mate(child1, child2)
                del child1.fitness.values
                del child2.fitness.values
                monitor.incr_counter(NUM_CROSSOVERS_KEY)

            for child in (child1, child2):
                if random.random() < cfg.fuzz.mutation.mutation_rate:
                    logger.trace(f"Mutating {ind_to_str(child)}")
                    toolbox.mutate(child)
                    del child.fitness.values
                    monitor.incr_counter(NUM_MUTATIONS_KEY)
                offspring.append(child)

        offspring = offspring[: cfg.fuzz.feature_combination.lam]
        monitor.record_time(Monitor.GENETIC_TIME_KEY, start)

        fitnesses = toolbox.map(toolbox.evaluate, offspring)
        for ind, fit in zip(offspring, fitnesses):
            ind.fitness.values = fit

        before_selection = pop + offspring
        before_selection_str = set([ind_to_str(ind) for ind in pop + offspring])

        if len(before_selection) <= cfg.fuzz.feature_combination.mu:
            logger.trace("Population size is less than or equal to mu, no selection needed.")
            pop = before_selection
        else:
            pop = toolbox.select(before_selection, cfg.fuzz.feature_combination.mu)

        selected_str = set([ind_to_str(ind) for ind in pop])
        unselected_str = before_selection_str - selected_str

        for id in unselected_str:
            logger.trace(f"Removing unselected individual: {id}")
            combo_store.remove_item(id)

        save_redis()
        save_good_combos()

    save_all_features()
    save_redis()
    show_fuzzing_stat()


def save_good_combos() -> None:
    good_combos = FeatureComboStore("good")
    good_combos.save_local(cfg.work_dir / "good_feature_combos.json", overwrite=True)
    good_combos.save_as_human_readable_file(cfg.work_dir / "good_feature_combos.md")
    logger.info(f"Saved good feature combinations to {cfg.work_dir / 'good_feature_combos.json'}")


def save_all_features() -> None:
    running_combos = FeatureComboStore("running")
    running_combos.save_local(cfg.work_dir / "running_feature_combos.json", overwrite=True)
    save_good_combos()


def save_redis() -> None:
    monitor = Monitor()
    monitor.store.dump_to_local(cfg.work_dir / "dump.rdb")


def show_fuzzing_stat(save_unique_lines: bool = True) -> None:
    monitor = Monitor()
    total_cov = monitor.store.get(CUMULATIVE_COVERAGE_KEY, FastCoverage)
    cov_with_mapping = monitor.store.get(FAST_COVERAGE_WITH_MAPPINGS_KEY, FastCoverage)
    total_cov.copy_mappings(cov_with_mapping)

    logger.info(f"Total coverage after evolution: {total_cov.total_cov()}")

    num_unique_tests = monitor.store.get(NUM_UNIQUE_TESTS_KEY, int)
    logger.info(f"Number of unique tests generated: {num_unique_tests}")

    baseline_lcov = DATA_DIR / "baseline.lcov"
    if baseline_lcov.exists():
        baseline_cov = FastCoverage.parse_lcov_with_mapping(
            baseline_lcov, root="third_party", keep_only=["third_party"]
        )
        logger.info(f"Transactional tests coverage: {baseline_cov.total_cov()}")
        baseline_cov.convert_to_other_mapping(cov_with_mapping)

        uniq = total_cov.unique_cov(baseline_cov)
        logger.info(f"Unique coverage compared to baseline: {uniq.total_cov()}")
        if save_unique_lines:
            (cfg.work_dir / "unique_lines.txt").write_text(uniq.dump_lines())

        uncovered = baseline_cov.unique_cov(total_cov)
        logger.info(f"Uncovered lines compared to baseline: {uncovered.total_cov()}")
        if save_unique_lines:
            (cfg.work_dir / "uncovered_lines.txt").write_text(uncovered.dump_lines())
            (cfg.work_dir / "uncovered_lines.txt").write_text(uncovered.dump_lines())
