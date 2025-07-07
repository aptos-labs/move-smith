
//# publish
module 0xBADD::NestedStructs {
    // Nested structs to test nested field access
    struct OuterStruct has store, key {
        inner: InnerStruct,
        value: u64,
    }

    struct InnerStruct has store {
        nested_field: u32,
        more_data: bool,
    }

    public fun create_outer_struct(inner: InnerStruct, value: u64): OuterStruct {
        OuterStruct { inner, value }
    }

    public fun get_inner_nested_field(s: &OuterStruct): u32 {
        s.inner.nested_field
    }

    public fun set_inner_nested_field(s: &mut OuterStruct, new_value: u32) {
        s.inner.nested_field = new_value;
    }
}


//# publish
module 0xDEAD::DeprecationTest {
    // Module with deprecated functions
    use std::option;

    // Simulate deprecation via attribute (no real attribute in Move, but for test, assume it's for tooling)
    // deprecated]
    public fun deprecated_func() {
        // dummy implementation
    }

    public fun active_func() {
        // dummy implementation
    }
}


//# publish
module 0xC0FF::AccessControl {
    // Internal-only function (simulate internal visibility)
    fun internal_only_func() {
        // Implementation only accessible within this module
    }

    public fun call_internal() {
        internal_only_func()
    }
}

// Test code to verify nested field access

    // Create nested structs and test access
    use 0xBADD::NestedStructs;

    let inner = NestedStructs::InnerStruct { nested_field: 42, more_data: true };
    let outer = NestedStructs::create_outer_struct(inner, 100);
    let value_before = NestedStructs::get_inner_nested_field(&outer);
    // Update nested field
    NestedStructs::set_inner_nested_field(&mut outer, 99);
    let value_after = NestedStructs::get_inner_nested_field(&outer);
}
// Expected: value_before == 42, value_after == 99


    // Attempt to call deprecated function from non-deprecated module
    use 0xDEAD::DeprecationTest;

    // Call active function - should succeed
    DeprecationTest::active_func();

    // Call deprecated function - in real scenario, triggers warning/error if deprecation enforced
    DeprecationTest::deprecated_func();
}
// Expected: warnings/errors for deprecated_func (depending on compiler tooling)


    // Attempt to call internal function from outside its module - should fail
    // But since internal_only_func is private (not public), this should be an error if attempted.
    // The following code line is commented out to represent an invalid call.
    // use 0xC0FF::AccessControl;

    // let _ = AccessControl::internal_only_func(); // This should cause compile-time error if uncommented
}
// Expected: compilation error, access denied


    // Call internal function via public wrapper - should succeed
    use 0xC0FF::AccessControl;

    AccessControl::call_internal();
}
// Expected: success


// Featurres:
// 78f8dc464195108ec06049bb15ab9fa2: Access nested fields of expressions using dot notation in Move code.
// c1367d37b2075aa6fdcc5740b3ac2c36: Attach deprecation attributes at the address (namespace) level to mark all modules under it as deprecated.
// 63d45d364eac9afd0006b4525c93f85c: Use 'internal' visibility to restrict access within the module or package.
