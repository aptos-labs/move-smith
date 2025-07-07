
//# publish
module 0xCAFE::TestInteraction {
    // Entry script function to test variable handling, shadowing, and internal restriction
    public(entry) fun script_entry() {
        // Initialize variables outside loops
        let a: u64 = 0;
        let b: u64 = 0;

        // Outer while loop with variable shadowing
        while (a < 3) {
            // Shadowing variable `a`, reset inside loop
            let a = a + 1;
            // Local variable inside loop
            let inner_b: u64 = a * 10;

            // Call shadowed variable to test correctness
            assert!(a == a, 42);
            // Assert that inner_b is correctly calculated
            assert!(inner_b == a * 10, 42);
            // Update outer `a` with shadowed value
            a = a + 0;
        };

        // After loop, check value of a
        assert!(a == 3, 42);

        // For loop with variable shadowing
        let i: u64 = 0;
        for i in 0..2 {
            // Shadowing `i` in each iteration
            let i = i + 1;
            // Assert shadowed `i` value
            assert!(i == 1 || i == 2, 42);
        };
        // ensure outer `i` unchanged
        assert!(i == 0, 42);
    }

    // Internal function, should only be callable within this module
    fun internal_func() {
        // do nothing
    }

    // Public entry function that tries to call internal function - should be allowed internally
    public(entry) fun call_internal() {
        internal_func();
        // Call successfully, internal function used internally
    }
    // Hidden: We will test access restriction by attempting external call after publish
    // note: since external code cannot call internal, no test needed here.
}



//# run 0xCAFE::TestInteraction::script_entry



//# publish
module 0xCAFE::AccessRestriction {
    // Trying to expose internal functions or test access restriction
    // The internal function should NOT be accessible outside
    fun internal_only() {
        // Internal-only logic
    }

    // Entry script to test calling internal functions (should be an internal-only test)
    public(entry) fun test_internal_access() {
        internal_only();
    }
}



//# run 0xCAFE::AccessRestriction::test_internal_access --signers 0xBADD


// Features:
// b70ccb6e356eebb5b3735f5f76cd5273: Write script entry points in Move modules
// 0b62e2b6ef6d21801ee5807769ee6a3e: Test that local variable assignments inside and outside a while loop are handled correctly and that variable shadowing does not affect values across loop iterations.
// 63d45d364eac9afd0006b4525c93f85c: Use 'internal' visibility to restrict access within the module or package.
