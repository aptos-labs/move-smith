
//# publish
module 0xDEAD::InteractionTest {
    use std::signer;

    // Internal function not meant to be called outside
    fun internal_increment(value: u64): u64 {
        value + 1
    }

    // Public entry point that calls internal function
    public fun execute_internal_increment(value: u64): u64 {
        internal_increment(value)
    }

    // Private function (not marked as public)
    fun internal_private_function(): u8 {
        42
    }

    // Public entry point that calls the private function internally
    public fun call_private(): u8 {
        internal_private_function()
    }

    // Variable declaration outside the loop
    public fun variable_outside_loop(initial: u64): (u64, u64) {
        let outer_var = initial;
        let shadow_var = 0u64;

        // Loop that updates outer_var
        while (outer_var < 5) {
            outer_var = outer_var + 1;

            // Shadowing variable inside loop
            let shadow_var = outer_var * 10;
        };
        (outer_var, shadow_var)
    }

    // Variable declaration with shadowing
    public fun variable_shadowing(initial: u64): u64 {
        let x = initial;

        // Shadowing variable inside while
        while (x < 3) {
            let x = x + 1;
            x
        };
        x
    }
}


//# run 0xDEAD::InteractionTest::execute_internal_increment --args 10u64


//# run 0xDEAD::InteractionTest::call_private


//# run 0xDEAD::InteractionTest::variable_outside_loop --args 0u64


//# run 0xDEAD::InteractionTest::variable_shadowing --args 1u64


// Featurres:
// b70ccb6e356eebb5b3735f5f76cd5273: Write script entry points in Move modules
// 0b62e2b6ef6d21801ee5807769ee6a3e: Test that local variable assignments inside and outside a while loop are handled correctly and that variable shadowing does not affect values across loop iterations.
// 63d45d364eac9afd0006b4525c93f85c: Use 'internal' visibility to restrict access within the module or package.
