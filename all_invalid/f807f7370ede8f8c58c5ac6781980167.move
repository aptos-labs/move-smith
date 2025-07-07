
//# publish
module 0xDEAD::VariableInteraction {
    use std::signer;

    // Public entry point that calls internal functions and manipulates variables
    public fun entry_vs_control_flow(s: &signer): u64 {
        let counter: u64 = 0;

        // Variable shadowing: shadow 'counter' inside the inner scope
        let counter = if (counter < 5) {
            // Loop to increment counter
            let i: u64 = 0;
            let inner_counter = counter; // shadowed variable
            while (i < 3) {
                inner_counter = inner_counter + 1;
                i = i + 1;
            };
            inner_counter
        } else {
            counter
        };

        // Final value of counter should reflect increments
        counter
    }

    // Function with local variable manipulation and shadowing
    public fun shadow_test(): u8 {
        let x: u8 = 10;
        let x_inner = if (x > 5) {
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



//# run 0xDEAD::VariableInteraction::entry_vs_control_flow --signers 0xBADD --args

//# run 0xDEAD::VariableInteraction::shadow_test --signers 0xBADD

//# run 0xDEAD::VariableInteraction::call_helper --signers 0xBADD --args 5u8
