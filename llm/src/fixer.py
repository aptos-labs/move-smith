import re

from .config import cfg
from .llm import LLMManager
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


# FIXING_PROMPTS = {
#     "need_drop": "If a value is dropped but its type does not have the drop ability, you need to either add the `drop` ability to it's type definition or consume the value.",
#     "consume_struct": "To consume a struct value without the `drop` ability, you need to unpack the struct by using `let StructName { .. } = value;`",
#     "consume_enum": "To consume an enum value without the `drop` ability, you need to unpack the enum by using a match expression `match value { EnumType::Variant1 => (), EnumType::Variant2 => (), ... };`. You MUST explicitly handle all variants of the enum.",
#     "use_vector": "To use vector, you need `use std::vector;` at the top of module body.",
#     "assign_tuple": "You cannot assign a tuple to a single variable. You must assign each element to different variables, e.g. `let (a, b) = get_tuple(); let (_, _) = get_tuple();`",
#     "nested_module": "You cannot define a module inside another module. You must delete the inner module or move it out.",
#     "run_signer": "A function that takes signer as arguments must have signers as the first few arguments followed by other arguments. Then in the `//# run` command, use `--signers ADDRESS1 ADDRESS2 ... --args ARG1 ARG2 ...` to pass the signers and arguments.",
#     "semicolon": "When using `if`, `if-else`, `while`, `for`, or `loop` expression as a statement, you must end the expression with a semicolon. For example, `if (condition) { ... } else { ... };`.",
#     "parentheses": "When using `if`, `if-else`, `while`, `for`, or `loop` expression, you must use parentheses around the condition. For example, `if (condition) { ... } else { ... };`.",
#     "used_example": "0xCAFE::MyModule and 0xCAFE::StorageUsage are only example modules. You cannot reference to them.",
#     "constant_scope": "Constants are private to the module they are defined in.",
#     "no_return": "If a function has no return type, it cannot end with an expression. It must end with a statemetn. If the function intends to return something, the return type must be specified, e.g. `fun my_function() : u64 { ...; x }`.",
#     "missing_key": "To store some struct/enum under an address with `move_to`, the struct/enum MUST have the `key` ability. If the struct/enum has type parameters, the type parameters must also have the `key` ability.",
#     "run_args": "Try not to use complex argument types like vector, struct, or enum for the function you want to run with `//# run`. Instead, create a simple `runner` function with primitive types as arguments. You are not writing production code. It is ok to have extra helper functions for testing purposes.",
# }

# ERROR_MAPPING = {
#     "does not have the `drop` ability": ["need_drop", "consume_struct", "consume_enum"],
#     "Unbound module or type alias 'vector'": ["use_vector"],
#     "is not allowed as a type argument": ["assign_tuple"],
#     "Unexpected 'module'": ["nested_module"],
#     "NUMBER_OF_ARGUMENTS_MISMATCH": ["run_signer"],
#     "Expected ';'": ["semicolon"],
#     "Expected '('": ["parentheses"],
#     "Unbound module: '0xCAFE::MyModule": ["used_example"],
#     "Unbound module: '0xCAFE::StorageUsage": ["used_example"],
#     "cannot be used here because it is private to the module": ["constant_scope"],
#     "from a function which returns nothing": ["no_return"],
#     "is missing required ability `key`": ["missing_key"],
#     "for '--args [<ARGS>...]'": ["run_complex_args"],
# }


# def get_fixer_prompt(error_msg: str) -> str:
#     if not cfg.fuzz.enable_dynamic_fixer_hint:
#         return ""

#     prompts = []
#     for error_template, promt_keys in ERROR_MAPPING.items():
#         if error_template in error_msg:
#             for key in promt_keys:
#                 if key in FIXING_PROMPTS:
#                     prompts.append(FIXING_PROMPTS[key])
#     return "Related error fixing guidelines:\n" + "\n".join(prompts) if prompts else ""


# def _old_fix_test(test_to_fix: str, error_msg: str) -> str:
#     llm_mgr = LLMManager.new(cfg.logs_dir / "test_fixer")

#     system_msg = load_extra_promts_from_files(cfg.prompt.fixer_system)
#     prefix = load_extra_promts_from_files(cfg.prompt.fixer_prefix)

#     fixer_prompt = get_fixer_prompt(error_msg)

#     msg = f"""As an Aptos Move developer, you are tasked with fixing a transactional test that fails to compile or run correctly.

# {prefix}

# {fixer_prompt}

# The failing test is:

# ```move
# {test_to_fix}
# ```

# The error message is:
# ```
# {error_msg}
# ```

# Please reply with the fixed transactional test code within a markdown code block.
# """

#     model = llm_mgr.get_model_by_name(cfg.models.default.name, cfg.models.default.temperature)
#     # TODO: support multiple samples
#     (_, code) = model.invoke_code(msg, system_message=system_msg)
#     return code


def static_fix_syntax_llm(code_to_fix: str) -> str:
    if not cfg.fuzz.enable_static_fixer:
        return code_to_fix

    store = PromptStore()
    prompts = store.get_all_prompts(PromptStoreName.STATIC_ERROR_FIXES)
    hints = "\n--\n".join(p.content for p in prompts)

    prompt = f"""As an experienced Move on Aptos developer, you should check and fix any syntactical issues in the following Move code.
If the code is correct, you should reply with only "CORRECT" within a markdown code block.

Some hints for how to fix common errors:
{hints}

The code to check:
```
{code_to_fix}
```

If the code is wrong, please return the fixed code within a markdown code block.
If the code is correct, please reply with "CORRECT" within a markdown code block."""

    llm_mgr = LLMManager.new(cfg.logs_dir / "static_fixer")
    model = llm_mgr.get_model_by_name(cfg.models.default.name, cfg.models.default.temperature)
    (_, code) = model.invoke_code(prompt)
    if "CORRECT" in code:
        return code_to_fix
    return code


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

    prompt = f"""As an experienced Move on Aptos developer, you should fix the Move code based on the error message and guidance.
Some hints for how to fix common errors:
{hints}

```move
{move_examples_str}
```

The error message is:
```
{error_msg}
```

The code to fix:
```move
{test_to_fix}
```

The error message is:
```
{error_msg}
```

Please return the fixed code within a markdown code block."""

    llm_mgr = LLMManager.new(cfg.logs_dir / "dynamic_fixer")
    model = llm_mgr.get_model_by_name(cfg.models.default.name, cfg.models.default.temperature)
    (_, code) = model.invoke_code(prompt)
    return code
