
//# publish
module 0xC0DE::InteractionTest {
    use std::assert;
    use std::signer;

    // Internal struct to test visibility and internal function call
    struct InternalData has copy, drop, store {
        value: u64,
    }

    // Public entry point that calls an internal private function
    public entry fun invoke_internal(s: signer) {
        internal_function(signer::address_of(&s))
    }

    // Internal function, only callable within the module
    fun internal_function(addr: address) {
        // Instantiate internal data
        let _data = InternalData { value: 42 };
        // For testing, just assert value correctness
        assert!(_data.value == 42, 1000);
    }

    // Entry point to test variable scoping, shadowing, and loops
    public entry fun variable_scope_test(s: signer) {
        let outer_var: u64 = 100;
        let iteration_count: u64 = 0;

        // Loop to test variable assignment and shadowing
        while (iteration_count < 3) {
            // Shadow outer_var inside loop
            let outer_var = outer_var + iteration_count;
            // Declare inner variable that shadows outer_var
            let outer_var_shadowed = outer_var * 2;

            // Assert they have correct values
            assert!(outer_var_shadowed == (outer_var) * 2, 2000);
            assert!(outer_var == 100 + iteration_count, 2001);
            // Confirm outer_var is shadowed and does not affect outer
            assert!(outer_var != outer_var_shadowed, 2002);

            // Update outer_var outside loop to ensure no interference
            let _ = outer_var;
            iteration_count = iteration_count + 1;
        }

        // Confirm outer_var outside loop unchanged
        assert!(outer_var == 100, 2003);
    }

    // Entry point to test variable assignments post-loop
    public entry fun post_loop_vars(s: signer) {
        let x: u8 = 0;

        // Loop to modify x
        while (x < 3) {
            let x_shadow = x + 1;
            // Shadow x with x_shadow
            let _ = x_shadow;
            // Confirm shadowing does not alter outer x
            assert! (x == 0 || x == 1 || x == 2, 3000);
            x = x + 1;
        }

        // Confirm outer x after loop
        assert!(x == 3, 3001);
    }
}


//# run 0xBADD::InteractionTest::invoke_internal --signers 0xBADD


//# run 0xBADD::InteractionTest::variable_scope_test --signers 0xBADD


//# run 0xBADD::InteractionTest::post_loop_vars --signers 0xBADD


// Featurres:
// b70ccb6e356eebb5b3735f5f76cd5273: Write script entry points in Move modules
// 0b62e2b6ef6d21801ee5807769ee6a3e: Test that local variable assignments inside and outside a while loop are handled correctly and that variable shadowing does not affect values across loop iterations.
// 63d45d364eac9afd0006b4525c93f85c: Use 'internal' visibility to restrict access within the module or package.
