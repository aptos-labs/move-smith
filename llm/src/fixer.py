import re

from .config import cfg
from .llm import LLMWrapper, Message
from .prompt_store import PromptStore, PromptStoreName
from .store import Monitor

ERROR_FIX_HASH_KEY = "error_fix_cnts"

LETMUT_CNT_KEY = "let_mut_cnt"
TOVEC_CNT_KEY = "to_vec_cnt"
REF_LIFETIME_KEY = "ref_lifetime_cnt"
RESOURCE_STRUCT_KEY = "resource_struct_cnt"
WRONG_TXNAL_CMD_KEY = "wrong_txnal_cmd_cnt"
RUST_ANNOTATION_KEY = "rust_annotation_cnt"


def static_fix_syntax(code: str) -> str:
    if not cfg.fuzz.enable_static_fixer:
        return code

    monitor = Monitor()

    let_mut_cnt = code.count("let mut ")
    to_vec_cnt = code.count("to_vec")
    ref_lifetime_cnt = code.count("&'") + code.count("&mut'")
    resource_struct_cnt = code.count("resource struct")
    rust_annotation_cnt = code.count("#[")

    monitor.incr_counter_in_hash(ERROR_FIX_HASH_KEY, LETMUT_CNT_KEY, let_mut_cnt)
    monitor.incr_counter_in_hash(ERROR_FIX_HASH_KEY, TOVEC_CNT_KEY, to_vec_cnt)
    monitor.incr_counter_in_hash(ERROR_FIX_HASH_KEY, REF_LIFETIME_KEY, ref_lifetime_cnt)
    monitor.incr_counter_in_hash(ERROR_FIX_HASH_KEY, RESOURCE_STRUCT_KEY, resource_struct_cnt)
    monitor.incr_counter_in_hash(ERROR_FIX_HASH_KEY, RUST_ANNOTATION_KEY, rust_annotation_cnt)

    code = code.replace("let mut ", "let ")
    code = code.replace(".to_vec()", "")
    code = code.replace("resource struct", "struct")
    code = re.sub(r"(&(?:mut)?)'[^ ]+ ", r"\1 ", code)
    code = code.replace("#[", "// ")

    code = code.replace("//#", "\n//#")
    code = code.replace(" //#", "\n//")
    lines = code.splitlines()
    fixed_lines = static_fix_syntax_for_lines(lines)
    code = "\n".join(fixed_lines)

    return code


def static_fix_syntax_for_lines(lines: list[str]) -> list[str]:
    monitor = Monitor()
    fixed_lines = []
    for first_origin, second_origin in zip([""] + lines, lines + [""]):
        if "//# run" in second_origin and not second_origin.startswith("//# run"):
            monitor.incr_counter_in_hash(ERROR_FIX_HASH_KEY, WRONG_TXNAL_CMD_KEY)
            continue

        first = first_origin.strip()
        second = second_origin.strip()

        if second.startswith("module ") and not first.startswith("//# publish"):
            fixed_lines.append("//# publish")
            fixed_lines.append(second_origin)
            monitor.incr_counter_in_hash(ERROR_FIX_HASH_KEY, WRONG_TXNAL_CMD_KEY)
            continue

        if first.startswith("//# publish") and not second.startswith("module "):
            fixed_lines.pop()
            monitor.incr_counter_in_hash(ERROR_FIX_HASH_KEY, WRONG_TXNAL_CMD_KEY)
            continue

        if second.startswith("script") and not first.startswith("//# run"):
            fixed_lines.append("//# run")
            fixed_lines.append(second_origin)
            monitor.incr_counter_in_hash(ERROR_FIX_HASH_KEY, WRONG_TXNAL_CMD_KEY)
            continue

        if first == "//# run" and not second.startswith("script"):
            fixed_lines.pop()
            monitor.incr_counter_in_hash(ERROR_FIX_HASH_KEY, WRONG_TXNAL_CMD_KEY)
            continue

        fixed_lines.append(second_origin)

    return fixed_lines


def static_fix_syntax_llm(code_to_fix: str) -> str:
    if not cfg.fuzz.enable_static_fixer:
        return code_to_fix

    store = PromptStore()
    prompts = store.get_all_prompts(PromptStoreName.STATIC_ERROR_FIXES)
    hints = "\n--\n".join(p.content for p in prompts)

    system_msg = """You are an experienced Move on Aptos developer. You should check and fix any syntactical issues in the Move code.
If the code is correct, you should reply with only "CORRECT" within a markdown code block."""

    prompt = f"""The code to check:
```
{code_to_fix}
```

Some hints for how to fix common errors:
{hints}

If the code is wrong, please return the fixed code within a markdown code block.
If the code is correct, please reply with "CORRECT" within a markdown code block."""

    llm = LLMWrapper.new(cfg.logs_dir / "static_fixer")
    msgs = Message.new_sys_and_user(system_msg, prompt)
    response = llm.invoke_and_extract_code(
        cfg.models.default.name, cfg.models.default.temperature, msgs, retry_attempts=3
    )

    if response is None:
        return code_to_fix

    if "CORRECT" in response:
        return code_to_fix

    return response


def fix_test_with_error_message(test_to_fix: str, error_msg: str) -> str:
    if not cfg.fuzz.enable_dynamic_fixer_hint:
        return ""

    store = PromptStore()
    prompts = store.get_related_prompts(PromptStoreName.DYNAMIC_ERROR_FIXES, error_msg, top_k=5)
    hints = "\n--\n".join(p.content for p in prompts)

    move_examples = PromptStore().get_related_prompts(PromptStoreName.MOVE_EXAMPLES, error_msg, top_k=3)
    move_examples_list = [
        "Below are some relevant examples of Move tests showing language features. You should NEVER directly use these module/functions."
    ]
    for example in move_examples:
        move_examples_list.append(f"```move\n{example.content}\n```")
        move_examples_list.append("---")
    move_examples_str = "\n".join(move_examples_list)

    system_msg = """You are an experienced Move on Aptos developer. You should fix the Move code based on the error message and guidance."""

    prompt = f"""Here are some relevant example Move programs.
```move
{move_examples_str}
```

The code to fix:
```move
{test_to_fix}
```

The error message is:
```
{error_msg}
```

Some hints for how to fix common errors:
{hints}

Please return the fixed code within a markdown code block."""

    llm = LLMWrapper.new(cfg.logs_dir / "dynamic_fixer")
    msgs = Message.new_sys_and_user(system_msg, prompt)

    response = llm.invoke_and_extract_code(
        cfg.models.default.name, cfg.models.default.temperature, msgs, retry_attempts=3
    )

    return response if response is not None else test_to_fix
