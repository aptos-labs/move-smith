//# publish
module 0xabcde::constants {
    fun get_u8(): u8 {
        255
    }

    fun get_u16(): u16 {
        65535
    }

    fun get_u32(): u32 {
        4294967295
    }

    fun get_u64(): u64 {
        1234567890123456789
    }

    fun get_u128(): u128 {
        340282366920938463463374607431768211455
    }

    fun get_bool_true(): bool {
        true
    }

    fun get_bool_false(): bool {
        false
    }

    fun get_address(): address {
        @0xdeadbeefdeadbeefdeadbeefdeadbeefdeadbeef
    }

    fun get_byte_vector(): vector<u8> {
        b"MovePrimitives"
    }

    fun get_hex_bytes(): vector<u8> {
        x"deadbeef"
    }

    fun get_unicode_bytes(): vector<u8> {
        b"こんにちは"
    }
}

 //# run
script {
    // Fetch constants defined in the module
    const U8_CONST: u8 = 255;
    const U16_CONST: u16 = 65535;
    const U32_CONST: u32 = 4294967295;
    const U64_CONST: u64 = 1234567890123456789;
    const U128_CONST: u128 = 340282366920938463463374607431768211455;
    const BOOL_TRUE: bool = true;
    const BOOL_FALSE: bool = false;
    const ADDR_CONST: address = @0xdeadbeefdeadbeefdeadbeefdeadbeefdeadbeef;
    const HEX_BYTES: vector<u8> = x"deadbeef";
    const BYTE_VECTOR: vector<u8> = b"MovePrimitives";
    const UNICODE_BYTES: vector<u8> = b"\xe3\x81\x93\xe3\x81\xab\xe3\x81\xa1\xe3\x81\xaf"; // "こんにちは" in UTF-8

    fun main() {
        // Verify integer constants
        assert!(U8_CONST == 255, 42);
        assert!(U16_CONST == 65535, 42);
        assert!(U32_CONST == 4294967295, 42);
        assert!(U64_CONST == 1234567890123456789, 42);
        assert!(U128_CONST == 340282366920938463463374607431768211455, 42);

        // Verify boolean constants
        assert!(BOOL_TRUE == true, 42);
        assert!(BOOL_FALSE == false, 42);

        // Verify address
        assert!(ADDR_CONST == @0xdeadbeefdeadbeefdeadbeefdeadbeefdeadbeef, 42);

        // Verify byte vectors
        assert!(HEX_BYTES == x"deadbeef", 42);
        assert!(BYTE_VECTOR == b"MovePrimitives", 42);
        assert!(UNICODE_BYTES == b"\xe3\x81\x93\xe3\x81\xab\xe3\x81\xa1\xe3\x81\xaf", 42);
    }
}

 //# publish
module 0xabcde::interaction {
    // Function to test conditional assignment and multiplication
    public fun test_conditional_multiplication(a: u64, b: u64, flag: bool): u64 {
        let mut x = a;
        if (flag) {
            x = b;
        };
        let product = x * 5;
        if (x > 100) {
            Self::example_func();
        };
        product
    }

    // Another function with nested conditionals and invokes
    public fun compute_and_invoke(a: u64, b: u64, c: bool): u64 {
        let mut result = a;
        if (c) {
            result = b;
            Self::helper_func();
        } else {
            Self::helper_func();
        };
        let final_val = result + 42;
        if (final_val >= 50) {
            Self::special_func();
        };
        final_val
    }

    fun example_func() {
        assert!(true, 1);
    }

    fun helper_func() {
        assert!(true, 2);
    }

    fun special_func() {
        assert!(true, 3);
    }
}

 //# run 0xabcde::interaction::test_conditional_multiplication --signers 0x0 --args 10 20 true

 //# run 0xabcde::interaction::test_conditional_multiplication --signers 0x0 --args 10 20 false

 //# run 0xabcde::interaction::compute_and_invoke --signers 0x0 --args 10 20 true

 //# run 0xabcde::interaction::compute_and_invoke --signers 0x0 --args 10 20 false