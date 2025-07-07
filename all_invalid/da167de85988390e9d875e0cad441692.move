
//# publish
module 0xCAFE::InteractionTest {
    // Entry point scripts calling internal functions, manipulating variables, testing scope and visibility

    use std::signer;

    // Internal function: only accessible within this module
    fun internal_helper(x: u8): u8 {
        x + 10
    }

    // Internal function: only accessible within this module
    fun internal_shadow(x: u8): u8 {
        x * 2
    }

    // Entry script that calls internal functions and manipulates variables
    public script entry_point_one(s: signer) {
        // Local variable declaration
        let outer_var = 5u8;
        // Call internal helper
        let result = internal_helper(outer_var);
        // Shadow variable inside block
        let outer_var = result;
        assert!(outer_var == 15, 0);
        // Call internal shadow
        let shadowed = internal_shadow(outer_var);
        assert!(shadowed == 30, 0);
        // Update outer_var for further checks
        outer_var = shadowed;
        assert!(outer_var == 30, 0);
    }

    // Entry script that tests variable shadowing across multiple loops
    public script variable_shadowing(s: signer) {
        let val = 0u8;
        // Loop with shadowing
        while (val < 3) {
            let shadow_val = val * 2;
            assert!(shadow_val == val * 2, 0);
            val = val + 1;
        };

        // Nested loops with same variable name
        let outer = 0u8;
        while (outer < 2) {
            let inner = 0u8;
            while (inner < 2) {
                let inner_shadow = inner + outer;
                assert!(inner_shadow <= 3, 0);
                inner = inner + 1;
            };
            outer = outer + 1;
        };

        // Check variable at end
        assert!(val == 3, 0);
        assert!(outer == 2, 0);
    }

    // Internal functions with restricted visibility, only within module
    fun internal_private_fn(): u8 {
        42
    }

    // Entry script to test internal function accessibility from within module
    public script call_internal_function(s: signer) {
        let val = internal_private_fn();
        assert!(val == 42, 0);
    }

    // Attempt to call internal function from outside (should be compiler error if uncommented)
    // public script external_call() {
    //     let val = internal_private_fn(); // Should be invalid outside module
    // }

    // Entry point that invokes all previous scripts for combined testing
    public script run_all_tests(s: signer) {
        entry_point_one(s);
        variable_shadowing(s);
        call_internal_function(s);
    }
}


//# run 0xCAFE::InteractionTest::run_all_tests --signers 0xBADD


// Featurres:
// b70ccb6e356eebb5b3735f5f76cd5273: Write script entry points in Move modules
// 0b62e2b6ef6d21801ee5807769ee6a3e: Test that local variable assignments inside and outside a while loop are handled correctly and that variable shadowing does not affect values across loop iterations.
// 63d45d364eac9afd0006b4525c93f85c: Use 'internal' visibility to restrict access within the module or package.
