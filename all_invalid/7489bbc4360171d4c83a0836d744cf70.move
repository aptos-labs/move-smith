



0xDEADBEEF::MyModule::foo(p=42u64, flag=true) --args 42u64 true


0xDEADBEEF::MyModule::foo(p=42u64, flag=false) --args 42u64 false


// Invoke 'foo' with true
let result_true = 0xDEADBEEF::MyModule::foo(p=42u64, flag=true) --args 42u64 true

// Invoke 'foo' with false
let result_false = 0xDEADBEEF::MyModule::foo(p=42u64, flag=false) --args 42u64 false

// Assert that result_true equals 'p'
assert!(result_true == 42u64, 999);

// Assert that result_false equals 'p'
assert!(result_false == 42u64, 999);

// Spec block annotations demonstrating interaction with spec features:

// Spec block: Function declaration
// Member: Variable with initial value using Variable
/*@ {
    "Members": [
        {"name": "test_var", "type": "u64", "initial_value": 0}
    ],
    "Statements": [
        {"type": "Let", "name": "test_var", "value": 42},
        {"type": "Include", "member": "test_var"},
        {"type": "Apply", "member": "increment", "arguments": []}
    ],
    "Pragmas": ["inline"]
} */

// Using a spec pragma to annotate inlining
/*@ pragma inline */  
// Using spec apply to denote a function as applied
/*@ apply public_function */


// Featurres:
// 4ee2a0b08f4677e897745bd9fd7b3e2e: Use named parameters and results in functions
// b0f60aa7637bb6c5525c3c99abb16efe: Use other spec block members such as 'Function', 'Variable', 'Let', 'Include', 'Apply', and 'Pragma' without restrictions, as they do not involve unbound names in this context.
// f131dd4886ed90171984346fc658f187: Test that the function `foo` correctly returns the value of `p` regardless of the boolean input by verifying assertions with true and false inputs.
