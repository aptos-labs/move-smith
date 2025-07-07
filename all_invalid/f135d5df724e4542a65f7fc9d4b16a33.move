
//# publish
module 0xDEAD::InteractionTest {
    use std::signer;

    // This public script function calls an internal module function via a public entry point.
    public fun script_entry_point_caller(s: signer) {
        // Call the module's public function which internally calls an internal function
        Self::call_internal_function_from_script(s)
    }

    // Public function that calls an internal function
    public fun call_internal_function_from_script(s: signer) {
        Self::internal_function(s)
    }

    // Internal function to simulate module-internal logic
    fun internal_function(s: signer) {
        // Internal logic, e.g., move some value to storage or perform check
        // (no storage for simplicity)
        let _ = signer::address_of(&s);
    }
}


//# run 0xDEAD::InteractionTest::script_entry_point_caller --signers 0xBADD



//# publish
module 0xDEAD::VariableScopeTest {
    use std::signer;

    // Entry point script to test variable shadowing and scope handling
    public fun run_variable_shadowing(s: signer) {
        // Declare variable outside loop
        let outer_var: u8 = 0;

        // Assign initial value
        outer_var = 10;
        // Loop with variable shadowing
        let i: u8 = 0;
        while (i < 3) {
            // Shadow outer variable
            let outer_var = outer_var + 1; // Should shadow previous declaration
            // Reassign to test shadowing
            let outer_var = outer_var + 2; // Shadow again
            // The outer_var inside loop now is this shadowed one
            // No leak to outer scope, check the shadowed value
            // The inner outer_var should be outer_var + 2 from previous line
        };
        // After loop, verify the outer_var remains unchanged by shadowing
        // Expect outer_var == 10 (unchanged)
        assert!(outer_var == 10, 999);
    }

    // Entry point to run variable shadowing test
    public fun run_shadowing_tests(s: signer) {
        Self::run_variable_shadowing(s);
    }
}


//# run 0xDEAD::VariableScopeTest::run_shadowing_tests --signers 0xC0FF



//# publish
module 0xDEAD::VisibilityTest {
    use std::signer;

    // This function calls an internal-only function. 
    // External callers should be unable to call the internal function directly.
    public fun caller_script(s: signer) {
        Self::internal_only_function(s);
    }

    // Internal function, inaccessible from outside the module
    fun internal_only_function(s: signer) {
        // Internal logic, e.g., just dummy
        let _ = signer::address_of(&s);
    }
}


//# run 0xDEAD::VisibilityTest::caller_script --signers 0xBADF

// Attempting to call internal_only_function from outside the module should result in a compile-time error
// Uncommenting below line should produce an error if tested in strict environment
// 
//# run 0xDEAD::VisibilityTest::internal_only_function --signers 0xBADF


// Featurres:
// b70ccb6e356eebb5b3735f5f76cd5273: Write script entry points in Move modules
// 0b62e2b6ef6d21801ee5807769ee6a3e: Test that local variable assignments inside and outside a while loop are handled correctly and that variable shadowing does not affect values across loop iterations.
// 63d45d364eac9afd0006b4525c93f85c: Use 'internal' visibility to restrict access within the module or package.
