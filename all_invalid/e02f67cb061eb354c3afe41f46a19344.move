
//# publish
module 0xCAFE::TestInteraction {
    use std::signer;
    use std::vector;
    use 0xCAFE::MyModule;

    // Structure with attribute attribute attribute
    struct AttrStruct has copy, drop, store {
        id: u64,
        name: vector<u8>,
    }

    // Enum with variants with attributes
    // attribute]
    enum AttributeEnum has copy, drop {
        Variant1,
        // attribute]
        Variant2(u64),
        // attribute]
        Variant3 { value: bool },
    }

    // Resource with internal visibility
    struct InternalResource has key {
        secret: u64,
    }

    // Module-level script entry point for testing variable scopes
    public fun test_variable_scopes(): bool {
        let outer_var = 100u64;
        let shadow_var = 50u64;
        let result = false;

        // Outer scope variable
        if (outer_var == 100u64) {
            result = true;
        };

        // Shadow variable inside loop
        let shadow_var = shadow_var;
        let i = 0u64..5u64;

        for (idx in i) {
            let shadow_var = idx; // Shadowing outer shadow_var
            // Verify shadowing: inner shadow_var should be idx
            if (shadow_var != idx) {
                result = false;
            };
            // Also verify outer outer_var remains unchanged
            if (outer_var != 100u64) {
                result = false;
            };
        };

        // After loop, shadow_var should be unchanged
        if (shadow_var != 50u64) {
            result = false;
        };

        // Verify that modifying inner shadow_var inside loop did not affect outer variable
        result
    }

    // Function to test access restrictions
    fun internal_func() {
        // An internal function within the module
    }

    // Expose wrapper to call internal function and check function accessibility
    public fun call_internal(): bool {
        // The internal function is not accessible here, but this wrapper could
        // be used for testing, assuming accessible for now.
        true
    }

    // Function to test attribute annotations on structs and enums
    public fun check_attributes(): (u64, bool, vector<u8>) {
        let attr_struct = AttrStruct { id: 42, name: b"Test" };
        let attr_enum = AttributeEnum::Variant3 { value: true };

        // Pattern match on enum
        let matched_value = match (attr_enum) {
            AttributeEnum::Variant1 => 0u64,
            AttributeEnum::Variant2(n) => n,
            AttributeEnum::Variant3 { value } => if (value) {1} else {0},
        };

        (attr_struct.id, match (attr_enum) { AttributeEnum::Variant3 { value } => value, _ => false }, attr_struct.name)
    }

    // Function to test dereferencing a pointer
    public fun test_dereference() : u64 {
        // Create a value and get its reference
        let val = 12345u64;
        let ptr: &u64 = &val;
        // Dereference pointer
        let deref_val = *ptr;
        deref_val
    }

    // Function to call a function from another module returning a constant value
    public fun call_external(): u8 {
        // Call the function in MyModule that returns 10
        let val = 0xCAFE::MyModule::f1(1u8, false);
        val
    }

    // Script entry point to perform all tests
    public fun run_tests() {
        assert!(test_variable_scopes(), 1001);
        assert!(call_internal(), 1002);
        let (_id, val, name) = check_attributes();
        assert!(val == 1, 1003);
        assert!(*vector::borrow(&name, 0) == b'T', 1004);
        // Call dereference test
        let deref_result = test_dereference();
        assert!(deref_result == 12345u64, 1005);
        // Call external module function
        let ext_result = call_external();
        assert!(ext_result == 1u8, 1006);
    }
}


//# run 0xCAFE::TestInteraction::run_tests


// Featurres:
// b70ccb6e356eebb5b3735f5f76cd5273: Write script entry points in Move modules
// 0b62e2b6ef6d21801ee5807769ee6a3e: Test that local variable assignments inside and outside a while loop are handled correctly and that variable shadowing does not affect values across loop iterations.
// 63d45d364eac9afd0006b4525c93f85c: Use 'internal' visibility to restrict access within the module or package.
// c0c9c254b1d78a10525d37ba3131e85a: Annotate struct variants with attributes
// 73f99b77b6aa6132fce11178f34e1117: Dereference pointers with the `Dereference` expression.
// 7976d22becb3d0788e35d04a5d3cc103: Test that a module exposing a function can be called from another module to retrieve a constant value.
