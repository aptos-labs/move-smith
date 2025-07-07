//# publish
module 0xCAFE::FeatureTestModule {
    use std::vector;

    // Helper functions for testing scope, shadowing, and internal access
    public fun internal_helper() {
        // Just a dummy internal function
    }

    // Internal function, should NOT be accessible outside
    fun internal_private_function() {
        // Internal logic
    }

    // Script entry point that tests local vars, loops, shadowing, and variable persistence
    public fun test_variable_scope_and_loops() {
        // Outer variable declaration
        let outer_var = 10;

        // Shadowing variable inside a block
        let outer_var = 20;
        // Shadowed variable, inner scope
        let inner_var = outer_var + 5; // inner_var = 25

        // Verify inner shadowed value
        assert!(inner_var == 25, 1001);
        // Verify outer shadowed variable still
        assert!(outer_var == 20, 1002);

        let sum = 0; // Make sum mutable
        let i = 0;   // Loop counter

        // Initialize loop
        while(i < 5) {
            // Shadow loop variable
            let i = i + 1; // shadowing previous i
            sum = sum + i;
        }

        // After loop, check variable values
        assert!(i == 0, 1003); // 'i' outside loop remains unchanged
        // sum should be 1+2+3+4+5 = 15
        assert!(sum == 15, 1004);

        // Variables from outer scope should remain unchanged
        assert!(outer_var == 20, 1005);
    }

    // Function with internal visibility, test access within module
    public fun call_internal_from_public() {
        internal_private_function(); // allowed within module
    }

    // Test function calling internal function internally
    fun internal_call_test() {
        internal_private_function(); // allowed, internal
    }

    // Function invoking an alias of this module
    public fun call_via_alias(alias: &Self) {
        alias.internal_private_function();
    }
}



//# run 0xCAFE::FeatureTestModule::test_variable_scope_and_loops



//# run 0xCAFE::FeatureTestModule::call_internal_from_public



//# run 0xCAFE::FeatureTestModule::call_via_alias --args 0xCAFE::FeatureTestModule

// Alias for the module, to test alias resolution
// This alias will be used to call functions as well
// Note: Moving alias creation into a script

//# publish
module 0xCAFE::AliasModule {
    use 0xCAFE::FeatureTestModule;

    public fun use_alias() {
        // Call internal function via module reference
        // Directly use module name; Move code can't pass module references directly as args
        FeatureTestModule::internal_private_function();
    }
}
