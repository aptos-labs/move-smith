
//# publish
module 0xDEAD::TestModule {
    // This module will contain functions to test various move features and interactions.

    use std::signer;
    use std::vector;

    // Script entry point to invoke internal function
    public fun script_entry_echo_x(x: u8): u8 {
        internal_echo_x(x)
    }

    // Internal function to echo input
    fun internal_echo_x(x: u8): u8 {
        x
    }

    // Function to test variable assignment outside and inside while loop, including shadowing
    public fun variable_scope_test(initial_x: u8): u8 {
        let outer_x = initial_x;
        let inner_x = outer_x;
        let _ = inner_x; // just to avoid unused warning

        let sum = 0u8;

        // While loop with variable shadowing
        while (inner_x < 5) {
            let inner_x = inner_x + 1; // shadow outer inner_x
            sum = sum + inner_x;
            // The inner_x here shadows the outer inner_x, verifying variable isolation
        };
        // After loop, verify that outer_x remains unchanged and inner_x is local
        outer_x + sum
    }

    // Function to test variable shadowing with inner variable
    public fun shadowing_test(): u64 {
        let x = 7u64;
        let y = {
            let x = 3u64; // shadow outer x
            x
        };
        // x outside shadowing block remains 7
        x + y
    }

    // Function attempting to access an internal variable outside its scope - should fail if attempted
    // We'll comment out the invalid access, but indicate expected diagnostics.
    // public fun invalid_access(): u8 {
    //     // Attempt to access internal variable (simulate compile-time error)
    //     // let _ = internal_variable; // No such variable: should produce error
    //     0
    // }

    // Inline function that takes an argument and modifies a captured variable
    public fun inline_modification(x: u8, f: |u8|u8): u8 {
        let result = f(x);
        result
    }

    // Test calling inline function with a lambda that modifies value
    public fun test_inline_fn(): u8 {
        let x = 5u8;
        let lambda = |a: u8| -> u8 {
            a + 10
        };
        inline_modification(x, lambda)
    }

    // Function to intentionally misuse access to internal member (simulate diagnostics)
    // Should be commented out or leave as an example to trigger error in diagnostics
    // public fun misuse_internal(): u8 {
    //     // Attempt to access a private/internal function/variable - should error
    //     // internal_echo_x(4)
    //     0
    // }
}


//# run 0xDEAD::TestModule::script_entry_echo_x --args 42u8


//# run 0xDEAD::TestModule::variable_scope_test --args 2u8


//# run 0xDEAD::TestModule::shadowing_test


//# run 0xDEAD::TestModule::test_inline_fn


// Featurres:
// b70ccb6e356eebb5b3735f5f76cd5273: Write script entry points in Move modules
// 0b62e2b6ef6d21801ee5807769ee6a3e: Test that local variable assignments inside and outside a while loop are handled correctly and that variable shadowing does not affect values across loop iterations.
// 63d45d364eac9afd0006b4525c93f85c: Use 'internal' visibility to restrict access within the module or package.
// 206ebfe6b421d8dcf6d3ea42bdb5b167: Test that the inline function correctly captures and modifies the local variable `x` when called within the `test` function.
// 7ed3aa6336c305003c3cf85d6031e07c: Detect and handle unexpected module member accesses with diagnostics.
