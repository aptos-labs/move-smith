//# publish
module 0x1::DeprecationWarningTest {
    // Environment variable to control deprecation warnings (simulate via a module variable)
    // Note: In actual Aptos Move, environment variables are not directly accessible; this is conceptual for testing
    // We will simulate disabling warnings via a constant
    const WARNINGS_ENABLED: bool = true;

    // Functions that are deprecated (simulate)
    public fun deprecated_function() {
        // no-op
    }

    // Function to test enabling/disabling warnings
    public fun run_with_env_flag(env_enabled: bool) {
        // Simulate environment variable
        let _ = env_enabled; // placeholder
        // For testing, no actual warnings emitted, but structure in place
    }
}

//# publish
module 0x2::FunctionCallInlineClosureTest {
    public fun helper_inline_add(x: u64, y: u64): u64 {
        x + y
    }

    public fun run_test() {
        // Test inline function call
        let result_inline = helper_inline_add(10, 20);
        // Store or use result
        let _ = result_inline;

        // Test function call with parameters and return tuple
        let tuple_result = call_with_params(5u64, 15u64);
        // Extract values
        let (res1, res2) = tuple_result;

        // Test closure (simulate with anonymous function)
        let closure = |a: u64, b: u64| {
            a * b
        };
        let closure_result = closure(3, 4);
        let _ = closure_result;
    }

    fun call_with_params(a: u64, b: u64): (u64, u64) {
        // Call helper
        let sum = helper_inline_add(a, b);
        // Additional computation
        let product = a * b;
        (sum, product)
    }
}

//# run 0x2::FunctionCallInlineClosureTest::run_test

//# publish
module 0x3::VariableAssignmentTest {
    public fun run_assignment() {
        let mut a = 0u64;
        a = 42u64;

        let (mut x, mut y) = (1u64, 2u64);
        x = x + 1;
        y = y + 2;

        // Use variables to test assignment correctness
        let _ = (a, x, y);
    }
}

//# run 0x3::VariableAssignmentTest::run_assignment

//# publish
module 0x4::ComplexFunctionTest {
    // Function to accept multiple parameter types
    public fun process_tuple_and_variables(
        input: (u64, bool),
        extra: u8
    ): (u64, bool, u8) {
        let (num, flag) = input;
        // perform some operations
        let result_num = num + (extra as u64);
        (result_num, flag, extra)
    }

    // Function to test variable assignment with tuples
    public fun run_complex() {
        let tuple_input = (100u64, true);
        let extra_val = 5u8;
        let result = process_tuple_and_variables(tuple_input, extra_val);
        let (res_num, res_flag, res_extra) = result;

        // Inline nested function
        fun inner_fn(a: u64): u64 {
            a * 2
        }

        let doubled = inner_fn(res_num);
        let _ = (res_flag, res_extra, doubled);
    }
}

//# run 0x4::ComplexFunctionTest::run_complex

// Featurres:
// d7ed3a500e1dd4cda6c021401e5fdce3: Use an environment variable to enable or disable deprecation warnings during compilation
// 956362626ea76d8af911fd1edb9a9551: Avoid using the name 'Self' for module members, as it is restricted.
// f1d96b651080ac0705569fa50013eef4: Test the correct functioning of function calls, inline functions, and closures, including handling of parameters, tuples, and variable assignment.
