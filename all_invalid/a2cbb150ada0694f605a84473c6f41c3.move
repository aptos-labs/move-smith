
//# publish
module 0xCAFE::FeatureInteractionTests {
    use std::signer;
    use std::vector;

    // Dummy struct for ability tests
    struct AbilityStruct has copy, drop, store {}

    // Function to test variable shadowing in nested scopes
    public fun shadowing_test(): bool {
        let x = 10u64;
        let result = if (x > 5u64) {
            let x = 20u64; // shadow outer x
            let y = x + 5u64;
            // loop with variable shadowing
            while (y < 50u64) {
                let y = y + 10u64; // shadow y
                y
            };
            y // after loop, should still be inner y
        } else {
            0u64
        };
        // Check that inner shadowing didn't affect outer x or y
        result == 35u64 // inner loop yields 30 + 5 = 35
    }

    // Function to assign functions to variables and invoke
    public fun function_pointer_test(): u64 {
        fun generic_add<T: copy + drop + store>(a: T, b: T): T {
            // handle u64 specifically
            if (exists<T>() == false) {
                // fallback to zero
                0u64
            } else {
                // only test with u64 for simplicity
                // compile-time restriction
                // use runtime cast
                0u64
            }
        }
        // Assign to variable
        let fn_var: fn(u64, u64) -> u64 = generic_add;
        // Call via variable
        fn_var(12, 23)
    }

    // Function to test passing functions as arguments
    public fun apply_function(f: fn(u64, u64) -> u64, a: u64, b: u64): u64 {
        f(a, b)
    }

    // Function for function passing test
    public fun function_passing_main(): u64 {
        let add_fn: fn(u64, u64) -> u64 = |a: u64, b: u64| a + b;
        apply_function(add_fn, 7, 8)
    }

    // Function to test specifications: precondition and postcondition
    public fun spec_check(x: u64): u64 {
        // Precondition: x must be positive
        assert!(x > 0, 999);
        // Postcondition: return value >= x
        let result = x + 10;
        assert!(result >= x, 999);
        result
    }

    // Ability checks: move, copy, drop within nested calls
    public fun move_and_copy_test(): (AbilityStruct, AbilityStruct) {
        let a = AbilityStruct {};
        let b = copy a; // allowed because struct has copy
        (a, b)
    }

    // Tuple with unnamed fields access
    public fun tuple_access_tests(): u64 {
        let t1 = (42u64, true);
        let first = *tuple::borrow_0(&t1);
        let second = *tuple::borrow_1(&t1);
        // verify access
        if (first == 42u64 && second) {
            1u64
        } else {
            0u64
        }
    }

    // Instantiate nested generic and move semantics
    public fun nested_generic_move<Z: copy + drop>(val: Z): Z {
        val
    }

    // Test instantiating an empty struct variant (unit-like)
    public fun instantiate_empty_struct(): () {
        ()
    }
}


//# run 0xCAFE::FeatureInteractionTests::shadowing_test

//# run 0xCAFE::FeatureInteractionTests::function_pointer_test

//# run 0xCAFE::FeatureInteractionTests::function_passing_main

//# run 0xCAFE::FeatureInteractionTests::spec_check --args 10u64

//# run 0xCAFE::FeatureInteractionTests::move_and_copy_test

//# run 0xCAFE::FeatureInteractionTests::tuple_access_tests

//# run 0xCAFE::FeatureInteractionTests::nested_generic_move --args 123u64

//# run 0xCAFE::FeatureInteractionTests::instantiate_empty_struct


// Featurres:
// b70ccb6e356eebb5b3735f5f76cd5273: Write script entry points in Move modules
// 0b62e2b6ef6d21801ee5807769ee6a3e: Test that local variable assignments inside and outside a while loop are handled correctly and that variable shadowing does not affect values across loop iterations.
// c75b5002236cb27e7430836ca3ad0a31: Test that functions (including generic functions) can be used as first-class values—assigned to variables, passed as closures and function pointers, and invoked as arguments or with type arguments.
// fdc6779e3d725d21cb1af960a124c0e2: Implement specification checking to ensure that specifications adhere to pureness and correctness standards.
// 8342a5161de0c9cb2d493b1ee5f4bf40: Run ability checks to ensure proper use of copy, move, and drop operations based on type abilities.
// 4cf2880fe87afa7d8e339827d2aa4ca1: Declare tuple types with anonymous fields in Move, using the syntax (Type1, Type2, ...), where fields are named '0', '1', etc.
// a1012bc33bd28958397f5112b643c7cf: Create empty struct variants with no fields.
