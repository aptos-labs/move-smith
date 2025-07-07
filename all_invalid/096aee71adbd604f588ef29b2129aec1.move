
//# publish
module 0xCAFE::TestInteraction {
    // Entry point functions to invoke various tests
    public fun run_variable_assignment_tests() {
        // Call both inner and outer variable assignment functions
//# run
        script_variable_in_loop();
//# run
        script_variable_shadowing();
        // Call the internal function via a public wrapper
        invoke_internal_function();
    }

    // Function with variable assignment inside a while loop
    public fun script_variable_in_loop() {
        let outer_var: u64 = 0;
        let i: u64 = 0;
        while (i < 3) {
            // Assign variable inside loop
            outer_var = outer_var + i;
            // Shadow variable with same name inside nested scope
            let outer_var: u64 = outer_var + 10;
            // Update loop counter
            i = i + 1;
        };
        // After loop, outer_var should be sum of 0+0 + 1+10 + 2+10 = 0 + 1 + 2 + 20 = 23
        assert!(outer_var == 23, 999);
    }

    // Function to test variable shadowing across loop iterations
    public fun script_variable_shadowing() {
        let x: u64 = 5;
        let count: u64 = 0;
        while (count < 2) {
            // Shadow variable x
            let x: u64 = x + count;
            // Do some operation
            x = x * 2; // Shadowed x inside loop
            // Outer x should remain unchanged, verify shadowing does not affect outer variable
            count = count + 1;
        };
        // After loop, outer x should still be 5
        assert!(x == 5, 1000);
    }

    // Internal function that we will attempt to access externally
    fun internal_helper() {
        // Simple internal computation
        let _sum: u64 = 10 + 20;
    }

    // Public wrapper to invoke internal function
    public fun invoke_internal_function() {
        internal_helper();
    }

    // Entry point to test access to internal functions which should fail externally
    public fun attempt_access_internal() {
        // The following line is intentionally commented out because it should fail
        // External code should NOT be able to call internal_helper()
        // internal_helper(); // -- should be compile-time error if called from outside
        // But from within module, it's allowed
        internal_helper();
    }
}


//# run 0xCAFE::TestInteraction::run_variable_assignment_tests


// Featurres:
// b70ccb6e356eebb5b3735f5f76cd5273: Write script entry points in Move modules
// 0b62e2b6ef6d21801ee5807769ee6a3e: Test that local variable assignments inside and outside a while loop are handled correctly and that variable shadowing does not affect values across loop iterations.
// 63d45d364eac9afd0006b4525c93f85c: Use 'internal' visibility to restrict access within the module or package.
