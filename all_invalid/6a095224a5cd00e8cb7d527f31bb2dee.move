
//# publish
module 0xBADD::SpecFeatures {
    // This module serves to define some dummy spec schemas and associated members for testing
    // No internal logic needed; just for schema referencing validation
    struct SchemaA has copy, drop, store, key {
        field_a: u64,
        field_b: bool,
    }

    struct SchemaB has copy, drop, store, key {
        value: vector<u8>,
        optional: option<u64>,
    }
}



//# publish
module 0xBADD::FunctionReturnTypeModule {
    // Define a function at top level that returns a function type (applicable for Move 2.2+)
    public fun get_incrementer(): |u64|u64 {
        copy |x: u64| { x + 1 }
    }
}



//# publish
module 0xBADD::ImportingModule {
    // Dummy imported module
    use std::signer;

    // Function to call an external module's function (simulate import)
    public fun call_external_increment(s: signer, x: u64): u64 {
        // Call the function and return result
        0xBADD::FunctionReturnTypeModule::get_incrementer()(x)
    }
}



//# publish
module 0xBADD::NestedStructModule {
    struct InnerStruct has copy, drop, store {
        val: u64,
    }

    struct OuterStruct has copy, drop, store {
        inner: &mut InnerStruct,
    }
}


// Since 'spec' is a conceptual feature in Move, for this test, we simulate by referencing the schemas
// and confirming the compiler recognizes internal members.

// Note: Can't declare constants in scripts, so wrap in a main function
public fun main(dummy_signer: &signer) {
    // 1. Validate schema member referencing
    let _dummy_schema_a = 0xBADD::SpecFeatures::SchemaA {
        field_a: 0,
        field_b: false,
    };
    let _field_a_value = _dummy_schema_a.field_a;

    let _dummy_schema_b = 0xBADD::SpecFeatures::SchemaB {
        value: vector::empty(),
        optional: option::none<u64>(),
    };
    let _value_field = _dummy_schema_b.value;

    // 2. Test function returning a function type (Move 2.2+)
    let inc = 0xBADD::FunctionReturnTypeModule::get_incrementer();
    let result = inc(42);
    assert!(result == 43, 999);

    // 3. Test import statement and external function call
    // For the purpose of test, create a dummy signer
    let dummy_signer = signer::borrow_signer(dummy_signer);
    let imported_result = 0xBADD::ImportingModule::call_external_increment(dummy_signer, 55);
    assert!(imported_result == 56, 999);

    // 4. Test nested structs: create, dereference, mutate, and verify
    // For the purpose of the test, create the nested structs and mutate their fields
    let inner = InnerStruct { val: 100 };
    let outer = OuterStruct { inner: &mut inner };
    // Dereference and mutate
    outer.inner.val = 200;
    assert!(outer.inner.val == 200, 999);
}
