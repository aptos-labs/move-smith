
//# publish
module 0xCAFE::TestModule {
    use std::vector; // Warning about unused import; can be removed if not used

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
            let shadow_inner_var = i * 2; // shadow inner_var
            i = i + 1;
            // inner_var is not modified here; shadowing does not affect outer inner_var
            // No need to assign or use inner_var
        };

        // Check the outer variable remains unchanged
        assert!(outer_var == 10, 999);
        // inner_var is unchanged; no shadowing variable accessible outside loop
        assert!(inner_var == 0, 999);

        // Nested loops and variable shadowing
        let outer_count = 0;
        while (outer_count < 2) {
            let inner_count = 0;
            while (inner_count < 2) {
                let inner_count_shadow = inner_count + 1; // shadow inner_count
                inner_count = inner_count_shadow; // update shadow variable
            };
            outer_count = outer_count + 1;
        };

        // Verify that outer_count has correct value
        assert!(outer_count == 2, 999);
    }

    // Test internal function visibility restrictions
    public fun test_internal_visibility() {
        // Call private/internal function from inside the module
        let result = internal_private_function(5u8);
        assert!(result == 6u8, 999);
    }

    // An internal function not exposed outside the module
    fun internal_private_function(x: u8): u8 {
        x + 1
    }

    // Verify that external code cannot call internal_private_function directly
    // (this is a compile-time restriction; no runtime test here)

    // Test inline functions with various parameters
    public fun test_inline_functions() {
        let (a, b) = inline_sum_and_product(4u8, 5u8);
        assert!(a == 9u8, 999);
        assert!(b == 20u8, 999);

        let result = nested_inline_test(3u8, 7u8);
        assert!(result == 11u8, 999);
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
