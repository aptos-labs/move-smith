
//# publish
module 0xCAFE::InteractionTest {

    use std::signer;

    // Public entry point script that calls internal functions
    public fun call_internal_functions() {
        internal_function_top_level();
        internal_constant_value();
    }

    // Script entry point that invokes loop and variable handling logic
    public fun test_variable_handling() {
        verify_loop_variable_tracking();
        verify_shadowing_behavior();
        verify_variable_persistence_after_loop();
    }

    // Internal constant, only accessible within this module
    const INTERNAL_CONST: u8 = 42;

    // Internal function only executable within this module
    fun internal_function_top_level() {
        // Do nothing, just a placeholder to test access restrictions
    }

    // Internal function that returns the value of the constant
    fun internal_constant_value(): u8 {
        INTERNAL_CONST
    }

    // Function that contains loops and variable assignments to verify variable tracking
    fun verify_loop_variable_tracking() {
        let sum: u64 = 0;
        let i: u64 = 0;

        while (i < 5) {
            // Shadowing i inside the loop
            let i = i + 1;
            sum = sum + i;
            // End of loop iteration
        };
        // After loop, check that sum is as expected: 1+2+3+4+5 = 15
        assert!(sum == 15, 999);
    }

    // Function to verify variable shadowing does not affect outer variables
    fun verify_shadowing_behavior() {
        let out_var: u8 = 10;

        let shadow_var: u8 = 0;
        for (j in 0..3) {
            let shadow_var = j; // Shadow inner
            // Inside loop, shadow_var is j
        };
        // Outside loop, shadow_var should remain unchanged
        assert!(out_var == 10, 999);
    }

    // Function to verify variables retain values after loops
    fun verify_variable_persistence_after_loop() {
        let x: u32 = 100;
        let y: u32 = x;

        for (k in 0..3) {
            y = y + 1;
        };

        // y should be x + 3
        assert!(y == 103, 999);
    }
}


//# run 0xCAFE::InteractionTest::call_internal_functions

//# run 0xCAFE::InteractionTest::test_variable_handling


// Featurres:
// b70ccb6e356eebb5b3735f5f76cd5273: Write script entry points in Move modules
// 0b62e2b6ef6d21801ee5807769ee6a3e: Test that local variable assignments inside and outside a while loop are handled correctly and that variable shadowing does not affect values across loop iterations.
// 63d45d364eac9afd0006b4525c93f85c: Use 'internal' visibility to restrict access within the module or package.
