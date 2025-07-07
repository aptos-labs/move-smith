
//# publish
module 0xCAFE::TypeParamStructs {
    struct Container<T> {
        value: T,
    }

    // Function to create a new Container with a given value
    public fun create_container<T>(val: T): Container<T> {
        Container { value: val }
    }
}


//# publish
module 0xCAFE::SpecUpdate {
    // Placeholder for specification update block
    // Mimic the feature that can contain expressions with possibly unbound names
    // Here, we intentionally include an invalid reference to trigger compile-time error
    #[specification]
    fun update_spec() {
        let unbound_name = unbound_variable + 1; // unbound_variable is not declared
    }
}


//# publish
module 0xCAFE::HexLiteralTest {
    // Function to test invalid hex string literals
    public fun test_invalid_hex_literals() {
        let invalid_hex_1 = x"ZZ"; // invalid hex characters, should produce compile error
        let invalid_hex_2 = x"G1"; // invalid hex characters, should produce compile error
        let invalid_hex_3 = x"XZ"; // invalid hex characters, should produce compile error
    }
}


//# run 0xCAFE::TypeParamStructs::create_container --signers 0xBEEF --args 123u8

//# run 0xCAFE::HexLiteralTest::test_invalid_hex_literals

// Featurres:
// 7bed143cecaa4a44ba2a9ddc13d7c0a5: Define structs with type parameters in your modules.
// b154c6d73926087988e8bccd09deff01: Use specification update blocks that can contain expressions with potentially unbound names.
// fdbba66652f7b34b82cf64fc96933a9d: Receive descriptive compile-time errors when using invalid hexadecimal characters in hex string literals
