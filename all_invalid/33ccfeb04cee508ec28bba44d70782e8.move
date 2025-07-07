
//# publish
module 0xCAFE::DeepInteraction {

    use std::assert;

    // Nested data structure with deep fields
    struct InnerStruct has copy, drop, store {
        inner_field: u64,
    }

    struct OuterStruct has copy, drop, store {
        nested: InnerStruct,
        value: u32,
    }

    // Function to create a nested structure
    public fun create_nested_struct(inner_value: u64, outer_value: u32): OuterStruct {
        let inner = InnerStruct {inner_field: inner_value};
        let outer = OuterStruct {nested: inner, value: outer_value};
        outer
    }

    // Access nested field via dot notation
    public fun get_deep_field(os: &OuterStruct): u64 {
        os.nested.inner_field
    }

    // Demonstrate variable scoping and shadowing inside and outside while loops
    public fun scope_test(): (u64, u64) {
        let outer_var = 0u64;
        let result_inner: u64;

        while (true) {
            let outer_var = 100u64; // shadowing outer_var
            let inner_var = 50u64;

            let inner_loop_var = 25u64;
            let counter = 0u64;

            while (counter < 3) {
                let inner_loop_var = counter; // shadow inner_loop_var
                counter = counter + 1;
            }

            // after inner loop, inner_loop_var should be 2
            assert!(inner_loop_var == 2, 999);
            result_inner = inner_loop_var;

            // break outer loop after one iteration
            break;
        };

        // The outer_var should be unchanged outside loop
        (outer_var, result_inner)
    }

    // Internal function restrict visibility
    fun internal_func_only(): u64 {
        42u64
    }

    // Public function that tries to access internal function (allowed within module)
    public fun call_internal_func(): u64 {
        internal_func_only()
    }

    // Specification/ensures check example
    public fun check_precondition_and_postcondition(x: u64): u64 {
        // Precondition: x must be less than 1000
        assert!(x < 1000, 555);
        let result = x + 10;
        // Postcondition: result must be greater than x
        assert!(result > x, 556);
        result
    }

    // Closure with conditional logic: different arguments and result
    public fun closure_conditional(x: bool, a: u8, b: u8): u8 {
        // Curried-like closure (lambda)
        let lambda: |u8, u8| u8 = |arg_a: u8, arg_b: u8| {
            if (x) {
                arg_a + arg_b
            } else {
                arg_a * arg_b
            }
        };
        lambda(a, b)
    }

    // Function to call closure with various input combinations
    public fun test_closures(): (u8, u8) {
        let r1 = closure_conditional(true, 2, 3); // Expected: 5
        let r2 = closure_conditional(false, 2, 3); // Expected: 6
        (r1, r2)
    }
}


//# run 0xCAFE::DeepInteraction::get_deep_field --args 0xDEADBEAF


//# run 0xCAFE::DeepInteraction::scope_test


//# run 0xCAFE::DeepInteraction::call_internal_func --args


//# run 0xCAFE::DeepInteraction::check_precondition_and_postcondition --args 999u64


//# run 0xCAFE::DeepInteraction::test_closures


// Featurres:
// 78f8dc464195108ec06049bb15ab9fa2: Access nested fields of expressions using dot notation in Move code.
// 0b62e2b6ef6d21801ee5807769ee6a3e: Test that local variable assignments inside and outside a while loop are handled correctly and that variable shadowing does not affect values across loop iterations.
// 63d45d364eac9afd0006b4525c93f85c: Use 'internal' visibility to restrict access within the module or package.
// fdc6779e3d725d21cb1af960a124c0e2: Implement specification checking to ensure that specifications adhere to pureness and correctness standards.
// 7f343e5b6a46a90c5e940d2d1b876be9: Test that function currying with different closures correctly evaluates conditional logic and produces expected results.
