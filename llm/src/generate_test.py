from loguru import logger

from .config import cfg
from .feature import Feature
from .llm import LLMManager


def generate_new_tests(features: list[Feature], num_tests: int = 1) -> list[str]:
    llm_mgr = LLMManager.new(cfg.logs_dir / "test_generation")
    logger.info(f"Generating new test using {len(features)} features")

    features_str_list = []
    for i, feat in enumerate(features):
        features_str_list.append(f"{i+1}: {feat.description}")
    features_str = "\n".join(features_str_list)

    msg = f""" As an Aptos Move developer, you are tasked with writing a new transactional test case to thoroughly test the Move compiler and virtual machine.

The transactional test has the following format:
1. Above each new module, you should write `//# publish` to compile and publish the module.
    This will exercise the compiler to compile the module.
    The publish command must be at the beginning of the immediate line above the module definition.
2. Above each script, you should write `//# run` to indicate that the script should be run.
    This will exervcise both the compiler and the virtual machine.
    The run command must be at the beginning of the immediate line above the script definition.
3. If some functions defined in a module should be run, you should add `//# run <address>::<module name>::<function_name>` after the module definition.
    * If a signer is needed, you should add `--signers <address>` after the run command.
    * If other arguments are needed, you should add `--args <args>` after the run command where args are the arguments to the function.
    * You should try to implement some "runner" function inside the module that can be called without arguments.
    * An example run command: `//# run 0xCAFE::Module0::some_function --signers 0xBEEF --args 123u8 789u64`
4. You can ignore adding assertions.

Please reply with the transactional test code within a markdown code block.

The test should test the following features:
{features_str}
"""

    model = llm_mgr.get_model_by_name(cfg.models.default.name, cfg.models.default.temperature)
    # TODO: support multiple samples
    (_, code) = model.invoke_code(msg)
    return [code]
