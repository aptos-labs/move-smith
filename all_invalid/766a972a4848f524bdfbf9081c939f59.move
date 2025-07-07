
//# publish
module 0xFACE::TestFeatures {
    use std::assert;
    use std::vector;

    // Struct to test nested field access
    struct NestedStruct has store {
        inner: InnerStruct,
        value: u64,
    }

    struct InnerStruct has store {
        a: u8,
        b: u16,
    }

    // For testing variable scope and shadowing
    public fun shadow_variable_test() {
        let outer_var = 10u64;
        let i = 0u64;
        while (i < 3u64) {
            let outer_var = 100u64; // shadowing outer variable
            assert!(outer_var == 100u64, 0);
            // inside loop, outer_var is shadowed
            i = i + 1;
        };
        // outside loop, original outer_var remains
        assert!(outer_var == 10u64, 0);
    }

    // Internal function (should not be accessible outside module)
    fun internal_helper_function(x: u64): u64 {
        x + 1
    }

    // Function to test access restriction
    public fun test_internal_access() {
        let x = internal_helper_function(5);
        assert!(x == 6, 0);
    }

    // Specification check: precondition and postcondition
    public fun safe_divide(numerator: u64, denominator: u64): u64
        ensures result != 0 { // postcondition
        assert!(denominator != 0, 1); // precondition
        numerator / denominator
    }

    // Testing function currying with closure
    public fun apply_closure(x: u8, closure: |u8| u8): u8 {
        closure(x)
    }

    // Conditional closure for currying test
    public fun conditional_closure(y: u8): |u8| u8 {
        if (y % 2u8 == 0u8) {
            |a: u8| a + y
        } else {
            |a: u8| a - y
        }
    }

    // Function to test closures with different inputs
    public fun test_closures() {
        let closure_even = conditional_closure(2u8);
        let res_even = apply_closure(5u8, closure_even);
        assert!(res_even == 7u8, 0);

        let closure_odd = conditional_closure(3u8);
        let res_odd = apply_closure(5u8, closure_odd);
        assert!(res_odd == 2u8, 0);
    }

    // Function with nested functions and no unused functions
    public fun nest_and_unused_test() {
        // A private helper (which is used internally)
        fun helper(x: u8): u8 {
            x + 1
        }

        let res = helper(4u8);
        assert!(res == 5u8, 0);
        // Warning: no purely unused functions, but helper is private
    }

    // Function to test nested field access and variable persistence
    public fun nested_and_variable_test() {
        let nested = NestedStruct {
            inner: InnerStruct { a: 1, b: 2 },
            value: 42,
        };
        // Access nested fields
        assert!(nested.inner.a == 1, 0);
        assert!(nested.inner.b == 2, 0);
        assert!(nested.value == 42, 0);
        // Modify nested fields
        let nested_mut = nested;
        nested_mut.inner.a = 5;
        nested_mut.inner.b = 10;
        nested_mut.value = 100;
        assert!(nested_mut.inner.a == 5, 0);
        assert!(nested_mut.inner.b == 10, 0);
        assert!(nested_mut.value == 100, 0);
    }
}


//# run 0xFACE::TestFeatures::nested_and_variable_test --args

//# run 0xFACE::TestFeatures::shadow_variable_test --args

//# run 0xFACE::TestFeatures::test_internal_access --args

//# run 0xFACE::TestFeatures::safe_divide --args 10 2

//# run 0xFACE::TestFeatures::apply_closure --args 5 --signers 0xCAFE

//# run 0xFACE::TestFeatures::conditional_closure --args 3 --signers 0xCAFE

//# run 0xFACE::TestFeatures::test_closures --signers 0xCAFE

//# run 0xFACE::TestFeatures::nest_and_unused_test --args


// Featurres:
// 78f8dc464195108ec06049bb15ab9fa2: Access nested fields of expressions using dot notation in Move code.
// 0b62e2b6ef6d21801ee5807769ee6a3e: Test that local variable assignments inside and outside a while loop are handled correctly and that variable shadowing does not affect values across loop iterations.
// 63d45d364eac9afd0006b4525c93f85c: Use 'internal' visibility to restrict access within the module or package.
// fdc6779e3d725d21cb1af960a124c0e2: Implement specification checking to ensure that specifications adhere to pureness and correctness standards.
// 7f343e5b6a46a90c5e940d2d1b876be9: Test that function currying with different closures correctly evaluates conditional logic and produces expected results.
// de308ac75696561dec87c803c8e1d4af: Identify and warn about private functions or functions without friends that are unused, encouraging cleanup.
