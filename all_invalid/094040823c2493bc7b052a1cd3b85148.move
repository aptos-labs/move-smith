
//# publish
module 0xCAFE::AdvancedFeaturesTest {
    use std::signer;
    use std::vector;

    // Entry point to run all the sub-tests
    public fun run_all_tests(s: signer) {
        test_variable_assignments();
        test_local_shadowing();
        test_internal_function_access();
        test_reference_handling();
        test_tuple_field_access();
    }

    // Test variable assignments inside and outside while loops
    public fun test_variable_assignments() {
        let outer_var = 0u64;
        // Outer variable assignment
        let outer_var_mut = outer_var; // To allow mutation

        // Loop with variable shadowing
        let i = 0u64;
        let i_mut = i;
        while (i_mut < 3) {
            // Shadow inner_var within loop
            let inner_var = i_mut * 10;
            // Verify inner_var in loop
            assert!((inner_var == i_mut * 10), 0);
            i_mut = i_mut + 1;
        };

        // Check that outer_var is unchanged
        assert!((outer_var == 0u64), 1);
        // Assign to outer_var after loop
        outer_var_mut = 100;
        // Confirm outer_var updated
        assert!((outer_var_mut == 100u64), 2);
    }

    // Test variable shadowing within loop's inner scope
    public fun test_local_shadowing() {
        let a = 5u8;
        let a_mut = a; // To test mutation if needed
        while (a_mut < 8) {
            // Shadow 'a' inside while
            let a = a_mut + 1;
            // Inner 'a' should be different
            assert!((a <= 8), 3);
            // increment outer 'a' if needed for complex test (not necessary here)
            a_mut = a_mut + 1;
        };
        // Confirm outer 'a' remains unchanged
        assert!((a == 5u8), 4);
    }

    // Test access to internal functions that should only be accessible within module
    public fun test_internal_function_access() {
        // Call internal function inside module - valid
        internal_helper();

        // Attempt to call private (internal) function from outside is invalid
        // The following line would cause a compile error if uncommented:
        // external_helper();
    }

    // Internal function only accessible within this module
    fun internal_helper() {
        // Perform some internal logic
        let _x = 42u64;
    }

    // Private helper not accessible outside: no 'public' modifier
    fun external_helper() {
        // Not accessible externally, used only inside this module
    }

    // Test reference handling: assign immutable and mutable references in if-else
    public fun test_reference_handling() {
        let value = 10u64;
        // Immutable reference in if
        let ref_x: &u64;
        if (value > 5) {
            ref_x = &value;
        } else {
            // Shadow variable in else to test compatibility
            let ref_x = &value;
        };
        // Confirm ref_x points to 'value'
        assert!(*ref_x == 10u64, 5);

        // Mutable reference scenario
        let value_mut = 15u64;
        let ref_mut_x: &mut u64;
        if (value_mut < 20) {
            ref_mut_x = &mut value_mut;
        } else {
            let ref_mut_x = &mut value_mut;
        };
        // Modify through reference
        *ref_mut_x = 25u64;
        assert!((value_mut == 25u64), 6);
    }

    // Test that references in branches are compatible and correctly inferred
    public fun test_ref_type_inference() {
        let x = 7u8;
        let ref1: &u8;
        let ref2: &u8;
        if (x == 7) {
            ref1 = &x;
        } else {
            let y = x + 1;
            ref2 = &y;
        };
        // No compile error should occur; references must be to compatible types
    }

    // Test accessing tuple fields by index
    public fun test_tuple_access() {
        let my_tuple = (b"A", 123u32, true);
        // Access the first element (index 0)
        let first = my_tuple.0;
        assert!(first == b"A", 7);
        // Access second element
        let second = my_tuple.1;
        assert!(second == 123u32, 8);
        // Access third element
        let third = my_tuple.2;
        assert!(third, 9);
    }
}


//# run 0xCAFE::AdvancedFeaturesTest::run_all_tests --signers 0xBEEF

// Featurres:
// b70ccb6e356eebb5b3735f5f76cd5273: Write script entry points in Move modules
// 0b62e2b6ef6d21801ee5807769ee6a3e: Test that local variable assignments inside and outside a while loop are handled correctly and that variable shadowing does not affect values across loop iterations.
// 63d45d364eac9afd0006b4525c93f85c: Use 'internal' visibility to restrict access within the module or package.
// d31fbb0a29b581e060d33b81a4c0a4ea: Test that the Move language correctly infers and handles references (immutable and mutable) in if-expressions, ensuring that the types of both branches are compatible and can be assigned to variables with reference types.
// edadf2c9fb9845b59892db51edd0f496: Access tuple fields by positional index using dot notation, such as `my_tuple.0`.
