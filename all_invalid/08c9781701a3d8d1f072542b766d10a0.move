//# publish
module 0xCAFE::TestModule {
    use std::assert;
    use std::signer;

    // Structs and modules for testing internal visibility and scoping
    struct InternalStruct has copy, drop, store {
        value: u64,
    }

    // Helper module for internal functions
//# publish
    module 0xCAFE::Helper {
        // Internal function, only callable within this module
        fun internal_fun(x: u64): u64 {
            x + 10
        }

        // Public function that calls internal function
        public fun call_internal(x: u64): u64 {
            internal_fun(x)
        }
    }

    // Function to test variable scoping outside and inside loops
    public fun scope_test_script(s: signer): u64 {
        let outer_var = 42u64;

        // Declare a variable outside the loop
        let temp_var = 0u64;

        // First while loop with inner variable shadowing
        let inner_var = 100u64;
        if (outer_var > 40u64) {
            let outer_var = 7u64; // Shadowing outer_var
            let _inner_shadow = 55u64;
            // The outer_var inside this block shadows outer_var outside
            // No operation needed here
            let _result = outer_var + inner_var;
        }

        // After the if block, outer_var should remain unchanged
        assert!(outer_var == 42u64, 999);

        // Assign to temp_var
        temp_var = outer_var + 1;

        // Declare a variable inside a 'while' loop and ensure it doesn't persist outside
        let i = 0u64;
        while (i < 3u64) {
            let _loop_var = i * 10;
            i = i + 1;
        }
        // _loop_var is scoped inside the loop; cannot access here

        // Shadow variable in nested blocks inside loop
        let outer = 5u64;
        while (outer > 0) {
            let outer_shadow = outer - 1; // Shadowing outer
            {
                let _inner_outer = outer_shadow + 100; // Shadowed inside inner block
            }
            outer = outer - 1; // decrement outer to avoid infinite loop
        }

        // Final return value
        outer_var + temp_var
    }

    // Function to test calling internal functions
    public fun test_internal_visibility(x: u64): u64 {
        // Call internal function directly within module
        let result_inner = internal_fun(x);
        // Call through helper module that exposes internal function
        let result_helper = Helper::call_internal(x);
        result_inner + result_helper
    }

    // Function to test axioms with expression-bodied constraints (simulated with asserts)
    public fun check_type_axioms(value: u8) {
        // Enforce a constraint: value should be less than 100
        assert!(value < 100u8, 777);
        // Parity invariant: value's parity must be even
        assert!((value % 2) == 0, 778);
    }

    // Function to perform side-effect-free expressions only
    public fun pure_expression_tests(a: u64, b: u64): u64 {
        // Leaf operations and pure calls
        let sum = a + b;
        let prod = a * b;
        let max_val = if (a > b) { a } else { b };
        max_val + sum + prod
    }

    // Entry point to test variable scope, internal calls, axioms, and side-effects
    public fun run_all_tests(s: signer): u64 {
        // Test scope variables
        let scope_result = scope_test_script(s);
        // Test internal visibility functions
        let internal_result = test_internal_visibility(7);
        // Test axioms
        check_type_axioms(50u8);
        // Test pure expressions
        let pure_result = pure_expression_tests(10, 20);
        // Return combined result for validation
        scope_result + internal_result + pure_result
    }
}


//# run 0xCAFE::TestModule::run_all_tests --signers 0x1234
