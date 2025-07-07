
//# run 0xDEAD::TestModule::run_all_tests



//# publish
module 0xDEAD::TestModule {
    use std::vector;

    // Define a struct with no fields
    struct EmptyStruct has copy, drop, store {}

    // Test 1: Replace 'import' with 'use' for module importing syntax (done above)

    // Function to create a vector of bytes from a hex string
    public fun create_bytes_from_hex(): vector<u8> {
        let bytes: vector<u8> = vector::empty<u8>();
        // Adding bytes directly from hex string 0xdeadbeef
        // 0xdeadbeef in bytes: [0xde, 0xad, 0xbe, 0xef]
        vector::push_back(&mut bytes, 0xde);
        vector::push_back(&mut bytes, 0xad);
        vector::push_back(&mut bytes, 0xbe);
        vector::push_back(&mut bytes, 0xef);
        bytes
    }

    // Define enum with no fields for testing
    enum EnumWithoutFields has copy, drop {
        V1,
        V2,
        V3,
    }

    // Function to test creating variant of enum with no fields
    public fun test_enum_variants() {
        let v1 = EnumWithoutFields::V1;
        let v2 = EnumWithoutFields::V2;
        let v3 = EnumWithoutFields::V3;
    }

    // Function to run all tests
    public fun run_all_tests() {
        let _ = create_bytes_from_hex();
        // Fix: Assign the result of test_enum_variants() to a variable, but avoid '()' type.
        // Instead, just call the function especially if it doesn't return anything.
        // move the function call directly (no assignment needed)
        test_enum_variants();

        // Instantiate EmptyStruct and verify (just for coverage)
        let _empty = EmptyStruct {};

        // Test vector creation
        let byte_vec = create_bytes_from_hex();
        assert!(vector::length(&byte_vec) == 4, 100);
    }
}
