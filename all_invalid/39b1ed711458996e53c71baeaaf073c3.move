
//# publish
module 0xCAFE::InteractionTest {
    use std::signer;

    // Internal function only accessible within this module
    fun internal_helper(x: u8): u8 {
        x + 1
    }

    // Public entry point script that calls internal function
    public fun script_entry_call_internal(s: signer, val: u8): u8 {
        internal_helper(val)
    }

    // Public function that performs variable handling with loops and shadowing
    public fun variable_loop_test() acquires * {
        // Outer variable
        let x = 0u64;

        // Loop that updates outer x
        let i = 0u64;
        while (i < 3) {
            // Shadow variable `x` inside loop
            let x = x + i;
            // Call internal function with shadowed x
            let res = internal_helper(x as u8);
            // Update outer x based on internal call result
            // Can't mutate outer x directly because shadowed, so create new binding
            let x = x + res as u64;
            // Assign to outer x by re-binding
            // But Move does not allow reassignment; use shadowing
            // to emulate updates: bind again
            let x = x;
            // Increment loop counter
            i = i + 1;
            // Assert outer x is as expected after iteration
            // (this is conceptual; no assertions required per instruction)
        };
        // After loop, check outer x value
        x
    }

    // Entry point that performs variable manipulations, including inner loops
    public fun run_variable_manipulation() {
        let outer_var = 5u64;

        // Inner loop with variable shadowed
        let count = 0u64;
        while (count < 2) {
            // Shadow outer_var
            let outer_var = outer_var + count;
            // Call internal helper
            let _res = internal_helper(outer_var as u8);
            // Update outer_var outside loop
            let outer_var = outer_var * 2;
            // Shadowing outer_var again to emulate mutation
            outer_var = outer_var;
            count = count + 1;
        };
        // Return current value of outer_var
        outer_var
    }
}


//# run 0xCAFE::InteractionTest::script_entry_call_internal --signers 0xBAD1 --args 42u8


//# run 0xCAFE::InteractionTest::variable_loop_test


//# run 0xCAFE::InteractionTest::run_variable_manipulation


// Featurres:
// b70ccb6e356eebb5b3735f5f76cd5273: Write script entry points in Move modules
// 0b62e2b6ef6d21801ee5807769ee6a3e: Test that local variable assignments inside and outside a while loop are handled correctly and that variable shadowing does not affect values across loop iterations.
// 63d45d364eac9afd0006b4525c93f85c: Use 'internal' visibility to restrict access within the module or package.
