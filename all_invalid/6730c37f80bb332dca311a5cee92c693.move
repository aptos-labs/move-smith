
//# publish
module 0xCAFE::TestModule {
    use std::vector;

    // Public functions to act as entry points for scripts
    public fun run_feature_tests() {
        // No parameters needed; calls other internal test functions
        test_variable_and_loop_scoping();
        test_internal_visibility();
        test_inline_functions();
    }

    // Test local variable handling within and outside while loops
    public fun test_variable_and_loop_scoping() {
        // Initialize outer variable
        let outer_var = 10;
        let inner_var = 0;

        // Loop to increment inner_var
        let i = 0;
        while (i < 3) {
            let inner_var = i * 2; // shadow inner_var
            i = i + 1;
            inner_var;
        };

        // Check the outer variable remains unchanged
        assert!(outer_var == 10, 999);
        assert!(inner_var == 0, 999);

        // Nested loops and variable shadowing
        let outer_count = 0;
        while (outer_count < 2) {
            let inner_count = 0;
            while (inner_count < 2) {
                let inner_count = inner_count + 1; // shadow inner_count
                inner_count;
            };
            outer_count = outer_count + 1;
        };

        // Verify that outer_count has correct value
        assert!(outer_count == 2, 999);
    }

    // Test internal function visibility restrictions
    public fun test_internal_visibility() {
        // Attempt to call private/internal function from outside should fail
        // This is compiled-time; for runtime, we simulate call from inside
        let result = internal_private_function(5u8);
        result;
    }

    // An internal function not exposed outside the module
    fun internal_private_function(x: u8): u8 {
        x + 1
    }

    // Verify that external code cannot call internal_private_function directly
    // (this is a compile-time restriction — impossible to test at runtime in Move code)

    // Test inline functions with various parameters
    public fun test_inline_functions() {
        let (a, b) = inline_sum_and_product(4u8, 5u8);
        assert!(a == 9u8, 999);
        assert!(b == 20u8, 999);

        let result = nested_inline_test(3u8, 7u8);
        assert!(result == 10u8, 999);
    }

    // Inline function to sum and multiply two u8 values
    public inline fun inline_sum_and_product(x: u8, y: u8): (u8, u8) {
        let sum = x + y;
        let product = x * y;
        (sum, product)
    }

    // Function to test nested inline functions (for completeness)
    public inline fun nested_inline_test(x: u8, y: u8): u8 {
        let sum = inline_sum_and_product(x, y).0; // sum component
        sum + 1
    }
}

// Script entry points for testing the features


//# run 0xCAFE::TestModule::run_feature_tests


// Featurres:
// b70ccb6e356eebb5b3735f5f76cd5273: Write script entry points in Move modules
// 0b62e2b6ef6d21801ee5807769ee6a3e: Test that local variable assignments inside and outside a while loop are handled correctly and that variable shadowing does not affect values across loop iterations.
// 63d45d364eac9afd0006b4525c93f85c: Use 'internal' visibility to restrict access within the module or package.
// 057ed43b704e6042288e427679b31ffe: Ensure inline functions have their parameters properly checked for usage.
