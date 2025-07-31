from loguru import logger

from .config import cfg
from .feature import Feature, FeatureCombination
from .llm import LLMWrapper, Message, load_extra_promts_from_files
from .prompt_store import PromptStore, PromptStoreName


def generate_new_tests(combo: FeatureCombination, num_tests: int = 1) -> list[str]:
    logger.info(f"Generating new test using {combo.num_features()} features")

    features_str = get_feature_prompt(combo.features)

    system_msg = load_extra_promts_from_files(cfg.prompt.generation_system)
    prefix = load_extra_promts_from_files(cfg.prompt.generation_prefix)

    prefix = f"You should follow the following guidelines and example:\n{prefix}" if prefix else ""

    # move_examples = PromptStore().get_related_prompts(PromptStoreName.MOVE_EXAMPLES, features_str, top_k=5)
    # move_examples_list = [
    #     "Below are some examples of Move tests showing language features. You should NEVER directly use these module/functions."
    # ]
    # for example in move_examples:
    #     move_examples_list.append(f"```move\n{example.content}\n```")
    #     move_examples_list.append("---")
    # move_examples_str = "\n".join(move_examples_list)
    move_examples_str = ""

    msg = f"""Here are some relevant Move knowledge and examples:

{prefix}

{move_examples_str}

Please create a new Move transactional test that tests the following features:
{features_str}

Please reply with the transactional test code within a markdown code block.
"""

    system_msg = """You are an expert Aptos Move developer with deep knowledge of Move language features.
    Your role is to help create comprehensive transactional tests that focus on feature interactions.
    """

    llm = LLMWrapper.new(cfg.logs_dir / "test_generation")
    msgs = Message.new_sys_and_user(system_msg, msg)
    response = llm.invoke_and_extract_code(
        cfg.models.default.name, cfg.models.default.temperature, msgs, retry_attempts=3
    )

    return [response] if response is not None else []


def get_feature_prompt(features: list[Feature]) -> str:
    if len(features) == 1:
        return features[0].description

    logger.info(f"Rewriting {len(features)} features into one")

    features_str_list = []
    for i, feat in enumerate(features):
        features_str_list.append(f"{i+1}: {feat.description}")
    features_str = "\n".join(features_str_list)

    if not cfg.fuzz.enable_feature_rewriter:
        return features_str

    system_msg = """You are an expert Aptos Move developer with deep knowledge of Move language features, best practices, and testing strategies. Your role is to help create comprehensive test plans that focus on feature interactions rather than isolated functionality testing."""

    examples = """Here are some examples of how to rewrite multiple features into cohesive test plans:

Example 1:
Input features:
1: Test vector operations with push_back and pop_back
2: Test struct field access patterns
3: Test error handling with abort conditions

Output plan:
Create a test that defines a struct containing a vector field, implements functions to manipulate the vector through struct methods, and validates error conditions when accessing empty vectors or invalid indices. Focus on how struct ownership affects vector operations and ensure proper error propagation.

Example 2:
Input features:
1: Test generic type parameters with ability constraints
2: Test global storage operations
3: Test function visibility and friend declarations

Output plan:
Design a test with generic resource types that have ability constraints, implement friend functions that transfer resources between modules, and verify that type parameters correctly enforce move semantics during resource operations. Test both successful transfers and constraint violations.

---

Now apply this approach to the given features:"""

    msg = f"""Features to test:
{features_str}

{examples}

Rewrite these features into a concise test plan focusing on their interactions (not individual features). Use simple imperative sentences. Keep within 200 words.
"""

    llm = LLMWrapper.new(cfg.logs_dir / "feature_prompt")
    msgs = Message.new_sys_and_user(system_msg, msg)
    response = llm.invoke(cfg.models.default.name, cfg.models.default.temperature, msgs)
    return response.content
