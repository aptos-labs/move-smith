
//# publish
module 0xCAFE::InteractionTest {
    use std::signer;
    use std::vector;

    // Internal-only struct and function to test access restrictions
    struct InternalStruct has copy, drop, store {
        value: u8
    }

    // Internal function, should not be accessible outside the module
    fun internal_helper(x: u8): u8 {
        x + 1
    }

    // Expose only public functions
    public fun call_internal_helper(x: u8): u8 {
        internal_helper(x)
    }

    // Public function to create InternalStruct for testing internal access
    public fun create_internal_struct(val: u8): InternalStruct {
        InternalStruct { value: val }
    }
}


//# publish
module 0xDEAD::FeatureInteraction {
    use 0xCAFE::InteractionTest;

    // Script entry point to test variable scope and control flow
public script {
    fun main() {
        let outside_var = 0u64;
        let x = 5u64;

        // Local variable inside while loop scope
        let shadow_x = x;

        while (shadow_x > 0) {
            // Shadowing outside_var inside loop
            let outside_var = shadow_x + 10;
            shadow_x = shadow_x - 1;
        };

        // After loop, verify values
        // The 'outside_var' outside should remain unchanged
        // The 'shadow_x' updated, but 'outside_var' inside loop shadowing does not affect outer
        // We will assert to verify the behavior
        assert!(outside_var == 0, 0);
        // Use module function to get a value to demonstrate access restriction
        let val = InteractionTest::call_internal_helper(2);
        assert!(val == 3, 0);
    }
}


//# run 0xDEAD::FeatureInteraction::main


//# publish
module 0xBEEF::TestMutations {
    use std::signer;

    // Struct to test field mutation
    struct MutStruct has store, key {
        a: u8,
        b: u8,
    }

    public fun create_struct(a: u8, b: u8): MutStruct {
        MutStruct {a, b}
    }

    // Function that mutates fields of a struct passed as reference
    public fun mutate_struct(s: &mut MutStruct, new_a: u8, new_b: u8) {
        s.a = new_a;
        s.b = new_b;
    }

    // Function testing assign and mutate expressions
    public fun assign_and_update(s: &mut MutStruct) {
        // Assign new value to field
        s.a = s.a + 1;

        // Mutate field using mutation expression
        mutate_struct(s, s.a + 2, s.b + 2);
    }
}


//# run 0xBEEF::TestMutations::create_struct --args 3u8 4u8 --signers 0xBEEF


//# run 0xBEEF::TestMutations::mutate_struct --signers 0xBEEF --args 5u8 6u8


//# run 0xBEEF::TestMutations::assign_and_update --signers 0xBEEF


//# publish
module 0xFEED::UseImport {
    // Import specific functions for testing import
    use 0xDEAD::FeatureInteraction::{main as feature_main};

    // Function to test module import and usage
    public fun test_import(): u8 {
        feature_main();
        42
    }
}


//# run 0xFEED::UseImport::test_import


// Featurres:
// b70ccb6e356eebb5b3735f5f76cd5273: Write script entry points in Move modules
// 0b62e2b6ef6d21801ee5807769ee6a3e: Test that local variable assignments inside and outside a while loop are handled correctly and that variable shadowing does not affect values across loop iterations.
// 63d45d364eac9afd0006b4525c93f85c: Use 'internal' visibility to restrict access within the module or package.
// 8fe5fef24c0e585a801639f4602b3ed1: Test that the Move script correctly assigns a value to a variable within an if-else conditional and returns the assigned value.
// 17e32096043b947e097ce2fa11e19fc5: Perform assignments to local variables, struct fields, or perform mutate operations with the `assign` and `mutate` expressions.
// 4ca8ffd29af511d66e3a78ca3cca731a: Declare use statements to import modules or their members in Move code
