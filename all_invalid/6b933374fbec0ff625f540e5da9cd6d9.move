
//# publish
module 0xCAFE::InteractionTest {
    // Entry point functions calling internal functions, manipulating variables, testing scope and visibility

    use std::signer;

    // Internal function: only accessible within this module
    fun internal_helper(x: u8): u8 {
        x + 10
    }

    // Internal function: only accessible within this module
    fun internal_shadow(x: u8): u8 {
        x * 2
    }

    // Internal functions with restricted visibility, only within this module
    fun internal_private_fn(): u8 {
        42
    }

    // Entry functions (not scripts) that call internal functions and manipulate variables
    // Note: Move modules do not support script definitions directly inside the module.
    // Instead, use public functions that can be invoked via scripts.
    public fun entry_point_one() {
        // This is just a test function, not a script; scripts are separate Move files or inline in tests
        let outer_var = 5u8;
        let result = internal_helper(outer_var);
        // Shadow variable inside block
        let outer_var = result;
        assert!(outer_var == 15, 1);
        // Call internal shadow
        let shadowed = internal_shadow(outer_var);
        assert!(shadowed == 30, 2);
        // Update outer_var for further checks
        let outer_var = shadowed;
        assert!(outer_var == 30, 3);
    }

    public fun variable_shadowing() {
        let val = 0u8;
        // Loop with shadowing
        let v = val;
        while (v < 3) {
            let shadow_val = v * 2;
            assert!(shadow_val == v * 2, 4);
            v = v + 1;
        };

        // Nested loops with same variable name
        let outer = 0u8;
        while (outer < 2) {
            let inner = 0u8;
            while (inner < 2) {
                let inner_shadow = inner + outer;
                assert!(inner_shadow <= 3, 5);
                inner = inner + 1;
            };
            outer = outer + 1;
        };

        // Check variable at end
        assert!(v == 3, 6);
        assert!(outer == 2, 7);
    }

    // Entry function to test internal function accessibility from within module
    public fun call_internal_function() {
        let val = internal_private_fn();
        assert!(val == 42, 8);
    }
}


//# run 0xCAFE::InteractionTest::entry_point_one --signers 0xBADD

//# run 0xCAFE::InteractionTest::variable_shadowing --signers 0xBADD

//# run 0xCAFE::InteractionTest::call_internal_function --signers 0xBADD

// Note: Scripts are typically separate in Move; if needed, define scripts in separate files or inline tests.
// The above functions are meant for testing within the Move framework via scripts that call these functions.

// The errors indicate that the original code attempted to define scripts inside the module, which is invalid.
// Instead, define scripts externally that call these functions.
// For example:

// Example script calling entry_point_one
/*
//# run
script {
    fun main(s: &signer) {
        0xCAFE::InteractionTest::entry_point_one();
        0xCAFE::InteractionTest::variable_shadowing();
        0xCAFE::InteractionTest::call_internal_function();
    }
}
*/
