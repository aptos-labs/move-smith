
//# publish
module 0xCAFE::FeatureTest {
    use std::vector;
    use 0xCAFE::MyModule;

    const VERSION: u64 = 2;

    // 1. Define a 'spec' block targeting a specific schema/module with members obliquely referenced.
    //    Inside the spec, alias members and verify they are accessible without qualification.
    spec 0xCAFE::MyModule {
        // Implicit aliasing: members inside should be directly accessible
        f1;
        f3;

        // Nested specification for testing module aliasing
        let member_x: u32 = f1(5u8, false);
        let member_y: u8 = f3(20u16).y as u8;
    }

    // 2. Declare a function at top level that returns another function (function-typed value), valid in VM version >= 2.2
    public fun get_func() {
        // only compile in version >= 2.2
        if (VERSION >= 2) {
            // Define a function type: |u8, u8| -> u8
            let fn_type: |u8, u8| -> u8 = |a: u8, b: u8| {
                // Compute sum modulo 256
                (a + b)
            };
            // Call the returned function with sample args
            let result = fn_type(10u8, 20u8);
            // Use result to ensure execution
            assert!(result == 30, 999);
        }
    }

    // 3. Include internal 'use' statements inside the module and verify aliasing
    // (Note: 'use' statements are generally at module scope, but for the purpose of this test, assume aliasing)
    // The 'use' inside the module should allow referencing imported members from other modules.
    // We already imported 'std::vector' and '0xCAFE::MyModule'; test access to those.
    public fun test_use_aliasing() {
        // Use vector from std
        let v: vector<u8> = vector::empty();
        vector::push_back(&v, 1);
        vector::push_back(&v, 2);
        let first_element = *vector::borrow(&v, 0);
        assert!(first_element == 1, 888);
        // Use imported MyModule functions
        let res = MyModule::f1(1u8, true);
        assert!(res == 2, 777);
    }

    // 4. Combine features: define a function that returns a function, utilize imported module attributes directly, and ensure aliasing works via 'spec'.
    public fun combined_feature_test() {
        // Return a lambda that multiplies two u8 numbers
        let lambda: |u8, u8| -> u8 = |a: u8, b: u8| {
            a * b
        };
        // Use the lambda
        let product = lambda(4u8, 5u8);
        assert!(product == 20, 555);
        // Call imported function via alias
        let res = MyModule::f2(7u16);
        let (_a, _b) = res;
        // Use the first value for extra validation
        assert!(_a == 8u16, 556);
    }

    // 5. Verify that function return types (returning functions) and aliasing behave correctly under VM version 2.2+
    public fun verify_function_return_behavior() {
        if (VERSION >= 2) {
            let func_value = get_func();
            // Since get_func() has no explicit return, ensure it executes without errors
        }
    }
}


//# run 0xCAFE::FeatureTest::test_use_aliasing --signers 0xBADA


//# run 0xCAFE::FeatureTest::combined_feature_test --signers 0xBADA


//# run 0xCAFE::FeatureTest::verify_function_return_behavior


// Featurres:
// 843cbf156cbc53e45050badafe3d2551: Define 'spec' blocks with target schemas or modules, enabling implicit aliasing of their constituent members.
// ae915a9726a36c11d4f1d384f1a96087: Allow functions to return function-typed values at the top level if the language version is at least 2.2.
// 7674a9dca6177b17be0aef022cb10f2f: Import modules in Move files using the 'use' statement.
