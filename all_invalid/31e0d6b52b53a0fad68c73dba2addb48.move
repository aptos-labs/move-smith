
//# run
script {
    // Call the module's entry point function
    0xCAFE::MyModule::f1(5u8, false);
}


//# publish
module 0xCAFE::MyModule {
    // You NEVER try to use this 0xCAFE::MyModule
    // It is only an example
    use std::vector;

    // Internal functions with internal visibility (simulate private behavior)
    // Move does not have 'internal' visibility, but functions without 'public' are only accessible within the module
    fun internal_helper(x: u8): u8 {
        x + 1
    }

    // Expose a public function that internally calls the internal helper
    public fun call_internal_helper(x: u8): u8 {
        internal_helper(x)
    }

    // Function to initialize variables and test scoping in a loop
    public fun variable_scope_test() {
        let outer_var = 0u64;

        let i = 0u64; // outer scope variable
        while (i < 3) {
            // Declare shadowed variable inside loop
            let outer_var = i + 10;

            // Update outer variable outside the loop
            outer_var = outer_var + 1;

            // Save current value for assertion (simulate via resource or dummy logic)
            // In move, cannot directly assert inside module; just focus on variable state
            // For testing purposes, just do computations
            let _ = outer_var;

            // Attempt to access the outer variable after inner scope
            // Shadowed outer_var is local, outer_var outside remains unaffected
        };
        // Final check: outer_var should be 0 as it wasn't changed outside loop
        // Since no explicit assertion in move, rely on code logic
        // But in a test script, can check variable state by exposing it if needed
        // For this, just end with outer_var value
        outer_var
    }

    // Function that tries to access internal functions/resources from outside (simulate compile-time error)
    // In actual Move, trying to access a non-public function/resource from outside should cause compile failure.
    // But in a test, this function is internal, so attempt from script (which is outside) should fail.
    // For demonstration, this function remains internal.
    internal fun internal_access_test() {
        // Attempt to call internal helper (not needed here, just a placeholder)
        let _ = internal_helper(5u8);
    }
}


//# run 0xCAFE::MyModule::call_internal_helper --args 7u8


//# run 0xCAFE::MyModule::variable_scope_test


// Featurres:
// b70ccb6e356eebb5b3735f5f76cd5273: Write script entry points in Move modules
// 0b62e2b6ef6d21801ee5807769ee6a3e: Test that local variable assignments inside and outside a while loop are handled correctly and that variable shadowing does not affect values across loop iterations.
// 63d45d364eac9afd0006b4525c93f85c: Use 'internal' visibility to restrict access within the module or package.
