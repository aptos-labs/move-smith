
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

        let sum = 0;
        let i = 0;

        // Initialize loop variable
        while(i < 5) {
            // Shadow loop variable
            let i = i + 1; // shadowing previous i
            sum = sum + i;
        };

        // After loop, check variable values
        assert!(i == 0, 1003); // 'i' outside loop remains, only loop variable shadowed
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
        // Create an alias (not needed in code, just for illustration)
        // Here, we just call the function directly via module name
        // But in actual tests, we might pass the module reference
        // For testing purposes, refer directly to module
        let alias_ref = &FeatureTestModule;
        alias_ref.internal_private_function();
    }
}

// Since the above alias part is conceptual, the main test is calling internal functions, scope tests, and internal access ones.

// The scripts above will exercise variable shadowing, loops, internal function restrictions,
// and module alias referencing within the same code structure, verifying correct compiler and VM behavior.


// Featurres:
// b70ccb6e356eebb5b3735f5f76cd5273: Write script entry points in Move modules
// 0b62e2b6ef6d21801ee5807769ee6a3e: Test that local variable assignments inside and outside a while loop are handled correctly and that variable shadowing does not affect values across loop iterations.
// 63d45d364eac9afd0006b4525c93f85c: Use 'internal' visibility to restrict access within the module or package.
// c8775b9b876dc9b2054875c570b8b1b8: Use module aliases to refer to modules by their aliases.
// fa1f0755c83c8b79f78255984c60ae82: Specify module names and ensure they do not start with an underscore.
