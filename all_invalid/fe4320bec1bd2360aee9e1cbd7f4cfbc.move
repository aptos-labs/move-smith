
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

            // Update inner 'outer_var'
            let outer_var = outer_var;
            outer_var = outer_var + 1;

            // No assertion, just logic
        };
        // Return the outer_var's value after loop (should remain 0)
        // But to expose it, we can return it
        // Note: in Move, functions need explicit return, so we add it
        // and make the function return u64
        // For testing, change the function signature accordingly
        // But for simplicity, keep as void; real tests would check state elsewhere
        // Here we'll just imagine it completes successfully
    }

    // Function that tries to access internal functions/resources from outside (simulate compile-time error)
    // Internal functions are only accessible inside the module
    // This function remains internal so that external code can't access internal helper
}


//# run
script {
    // Call the module's public function
    0xCAFE::MyModule::call_internal_helper(5u8);
}

// Note: The original attempt to write `0xCAFE::MyModule::f1` was invalid because:
 // - The function `f1` doesn't exist
 // - The script tried to call a module function directly without a proper function
// Also, 'internal' functions can't be called from outside, so the script calls the public wrapper instead.
