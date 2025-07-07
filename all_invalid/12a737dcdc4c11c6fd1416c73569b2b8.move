//# publish
module 0xCAFE::HexAndAttrs {
    use std::vector;
    use std::string;

    /// Demonstrate decoding a hex literal to a vector<u8>
    public fun decode_hex(): vector<u8> {
        // Hex string literal, decoded automatically to vector<u8>
        let bytes = b"0123456789abcdef";
        // b"" is a byte string literal, here just for demonstration.
        // Let's decode a hex string explicitly defined as hex literal.
        // Move supports hex bytes via \xhh escape or byte string literals,
        // but to decode a hex string "48656c6c6f" to vector<u8> ("Hello"), 
        // typically would be done outside Move, but here we do direct byte literals.

        // We'll return the literal bytes, equivalent to [0x01, 0x23, 0x45, ...]
        let decoded: vector<u8> = vector::from_bytes(hex"0123456789abcdef");
        decoded
    }

    #[test_attribute]
    public fun with_attribute() acquires HexAndAttrs {
        // Use an attribute on a function, just declared above.
    }

    // Function using compound assignment operators
    public fun compound_assign(): u64 {
        let mut x: u64 = 100;
        let mut y: u64 = 2;

        x += y; // x = 102
        x -= 50; // x = 52
        x *= 3;  // x = 156
        x /= 4;  // x = 39
        x %= 7;  // x = 4

        let mut z: u64 = 0b1010; // 10 decimal

        z |= 0b0101;  // z = 0b1111 (15)
        z &= 0b1100;  // z = 0b1100 (12)
        z ^= 0b0110;  // z = 0b1010 (10)
        z <<= 1;      // z = 0b10100 (20)
        z >>= 2;      // z = 0b0101 (5)

        x + z  // return the sum of final x and z: 4 + 5 = 9
    }

    // Runner function for compound assign demonstration
    public fun runner(): u64 {
        // Call compound_assign and return its result
        compound_assign()
    }
}
 
//# run 0xCAFE::HexAndAttrs::decode_hex

//# run 0xCAFE::HexAndAttrs::with_attribute

//# run 0xCAFE::HexAndAttrs::runner

// Featurres:
// 169468a97cc7690f41216ca0da0a89c2: Decode hexadecimal string literals into byte vectors
// 7b8172797b973455b7119c42abf5a4df: Attach attributes to Move declarations by specifying an attribute name.
// 2f75f3aabce2b59e2781668236d5b818: Use compound assignment operators like "+=", "-=", "*=", "%=", "/=", "|=", "&=", "^=", "<<=", and ">>=" in Move to perform the corresponding binary operation and assignment in a single step
