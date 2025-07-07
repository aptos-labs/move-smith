
//# publish
module 0xCAFE::FeatureTest {
    use std::vector;

    // Test structure for internal and visibility checks
    struct InnerData has copy, drop, store, key {
        id: u64
    }

    public fun internal_access() {
        // public function to demonstrate internal access
        // Only calls within the module or invoking scripts are allowed
        // No external modules should access internal functions
        let _ = internal_function();
    }

    fun internal_function(): u64 {
        42
    }

    // Function with spec annotations: testing global/local variables
    public fun spec_variable_binding(x: u64): u64 {
        // 'x' in params is local by default; supposed to be recognized as local
        let y: u64 = x + 1;
        y
    }

    // Function for variable shadowing inside loops
    public fun variable_shadowing() {
        let count: u64 = 0;
        while (count < 3) {
            // Shadow variable name 'count' inside the loop
            let count: u64 = count + 1;
            // The outer 'count' should remain unchanged
            // Inside loop, 'count' refers to the inner variable
            // Outer 'count' should be updated only after the loop
        };
        // After loop, check the outer count
        count
    }

    // Function to bind expression results directly to variables
    public fun bind_expr_results(x: u8): (u8, u8, u8) {
        let a: u8 = x + 1;
        let b: u8 = x * 2;
        let c: u8 = a + b;
        (a, b, c)
    }

    // Function with nested path and aliasing test
    public fun nested_module_access() {
        // Define a nested module aliasing within this module
        let nested_mod = Nested::SubMod;
        // Access nested module function
        let _res = nested_mod::sub_func(5u8);
    }

    // Internal nested module
//# publish
    module Nested {
        public fun sub_func(val: u8): u8 {
            val + 10
        }
        // Hidden internal functions or locals are not exposed outside
        // Would cause access error if attempted outside module
    }

    // Function to test break with label inside nested loops
    public fun break_label_test(flag: bool): u8 {
        let result: u8 = 0;
        'outer: loop {
            let inner_result: u8 = 0;
            'inner: loop {
                if (flag) {
                    break 'outer; // exit outer loop from inner
                }
                inner_result = 1;
                break 'inner;
            };
            result = inner_result;
            break; // to prevent infinite loop
        };
        result
    }

    // Function to test yield of variable after a break
    public fun break_and_return(flag: bool): u64 {
        let x: u64 = 0;
        while (true) {
            if (flag) {
                break;
            };
            x = x + 1;
        };
        x
    }
}


//# run 0xCAFE::FeatureTest::internal_access

//# run 0xCAFE::FeatureTest::spec_variable_binding --args 123u64

//# run 0xCAFE::FeatureTest::variable_shadowing

//# run 0xCAFE::FeatureTest::bind_expr_results --args 10u8

//# run 0xCAFE::FeatureTest::nested_module_access

//# run 0xCAFE::FeatureTest::break_label_test --args true

//# run 0xCAFE::FeatureTest::break_label_test --args false

//# run 0xCAFE::FeatureTest::break_and_return --args true

//# run 0xCAFE::FeatureTest::break_and_return --args false


// Featurres:
// 5941dd503b9dcc73e363012d080654d1: Treat the entire program as a target for comprehensive analysis.
// 0b62e2b6ef6d21801ee5807769ee6a3e: Test that local variable assignments inside and outside a while loop are handled correctly and that variable shadowing does not affect values across loop iterations.
// 63d45d364eac9afd0006b4525c93f85c: Use 'internal' visibility to restrict access within the module or package.
// caa4ab8a3e36141117c8c50d0a12748d: Specify global or local variables in specifications.
// b97f161fc46919e92f4e2b88ea9444ff: Bind variables to the result of expressions
// 82f755af6a64ca1b7520a8282c6064dc: Define scripts using the 'script' keyword in Move files.
// a13f6a11ca9c03e08adf80b5b5c43003: Resolve module access chains that can be interpreted as module references, considering possible aliasing and nested paths.
// 1a7a52c3626ed29ee0b31738d0130103: Use 'break' with optional labels.
