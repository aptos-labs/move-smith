
//# publish
module 0xDEAD::ValidationTest {
    // Use std for vector and other utility functions
    use std::vector;

    // A simple struct for internal testing
    struct TestStruct has store, key {
        value: u64,
    }

    // Internal function demonstrating private behavior
    fun internal_increment(val: u64): u64 {
        val + 1
    }

    // Public entry function to invoke internal function
    public fun call_internal_increment(x: u64): u64 {
        internal_increment(x)
    }

    // Entry point that calls internal function and returns result
    public fun script_entry_point(x: u64): u64 {
        call_internal_increment(x)
    }

    // --------------------------------------------
    // Variable behavior test with outer and inner scope
    // --------------------------------------------

    // Function to test variable shadowing inside loop
    public fun variable_shadowing_test(initial: u64): u64 {
        let outer_var = initial;
        let i = 0;

        // Loop with variable shadowing
        loop {
            if (i >= 3) {
                break;
            }
            // Shadowing inner variable
            let shadow_var = outer_var + i;
            // Mutate outer_var based on shadow_var
            outer_var = shadow_var * 2;
            i = i + 1;
        };
        // After loop, outer_var should reflect last iteration
        outer_var
    }

    // Function to test variable assignment and mutation
    public fun variable_assignment_test(): u64 {
        let a = 10;
        let b = 20;
        // Reassign a
        a = b;
        a
    }

    // --------------------------------------------
    // Visibility enforcement: only internal can call internal functions
    // --------------------------------------------

    // Internal function for internal calls
    fun secret_internal_function(x: u64): u64 {
        x + 42
    }

    // Public function that can call internal
    public fun allowed_public_call(x: u64): u64 {
        secret_internal_function(x)
    }

    // Attempt to call internal from outside (should be invalid)
    // This function is commented out to enforce that external modules can't call internal functions
    // public fun invalid_external_call(x: u64): u64 {
    //     secret_internal_function(x)
    // }

    // --------------------------------------------
    // Test functions for organized testing
    // --------------------------------------------

    // Function to run variable shadowing test
    public fun run_variable_shadowing_test(): u64 {
        variable_shadowing_test(5)
    }

    // Function to run variable assignment test
    public fun run_variable_assignment_test(): u64 {
        variable_assignment_test()
    }
}


//# run 0xDEAD::ValidationTest::script_entry_point --args 123u64


//# run 0xDEAD::ValidationTest::run_variable_shadowing_test


//# run 0xDEAD::ValidationTest::run_variable_assignment_test


//# run 0xDEAD::ValidationTest::allowed_public_call --args 100u64


// Featurres:
// b70ccb6e356eebb5b3735f5f76cd5273: Write script entry points in Move modules
// 0b62e2b6ef6d21801ee5807769ee6a3e: Test that local variable assignments inside and outside a while loop are handled correctly and that variable shadowing does not affect values across loop iterations.
// 63d45d364eac9afd0006b4525c93f85c: Use 'internal' visibility to restrict access within the module or package.
// 324fb212eadc0a8bba9ecc14a09b64a1: Collect and organize test functions into a test plan for the module.
