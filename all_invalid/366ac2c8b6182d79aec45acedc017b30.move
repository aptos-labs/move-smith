
//# publish
module 0xCAFE::InteractionTest {
    use std::signer;
    use std::vector;

    // Internal struct with internal visibility; should only be accessible within this module.
    struct InternalData has store, key {
        value: u64,
    }

    // Internal function which should not be accessible outside this module.
    fun internal_compute(x: u64): u64 {
        x * 2
    }

    // Public function to expose internal behavior for testing.
    public fun get_internal_value(x: u64): u64 {
        internal_compute(x)
    }

    // Entry point for testing local variable assignments and shadowing.
    public fun test_variable_scoping_and_assignment() {
        let outer_var = 10u64;
        let i = 0u64;
        while (i < 3) {
            let outer_var = outer_var + i; // shadow outer_var
            // inner `outer_var` is used here
            if (outer_var % 2 == 0) {
                let inner_var = outer_var + 100u64;
                // inner_var should be 10 + i + 100 for even outer_var
                // after inner block, inner_var is not accessible
            };
            i = i + 1;
        }
        // outer_var should remain unchanged here
        assert!(outer_var == 10u64, 999);
    }

    // Entry point for testing local variable inside while loop
    public fun test_variable_in_while_loop() {
        let counter = 0u64;
        let sum = 0u64;
        while (counter < 5) {
            let temp = counter * 2;
            sum = sum + temp;
            counter = counter + 1;
        }
        assert!(sum == 20u64, 1000);
    }

    // Test internal function visibility
    public fun test_internal_function_accessibility(p: u64): u64 {
        // Should be able to call internal function within module
        get_internal_value(p)
    }

    // Generic struct with public visibility
    struct GenericStruct<T: copy + drop> has store, key {
        data: T
    }

    // Test with generic struct for u8
    public fun test_generic_struct_with_u8(): (u8, u8) {
        let s = GenericStruct<u8> { data: 255u8 };
        (s.data, s.data)
    }

    // Test with generic struct for bool
    public fun test_generic_struct_with_bool(): (bool, bool) {
        let s = GenericStruct<bool> { data: true };
        (s.data, s.data)
    }

    // Function to test secondary message (labels) in diagnostics
    public fun test_secondary_labels() {
        // Generate an assertion failure with proper byte string literals
        assert!(1 == 2, 999, b"expected 1 to equal 2", b"this indicates a failure in comparison logic");
        // This line is expected not to run, but shows secondary label in diagnostics
        42
    }
}



//# run 0xCAFE::InteractionTest::test_variable_scoping_and_assignment


//# run 0xCAFE::InteractionTest::test_variable_in_while_loop


//# run 0xCAFE::InteractionTest::test_internal_function_accessibility --args 42u64


//# run 0xCAFE::InteractionTest::test_generic_struct_with_u8


//# run 0xCAFE::InteractionTest::test_generic_struct_with_bool


//# run 0xCAFE::InteractionTest::test_secondary_labels
