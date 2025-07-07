
//# publish
module 0xDEAD::VariableInteraction {
    use std::signer;

    // Public entry point that calls internal functions and manipulates variables
    public fun entry_vs_control_flow(s: signer): u64 {
        let counter: u64 = 0;

        // Variable shadowing: shadow 'counter' inside the inner scope
        let counter = if (counter < 5) {
            // Loop to increment counter
            let i: u64 = 0;
            while (i < 3) {
                counter = counter + 1;
                i = i + 1;
            };
            counter
        } else {
            counter
        };

        // Final value of counter should reflect increments
        counter
    }

    // Function with local variable manipulation and shadowing
    public fun shadow_test(): u8 {
        let x: u8 = 10;
        let x = if (x > 5) {
            let x = 42; // shadow inner variable
            x
        } else {
            x
        };
        // Outer x remains unchanged; inner x is 42
        x
    }

    // Internal function to test access restrictions
    fun internal_helper(a: u8): u8 {
        a + 1
    }

    // Public function that tries to call internal (should work)
    public fun call_helper(a: u8): u8 {
        internal_helper(a)
    }
}


//# run 0xDEAD::VariableInteraction::entry_vs_control_flow --args  --signers 0xBADD

//# run 0xDEAD::VariableInteraction::shadow_test

//# run 0xDEAD::VariableInteraction::call_helper --args 5u8 --signers 0xBADD


// Featurres:
// b70ccb6e356eebb5b3735f5f76cd5273: Write script entry points in Move modules
// 0b62e2b6ef6d21801ee5807769ee6a3e: Test that local variable assignments inside and outside a while loop are handled correctly and that variable shadowing does not affect values across loop iterations.
// 63d45d364eac9afd0006b4525c93f85c: Use 'internal' visibility to restrict access within the module or package.
