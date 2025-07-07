//# publish
module 0xCAFE::TestModule {
    use std::signer;
    use std::debug;

    // Script entry point: create an account, deposit an object, and invoke internal functions
    public fun entry_point_script(s: signer) {
        // Call internal function
        internal_function_private(s);
        // Call public function
        public_function_public(s);
        // Call external function via module
        0xCAFE::DependentModule::external_function(s);
    }

    fun internal_function_private(s: signer) {
        let addr = signer::address_of(&s);
        debug::print(&b"Internal private function called"_b);
        // Create local variable and assign
        let _local_var = 42;
        // Shadowing: declare a new variable with same name inside block
        {
            let _local_var = 100;
            debug::print(&b"Shadowed variable inside block"_b);
        }
        // Verify that outside remains unchanged
        debug::print(&b"Finished internal function"_b);
    }

    public fun public_function_public(s: signer) {
        debug::print(&b"Public function invoked"_b);
    }

    // Function to test variable scope and shadowing inside a while loop
    public fun loop_variable_scope_test() {
        let counter = 0u64;
        // Outer variable 'counter' is initialized
        while (counter < 3) {
            // Shadowing variable inside loop body
            let counter = counter; // shadow
            let counter = counter; // make it mutable
            counter = counter + 1;
            debug::print(&b"Loop iteration"_b);
        }
        // Shadowed variable does not affect outer 'counter'
        // Declare a final variable if needed
        // (optional, for clarity)
        let _final_value = counter;
    }

    // Internal function with internal visibility
    fun internal_function_hidden() {
        debug::print(&b"This is a hidden internal function"_b);
    }

    // Public function calling internal function
    public fun call_internal_hidden() {
        internal_function_hidden();
    }

    // Module with explicit address and name to test reference resolution
    public fun resolve_address_reference() {
        let addr = 0xCAFE;
        // Reference to the module by explicit address
        0xCAFE::DependentModule::public_ref_function();
    }

    // Test function marking as package-only for restricted access
    // (simulate by making it not public)
    fun package_private_function() {
        debug::print(&b"Package private function"_b);
    }

    // Wrapper to invoke package-private function within the package
    public fun invoke_package_private() {
        package_private_function();
    }
}

// This dependent module might be in the same package but with internal functions

//# publish
module 0xCAFE::DependentModule {
    use std::debug;

    // Public function to be called externally
    public fun external_function(s: signer) {
        debug::print(&b"External function in DependentModule"_b);
    }

    // Public function to test reference resolution
    public fun public_ref_function() {
        debug::print(&b"Public ref function invoked"_b);
    }

    // Internal function that should not be directly accessible
    fun internal_function() {
        debug::print(&b"Internal function in DependentModule"_b);
    }
}
