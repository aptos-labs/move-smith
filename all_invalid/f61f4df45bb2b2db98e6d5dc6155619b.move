
//# publish
module 0xCAFE::TestModule {
    use std::vector;
    use std::signer;
    use 0xCAFE::StorageUsage; // Import dependencies for test

    // Helper struct for nested field access test
    struct OuterStruct has copy, drop, store {
        inner: InnerStruct,
        value: u8,
    }

    struct InnerStruct has copy, drop, store {
        nested_most: u16,
        another_field: bool,
    }

    // Module to test version-based feature (simulate feature gating)

//# publish
    module 0xCAFE::VersionedFeatures {
        // Assume a version constant that controls features
        const VERSION: u64 = 2; // testing below/above threshold

        public fun is_feature_enabled() : bool {
            // Feature available at version >= 2
            VERSION >= 2
        }

        // Function that returns function typed only if version >= 2.2
        // Correctly use template syntax for function return type
        public fun get_function_type() : option<(u64) -> u64> {
            if (VERSION >= 22) {
                // Only compile if version high enough
                Some(|x: u64| x + 1)
            } else {
                None
            }
        }
    }

    //! Load and reuse imported modules
    public fun test_nested_field_access() {
        let inner = InnerStruct { nested_most: 42, another_field: true };
        let outer = OuterStruct { inner, value: 7 };

        // Access nested fields using dot notation
        let nested_value = outer.inner.nested_most;
        assert!(nested_value == 42, 1001);
        let other_field = outer.inner.another_field;
        assert!(other_field, 1002);
        // Access top-level field
        let val = outer.value;
        assert!(val == 7, 1003);
    }

    public fun test_function_return_type() {
        let version_module = 0xCAFE::VersionedFeatures;

        let is_enabled = version_module::is_feature_enabled();

        if (is_enabled) {
            // Version >= 2, function returning function pointer should be available
            let opt_fun = version_module::get_function_type();
            if (option::is_some(&opt_fun)) {
                let fun_ref = option::extract(&mut opt_fun);
                let result = fun_ref(10);
                assert!(result == 11, 1004);
            } else {
                // Should not happen if feature is enabled
                abort 9999;
            }
        } else {
            // Version < 2.2, no function pointer returned
            let opt_fun = version_module::get_function_type();
            assert!(option::is_none(&opt_fun), 1005);
        }
    }

    public fun test_imports_and_scope() {
        // Use imported module and functions
        let _val = StorageUsage::store_at_signer_address;
        let _value = StorageUsage::inspect_value;
        // Just check if functions are accessible
        // No call needed
        ()
    }

    public fun test_spec_block_asserts_and_effects(s: signer) {
        // Using assertions, ensures, aborts
        // Spec block with assertions
        spec {
            aborts_if(true, 123);
            aborts_with(false, 456);
            succeeds_if(true, 789);
            modifies {0xCAFE::TestModule::GlobalVar};
            emits<SomeEvent>();
            ensures {true};
            requires {true};
        };

        // Also test simple assert, assume, decreases
        assert!(1 + 1 == 2, 2001);
        assume!(true);
        decreases(5);
        // No actual effects, just syntax coverage
    }

    public fun test_inline_closure_sum() {
        // Inline function with closure parameter
        fun sum_closure(
            f: |u8| u8,
            x: u8,
            y: u8
        ) : u8 {
            let sum_x = f(x);
            let sum_y = f(y);
            sum_x + sum_y
        }

        // Call with closure that adds 1
        let result = sum_closure(|a: u8| a + 1, 3, 4);
        //  (3 + 1) + (4 + 1) = 4 + 5 = 9
        assert!(result == 9, 2002);
    }

    // Additional helper to simulate global variable modification for 'modifies' spec
    static GlobalVar: u8;

    public fun set_global_var(val: u8) {
        // For demonstration, no actual mutation here in code
        // pretending to modify GlobalVar
        ()
    }

    // Run functions for each test case

    
//# run 0xCAFE::TestModule::test_nested_field_access
    
//# run 0xCAFE::TestModule::test_function_return_type
    
//# run 0xCAFE::TestModule::test_imports_and_scope
    
//# run 0xCAFE::TestModule::test_spec_block_asserts_and_effects --signers 0x0
    
//# run 0xCAFE::TestModule::test_inline_closure_sum
}
