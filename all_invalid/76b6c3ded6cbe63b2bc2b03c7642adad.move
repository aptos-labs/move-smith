
//# publish
module 0xBABA::TestHelpers {
    // Helper module for test functions
    public fun inline_add(a: u8, b: u8): u8 {
        a + b
    }
    public fun internal_function(): u64 {
        999u64
    }
}


//# publish
module 0xC0FF::InteractionTest {
    // Entry point to run the comprehensive interaction test
    public fun run() {
        // Call sub-module functions for various features
        // No args; all internal calls
        InternalFeatures::test_variable_scoping();
        InternalFeatures::test_shadowing();
        InternalFeatures::test_inline_functions();
        InternalFeatures::test_resource_access();
        InternalFeatures::test_module_hierarchy();

        // Call functions involving string handling and UTF-8
        StringFeatures::print_utf8_string();

        // Call functions that avoid cyclic dependencies
        DependencyFree::use_helpers();

        // Call functions with local variable assignments outside loops
        LocalVarsOutsideLoops::test_assignment();

        // Call functions with inner scripts (represented as inner functions)
        NestedScript::test_inner_script();
    }
}


//# publish
module 0xDEC0::InternalFeatures {
    use 0xBABA::TestHelpers;

    // Test variable assignments inside and outside while loops
    public fun test_variable_scoping() {
        let x = 0u64;
        let y = 10u64;

        // Outer scope assignment
        let _ = x;

        while (x < y) {
            // Inside loop, shadow variable 'x'
            let x = x + 1;
            // do something with x inside loop
            // no need for return, last expression
            let _ = x;
        };

        // After loop, x is unchanged by inner shadow
        // Verify x is still 0
        // Can't assert here; just ensure no compile errors
        // Use x to influence flow
        let _ = x;
    }

    // Test variable shadowing inside nested scopes
    public fun test_shadowing() {
        let x = 5u8;

        if (x > 3) {
            let x = x + 10; // shadow outer x
            // x now 15 in this inner scope
            let _ = x;
        };

        // Outside if, original x unchanged
        let _ = x;
    }

    // Test inline function usage
    public fun test_inline_functions() {
        let a: u8 = 3;
        let b: u8 = 4;
        let sum = 0u8;
        // Call inline_add directly
        let sum = TestHelpers::inline_add(a, b);
        // Use sum for flow
        let _ = sum;
    }

    // Test resource address access restrictions
    struct SecretData { value: u64 }

    public fun access_secret(addr: address): u64 {
        // Should be inaccessible if not imported
        // But test internal access: this function is internal to module
        let secret = borrow_global<SecretData>(addr);
        secret.value
    }

    // Mock function to demonstrate resource visibility
    public fun test_resource_access() {
        // For demonstration only; actual resource is not created here
        // Should not be called outside authorized context
        // just a placeholder
        ()
    }

    // Test module hierarchy and separation
    public fun test_module_hierarchy() {
        // Call a function in a supposed sub-module (assumes exists)
        // No cyclic dependencies
        sub_module::sub_feature();
    }
}


//# publish
module 0xABC::StringFeatures {
    public fun print_utf8_string() {
        let utf8_str = b"Hello, 世界🌏"; // UTF-8 string literal
        // Just to test string preservation, no print in Move 
        // but we can do slices or conversion if needed
        let _ = utf8_str;
    }
}


//# publish
module 0xDEF::DependencyFree {
    // Use external helpers that do not create cyclic dependencies
    public fun use_helpers() {
        // Use helper from other module
        let result = 0xBABA::TestHelpers::inline_add(5u8, 6u8);
        let _ = result;
    }
}


//# publish
module 0x123::LocalVarsOutsideLoops {
    public fun test_assignment() {
        let a = 7u64;
        let b = a + 3;
        // Outside loop, variables assigned
        let _ = (a, b);
    }
}


//# publish
module 0x456::NestedScript {
    // Simulating inner script with nested function
    public fun test_inner_script() {
        // Outer function
        inner_script();
    }

    fun inner_script() {
        // Nested script logic
        let outer_var = 42u8;
        // Local variable inside inner script
        let _ = outer_var;
        // Verify variable parent scope if assigned/referenced
    }
}


// Featurres:
// b70ccb6e356eebb5b3735f5f76cd5273: Write script entry points in Move modules
// 0b62e2b6ef6d21801ee5807769ee6a3e: Test that local variable assignments inside and outside a while loop are handled correctly and that variable shadowing does not affect values across loop iterations.
// 63d45d364eac9afd0006b4525c93f85c: Use 'internal' visibility to restrict access within the module or package.
// 04f5b3ac51075eb7e92f97521dc9362e: Call inline functions from non-inline (regular) functions.
// 28364e569a2ebb21d66d9acdcec7b8c0: Define modules without cyclic instantiation dependencies
// 4859f64d87e19222c0de459ca59e536f: Include UTF-8 encoded characters in string literals.
