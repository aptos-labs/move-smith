from loguru import logger

from .config import cfg
from .feature import Feature
from .llm import LLMManager, load_extra_promts_from_files


def generate_new_tests(features: list[Feature], num_tests: int = 1) -> list[str]:
    llm_mgr = LLMManager.new(cfg.logs_dir / "test_generation")
    logger.info(f"Generating new test using {len(features)} features")

    features_str_list = []
    for i, feat in enumerate(features):
        features_str_list.append(f"{i+1}: {feat.description}")
    features_str = "\n".join(features_str_list)

    system_msg = load_extra_promts_from_files(cfg.prompt.generation_system)
    prefix = load_extra_promts_from_files(cfg.prompt.generation_prefix)
    prefix = f"You should follow the following guidelines and example:\n{prefix}" if prefix else ""

    msg = f""" As an Aptos Move developer, you are tasked with writing a new transactional test case to thoroughly test the Move compiler and virtual machine.

{prefix}

Please reply with the transactional test code within a markdown code block.

The test should test the following features:
{features_str}
"""

    model = llm_mgr.get_model_by_name(cfg.models.default.name, cfg.models.default.temperature)
    # TODO: support multiple samples
    (_, code) = model.invoke_code(msg, system_message=system_msg)
    return [code]
