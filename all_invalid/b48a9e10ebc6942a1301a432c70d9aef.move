
//# publish
module 0xCAFE::InternalTest {
    // Use the standard signer for testing purposes
    use std::signer;

    // Internal function: accessible only within this module
    fun internal_calc(x: u8): u8 {
        x + 10
    }

    // Entry point that calls internal function
    public fun call_internal_calc(s: signer, val: u8): u8 {
        internal_calc(val)
    }

    // Function with nested loops and variable shadowing
    public fun nested_loops_demo(): u8 {
        let outer_var = 0u8;
        let result = 0u8;

        let _ = loop {
            let outer_var = 1u8; // shadowing outer_var inside loop
            let inner_counter = 0u8;

            let _ = while(inner_counter < 3) {
                // shadow inner_counter
                let inner_counter = inner_counter + 1;
                result = result + outer_var + inner_counter;
                inner_counter
            };

            // update outer variable outside nested loop
            outer_var + 1
        };
        result
    }

    // Function that declares local variables outside and inside while loop
    public fun variable_scope_test(): (u8, u8) {
        let outside_var = 5u8;
        let inside_var = 0u8;

        // Outer scope variable
        let _ = while (outside_var < 7) {
            // Shadowing outside_var
            let outside_var = outside_var + 1;

            // Loop variable shadowing
            let inside_var = 10u8;
            let _ = loop {
                if (inside_var > 12) {
                    break;
                };
                inside_var = inside_var + 1;
            };
            outside_var
        };
        // Values after loop
        (outside_var, inside_var)
    }

    // Function that tests internal function accessibility within nested functions
    public fun call_internal_from_nested(s: signer, val: u8): u8 {
        internal_calc(val)
    }
}


//# run 0xCAFE::InternalTest::call_internal_calc --signers 0x0 --args 7u8

//# run 0xCAFE::InternalTest::nested_loops_demo

//# run 0xCAFE::InternalTest::variable_scope_test

//# run 0xCAFE::InternalTest::call_internal_from_nested --signers 0x0 --args 15u8


// Featurres:
// b70ccb6e356eebb5b3735f5f76cd5273: Write script entry points in Move modules
// 0b62e2b6ef6d21801ee5807769ee6a3e: Test that local variable assignments inside and outside a while loop are handled correctly and that variable shadowing does not affect values across loop iterations.
// 63d45d364eac9afd0006b4525c93f85c: Use 'internal' visibility to restrict access within the module or package.
