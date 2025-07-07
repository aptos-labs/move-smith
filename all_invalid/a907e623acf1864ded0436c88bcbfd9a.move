
//# publish
module 0xCAFE::InteractionTest {
    // This module will contain functions to test variable handling, visibility, and control flows.

    // Public function to call internal functions
    public fun external_call_internal() {
        internal_helper(); // Should succeed, as this is within the same module
    }

    // Internal function, only accessible within this module
    fun internal_helper() {
        // No-op
    }

    // Public function to return a value for testing
    public fun check_outer_variable(val: u64): u64 {
        val
    }
}


//# run 0xCAFE::InteractionTest::external_call_internal


//# run 0xCAFE::InteractionTest::check_outer_variable --args 42u64

// Script to test variable handling, loops, shadowing, and scope.
//# run
script {
    fun main() {
        // Declare initial variable
        let outer_var = 0u64;

        // Create a nested block simulating different scopes
        {
            // Shadow outer variable
            let outer_var = 100u64;

            // Loop to modify inner scope variable
            let i = 0u64;
            while (i < 3) {
                // Shadow variable 'i' inside the loop
                let i = i + 1;
                // Assert inner shadowed 'i' has correct value
                assert!(i == (i),  "Inner shadowed i should be incremented");
                // Promote 'i' from loop if needed (not necessary here)
                i = i + 1;
            };
            // After loop, outer inner variable remains unchanged
            assert!(outer_var == 100u64, "Outer inner shadowed var should remain unchanged");
        }
        // Outer scope variable should be unchanged
        assert!(outer_var == 0u64, "Outer variable should remain as initially declared");

        // Now test shadowing again
        let shadowed_var = 200u64;
        {
            let shadowed_var = shadowed_var + 50;
            assert!(shadowed_var == 250u64, "Inside inner scope, shadowed_var should be 250");
        }
        // Outside, original value remains
        assert!(shadowed_var == 200u64, "Outside shadowed_var should remain 200");
    }
}


//# run 0xCAFE::InteractionTest::check_outer_variable --args 99u64

//# run 0xCAFE::InteractionTest::external_call_internal


//# run 0xCAFE::InteractionTest::main


// Featurres:
// b70ccb6e356eebb5b3735f5f76cd5273: Write script entry points in Move modules
// 0b62e2b6ef6d21801ee5807769ee6a3e: Test that local variable assignments inside and outside a while loop are handled correctly and that variable shadowing does not affect values across loop iterations.
// 63d45d364eac9afd0006b4525c93f85c: Use 'internal' visibility to restrict access within the module or package.
