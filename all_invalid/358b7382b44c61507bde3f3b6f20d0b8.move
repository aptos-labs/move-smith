
//# publish
module 0xDEAD::TestModule {
    use std::vector;

    // Test with module attribute

//# publish
    module ATTRIBUTE1 {
        public fun dummy() {}
    }

    // Define a module with duplicate attributes

//# publish
    module ATTRIBUTE_ATTR1 {
        public fun dummy() {}
    }

    // Check merging modules with proper attribute handling
    public fun merge_modules() {
        // no operation, just exercises the module merging
        // and attribute processing at compile time
    }
}



//# run 0xDEAD::TestModule::merge_modules



//# publish
module 0xBADD::AttributeTest {
    use std::vector;

    // Module with no attribute

//# publish
    module NormalModule {}

    // Module with an attribute

//# publish
    module AttrModule ATTRIBUTE {}

// Use attribute on function
    public fun attribute_test() {}
}



//# run 0xBADD::AttributeTest::attribute_test --signers 0xBADD



//# publish
module 0xC0FFEE::DuplicateAttributes {
    // Assign multiple attributes to the same function to test duplicate attribute handling
    // attribute1 attribute1 attribute2]
    public fun duplicate_attr() {}

    // Assign multiple attributes to a struct
    // attrA attrA]
    // attrA attrA]
    struct SampleStruct has store, key {
        val: u64
    }

    // Assign multiple attributes to a enum
    // enum_attr]
    enum SampleEnum {
        Variant1,
        Variant2
    }

    // Function to initialize
    public fun test_duplicate() {}
}



//# run 0xC0FFEE::DuplicateAttributes::test_duplicate --signers 0xC0FFEE



//# publish
module 0xFAKE::NestedModules {
    // Module within module via nested definitions, but in Move, from top-level, we simulate nested modules via naming conventions
    // We simulate a nested module with concatenated names

    // Attribute to test with nested-like structure

//# publish
    module NestedModule {
        public fun nested_func() {}
    }

    // Attribute application to simulate nested module attribute usage
    public fun call_nested() {
        // Corrected invocation syntax: fully qualified path with the move module syntax
        // Note: Move does not support nested modules via dot notation directly; 
        // We simulate nested modules by fully qualifying the module name and calling the function
        // Correct usage:
        0xFAKE::NestedModules::NestedModule::nested_func()
    }
}



//# run 0xFAKE::NestedModules::call_nested --signers 0xFAKE



//# publish
module 0xABCD::ComplexTest {
    use std::vector;

    // Define complex struct with nested types
    struct ComplexStruct has store, key {
        id: u64,
        name: vector<u8>,
        data: vector<ComplexStruct>,
    }

    // Define enum with associated data
    enum ComplexEnum {
        VariantA,
        VariantB,
        VariantC { x: u64, y: u64 }
    }

    // Function to create complex instance
    public fun create_complex_struct(id: u64, name: vector<u8>, data: vector<ComplexStruct>): ComplexStruct {
        let s = ComplexStruct {id, name, data};
        s
    }

    // Function to test enum pattern matching (simulate, no pattern matching in Move, so use if-else constructs)
    public fun pattern_test(e: ComplexEnum): u64 {
        if (match (e) {
            ComplexEnum::VariantA => true,
            _ => false
        }) {
            1
        } else if (match (e) {
            ComplexEnum::VariantB => true,
            _ => false
        }) {
            2
        } else {
            3
        }
    }
}



//# run 0xABCD::ComplexTest::create_complex_struct --signers 0xABCD --args 42u64 b"test" vector[]



//# run 0xABCD::ComplexTest::pattern_test --signers 0xABCD --args 0u8 // testing enum matching with dummy input
