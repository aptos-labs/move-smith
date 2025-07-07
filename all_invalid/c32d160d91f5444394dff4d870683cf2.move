
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
const _ASSERT_SCHEMA_A_FIELD_A: u64 = 0xBADD::SpecFeatures::SchemaA {field_a: 0, field_b: false}.field_a;
const _ASSERT_SCHEMA_B_VALUE: vector<u8> = 0xBADD::SpecFeatures::SchemaB {value: vector::empty(), optional: option::none()}.value;

// 2. Test function returning a function type (Move 2.2+)
let inc = 0xBADD::FunctionReturnTypeModule::get_incrementer();
let result = inc(42);
assert!(result == 43, 999);

// 3. Test import statement and external function call
// Import statement is within module, calling the imported function
let imported_result = 0xBADD::ImportingModule::call_external_increment(dummy_signer, 55);
assert!(imported_result == 56, 999);

// 4. Test nested structs: create, dereference, mutate, and verify
// For the purpose of the test, create the nested structs and mutate their fields
let inner = InnerStruct {val: 100};
let outer = OuterStruct {inner: &mut inner};
let OuterStruct {inner: inner_ref} = outer;
inner_ref.val = 200;
assert!(inner_ref.val == 200, 999);


// Featurres:
// 843cbf156cbc53e45050badafe3d2551: Define 'spec' blocks with target schemas or modules, enabling implicit aliasing of their constituent members.
// ae915a9726a36c11d4f1d384f1a96087: Allow functions to return function-typed values at the top level if the language version is at least 2.2.
// 7674a9dca6177b17be0aef022cb10f2f: Import modules in Move files using the 'use' statement.
// 1434c46b5ad1c098bf0160e364ed233d: Test that references to nested structs can be dereferenced and mutated correctly, and that changes persist as expected.
