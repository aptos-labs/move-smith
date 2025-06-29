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
from .coverage import Coverage
from .fast_coverage import FastCoverage
from .feature import Feature
from .fixer import fix_test, static_fix_syntax
from .generate_test import generate_new_tests
from .llm import cosine_sim, get_content_hash
from .runner import run_one_test
from .store import FeatureStore, Monitor

# Fuzzing statistics keys
NUM_FEATURES_KEY = "num_features"
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


@dataclass
class ExecutionResult:
    test_coverage: FastCoverage
    unique_coverage: FastCoverage
    interesting_coverage: FastCoverage
    has_error: bool
    error_message: str


def run_test_and_calculate_coverages(test_code: str) -> ExecutionResult:
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
            save_unique_test(test_code)

            start = time.perf_counter()
            total_coverage = total_coverage.merge(run_result.coverage)
            monitor.store.set_pickle(CUMULATIVE_COVERAGE_KEY, total_coverage)
            monitor.record_unique_coverage(total_coverage.total_cov())
            monitor.record_time(Monitor.COVERAGE_TIME_KEY, start)

            cov_file = cfg.work_dir / CUMULATIVE_COVERAGE_FILE_NAME
            cov_file.write_text(json.dumps(total_coverage.to_dict(), indent=2))
        else:
            if cfg.fuzz.save_all_tests:
                save_unique_test(test_code)
            elif cfg.fuzz.save_all_compilable and not run_result.has_error:
                save_unique_test(test_code)
            logger.trace("No unique coverage found.")

    interesting_cov = run_result.coverage.keep_only(cfg.task.interesting_files)

    return ExecutionResult(
        test_coverage=run_result.coverage,
        unique_coverage=uniq_cov,
        interesting_coverage=interesting_cov,
        has_error=run_result.has_error,
        error_message=run_result.error_message,
    )


def append_features_to_code(features: list[Feature], code: str) -> str:
    features_str_list = []
    for feat in features:
        features_str_list.append(f"// {feat.id}: {feat.description}")
    features_str = "\n".join(features_str_list)
    return f"{code}\n\n// Featurres:\n{features_str}\n"


def evaluate(individual: Individual) -> FitnessValue:
    monitor = Monitor()
    feature_store = FeatureStore()
    # Generate tests
    features = [feature_store.get_feature(id) for id in individual]

    start = time.perf_counter()
    tests_code = generate_new_tests(features)
    tests_code = [static_fix_syntax(code) for code in tests_code]
    monitor.record_time(Monitor.LLM_TIME_KEY, start)
    monitor.incr_counter(NUM_TESTS_KEY, len(tests_code))

    tests_code = [append_features_to_code(features, code) for code in tests_code]

    # Evaluate each test
    score_list = [evaluate_test(test_code) for test_code in tests_code]
    (obj1, obj2, obj3) = [sum(x) for x in zip(*score_list)]

    # Objective 4: Similarity to the feature combo
    start = time.perf_counter()
    feature_sim = 0.0
    for desc in cfg.task.goals:
        for feat in features:
            feature_sim += cosine_sim(desc, feat.description)
    monitor.record_time(Monitor.GENETIC_TIME_KEY, start)

    return (obj1, obj2, obj3, feature_sim)


def evaluate_test(test_code: str) -> tuple[float, float, float]:
    monitor = Monitor()
    result = run_test_and_calculate_coverages(test_code)
    fix_cnt = 0
    while fix_cnt < cfg.fuzz.fix_attempt_limit and result.has_error:
        logger.warning("Test failed with error, attempting to fix...")
        start = time.perf_counter()
        fixed_code = fix_test(test_code, result.error_message)
        fixed_code = static_fix_syntax(fixed_code)
        monitor.record_time(Monitor.LLM_TIME_KEY, start)
        monitor.incr_counter(NUM_TESTS_KEY)
        monitor.incr_counter(NUM_FIX_ATTEMPTS_KEY)
        test_code = fixed_code
        result = run_test_and_calculate_coverages(test_code)
        fix_cnt += 1

    if not result.has_error:
        monitor.incr_counter(NUM_COMPILABLE_TESTS_KEY)
        logger.info("Generated a compilable test.")
    else:
        logger.warning("Generated a non-compilable test...")

    monitor = Monitor()
    start = time.perf_counter()
    # Objective 1: general coverage improvement
    uniq_branch_cov = (
        result.unique_coverage.total_cov().lines_covered() + result.unique_coverage.total_cov().branches_covered()
    )

    # Objective 2: code similarity to task goals
    code_similarity = 0.0
    for desc in cfg.task.goals:
        code_similarity += cosine_sim(desc, test_code)

    # Objective 3: coverage on interesting files
    covered_interesting_branches = (
        result.interesting_coverage.total_cov().lines_covered()
        + result.interesting_coverage.total_cov().branches_covered()
    )
    monitor.record_time(Monitor.GENETIC_TIME_KEY, start)

    return (uniq_branch_cov, code_similarity, covered_interesting_branches)


def save_unique_test(test_code: str) -> None:
    monitor = Monitor()
    unique_tests_dir = cfg.work_dir / "unique_tests"
    unique_tests_dir.mkdir(parents=True, exist_ok=True)
    file_hash = get_content_hash(test_code)
    (unique_tests_dir / f"{file_hash}.move").write_text(test_code, encoding="utf-8")
    monitor.incr_counter(NUM_UNIQUE_TESTS_KEY)


def mutate(individual: Individual) -> Individual:
    RM_PB = 0.1
    if len(individual) > 1 and random.random() < RM_PB:
        idx = random.randint(0, len(individual) - 1)
        individual.pop(idx)

    num_new_features = random.randint(1, 3)
    new_features = random.sample(FeatureStore().get_all_keys(), num_new_features)
    for new_feature in new_features:
        if new_feature not in individual:
            individual.append(new_feature)
    logger.trace(f"Mutated individual {individual} to ==> {new_features}")
    return individual


def fuzzing_loop() -> None:
    monitor = Monitor()
    result = run_one_test("", keep_mapping=True)

    mapping_json = json.dumps(result.coverage.mappings, indent=2, default=lambda x: x.__dict__)
    (cfg.work_dir / "file_mapping.json").write_text(mapping_json, encoding="utf-8")

    monitor.store.set_pickle(FAST_COVERAGE_WITH_MAPPINGS_KEY, result.coverage)
    monitor.store.set_pickle(CUMULATIVE_COVERAGE_KEY, FastCoverage.empty())
    monitor.store.set(TOTAL_GENERATION_KEY, cfg.fuzz.generations)

    feature_store = FeatureStore()
    for feat_file in cfg.fuzz.features:
        feature_store.load_features_from_file(feat_file)

    # Positive weights meaning we want to maximize these objectives
    creator.create("FitnessMin", base.Fitness, weights=(1.0, 1.0, 1.0, 1.0))
    creator.create("Individual", list, fitness=creator.FitnessMin)
    toolbox = base.Toolbox()
    pop = [
        creator.Individual(random.sample(feature_store.get_all_keys(), 3))
        for _ in range(cfg.fuzz.feature_combination.init)
    ]

    pool = multiprocessing.Pool(processes=cfg.fuzz.jobs)
    toolbox.register("map", pool.map)
    toolbox.register("mate", tools.cxUniform, indpb=0.5)
    toolbox.register("mutate", mutate)
    toolbox.register("select", tools.selTournament, tournsize=3)
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
        parents = toolbox.select(pop, cfg.fuzz.feature_combination.mu)
        monitor.record_time(Monitor.GENETIC_TIME_KEY, start)
        offspring = []

        while len(offspring) < cfg.fuzz.feature_combination.lam:
            start = time.perf_counter()
            p1, p2 = random.sample(parents, 2)
            child1, child2 = toolbox.clone(p1), toolbox.clone(p2)

            if random.random() < cfg.fuzz.feature_combination.cross_over_rate:
                logger.trace(f"Crossover between {child1} and {child2}")
                toolbox.mate(child1, child2)
                del child1.fitness.values
                del child2.fitness.values
                monitor.incr_counter(NUM_CROSSOVERS_KEY)

            for child in (child1, child2):
                if random.random() < cfg.fuzz.feature_combination.mutation_rate:
                    logger.trace(f"Mutating {child}")
                    toolbox.mutate(child)
                    del child.fitness.values
                    monitor.incr_counter(NUM_MUTATIONS_KEY)
                offspring.append(child)

        offspring = offspring[: cfg.fuzz.feature_combination.lam]
        monitor.record_time(Monitor.GENETIC_TIME_KEY, start)

        fitnesses = toolbox.map(toolbox.evaluate, offspring)
        for ind, fit in zip(offspring, fitnesses):
            ind.fitness.values = fit

        pop = toolbox.select(pop + offspring, cfg.fuzz.feature_combination.mu)
        save_redis()

    save_features()
    save_redis()
    show_fuzzing_stat()


def save_features() -> None:
    feature_store = FeatureStore()
    feature_store.save_local(cfg.work_dir / "feature_store.json", overwrite=True)


def save_redis() -> None:
    monitor = Monitor()
    monitor.store.dump_to_local(cfg.work_dir / "dump.rdb")


def show_fuzzing_stat(save_unique_lines: bool = True) -> None:
    monitor = Monitor()
    total_cov = monitor.store.get(CUMULATIVE_COVERAGE_KEY, FastCoverage)
    cov_with_mapping = monitor.store.get(FAST_COVERAGE_WITH_MAPPINGS_KEY, FastCoverage)
    total_cov.mappings = cov_with_mapping.mappings

    logger.info(f"Total coverage after evolution: {total_cov.total_cov()}")

    num_unique_tests = monitor.store.get(NUM_UNIQUE_TESTS_KEY, int)
    logger.info(f"Number of unique tests generated: {num_unique_tests}")

    original_total_lcov = DATA_DIR / "baseline.lcov"
    if original_total_lcov.exists():
        original_cov = Coverage.parse(original_total_lcov)
        logger.info(f"Transactional tests coverage: {original_cov.total_cov()}")
        fuzz_total = Coverage.parse_str(total_cov.convert_to_lcov())
        uniq = fuzz_total.unique_cov(original_cov)
        logger.info(f"Unique coverage compared to original: {uniq.total_cov()}")
        if save_unique_lines:
            (cfg.work_dir / "unique_lines.txt").write_text(uniq.dump_lines())
        uncovered = original_cov.unique_cov(fuzz_total)
        logger.info(f"Uncovered lines compared to original: {uncovered.total_cov()}")
        if save_unique_lines:
            (cfg.work_dir / "uncovered_lines.txt").write_text(uncovered.dump_lines())
