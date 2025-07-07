// Corrected transactional test code


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
            let _ = x;
        };

        // After loop, x is unchanged by inner shadow
        let _ = x;
    }

    // Test variable shadowing inside nested scopes
    public fun test_shadowing() {
        let x = 5u8;

        if (x > 3) {
            let x = x + 10; // shadow outer x
            let _ = x;
        };

        // Outside if, original x unchanged
        let _ = x;
    }

    // Test inline function usage
    public fun test_inline_functions() {
        let a: u8 = 3;
        let b: u8 = 4;
        let sum = TestHelpers::inline_add(a, b);
        let _ = sum;
    }

    // Test resource address access restrictions
    struct SecretData { value: u64 }

    public fun access_secret(addr: address): u64 {
        let secret = borrow_global<SecretData>(addr);
        secret.value
    }

    // Mock function to demonstrate resource visibility
    public fun test_resource_access() {
        ()
    }

    // Test module hierarchy and separation
    public fun test_module_hierarchy() {
        // Call a function in a sub-module
        0xC0FF::InteractionTest::sub_module::sub_feature();
    }
}


//# publish
module 0xABC::StringFeatures {
    public fun print_utf8_string() {
        // UTF-8 string literal; Move supports UTF-8 in string literals
        let utf8_str = b"Hello, 世界🌏";
        // Just to test string preservation, no print in Move 
        let _ = utf8_str;
    }
}


//# publish
module 0xDEF::DependencyFree {
    // Use external helpers that do not create cyclic dependencies
    public fun use_helpers() {
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
        inner_script();
    }

    fun inner_script() {
        // Nested script logic
        let outer_var = 42u8;
        let _ = outer_var;
    }
}
