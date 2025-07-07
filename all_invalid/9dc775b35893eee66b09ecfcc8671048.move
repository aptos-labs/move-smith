
//# publish
module 0xDEAD::TypeCastingAndQuantifiers {
    // Import std::vector to use vector functions
    use std::vector;

    // This module tests cast expressions ('as' keyword), quantifiers (binding with colon), and byte string literals.

    // Function to test casting expressions
    public fun test_casts() {
        let num: u8 = 255;
        let casted_num: u16 = num as u16; // cast from u8 to u16
        let casted_u128: u128 = casted_num as u128; // cast from u16 to u128

        // Use the last expression as return value
        casted_u128
    }

    // Function to test variable binding with type via colon and quantification
    public fun test_quantifiers_and_binding() {
        // Bind variable with explicit type (quantifier)
        let x: bool = true;
        let y: u64 = 42;
        let z: vector<u8> = b"hello"; // byte string literal

        // Verify the types are correctly assigned
        // (These are just for testing; no assertions needed)
        (x, y, z)
    }

    // Function to test byte string literals
    public fun test_byte_strings() {
        let bytes1: vector<u8> = b"MoveLang";
        let bytes2: vector<u8> = b"TestBytes";

        // Use the byte strings
        let sum_length: u64 = (vector::length(&bytes1)) + (vector::length(&bytes2));

        sum_length
    }

    // Runner function to call all tests
    public fun run() {
        let _ = test_casts();
        let _ = test_quantifiers_and_binding();
        let _ = test_byte_strings();
    }
}


//# run 0xDEAD::TypeCastingAndQuantifiers::run
