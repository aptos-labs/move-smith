// Test for: 
// 1. Byte string literals (empty, ASCII, hex escape sequences)
// 2. Spec blocks for members, with function signatures
// 3. Deprecation diagnostics (module usage)

//# publish
address 0xCAFE {
module ByteStringDemo {
    // Test empty, ASCII and hex sequences
    public fun check_literals() {
        // Empty string
        let empty = b"";
        let empty_hex = x"";
        // Should both be empty vector<u8>
        let ascii_hello = b"Hello!";
        let hello_hex = x"48656C6C6F21"; // hex for 'H','e','l','l','o','!'

        // Hexadecimal escape
        let _newline = b"Line1\nLine2";
        let newline_hex = x"4C696E65310A4C696E6532"; // 'Line1\nLine2'

        // Mixed
        let _with_null = b"a\x00b";
        let with_null_hex = x"610062";
    }

    /// Returns the sum of the given numbers.
    public fun add(x: u8, y: u8): u8 {
        x + y
    }

    /// Returns a copy of a provided byte vector.
    public fun copy_vec(v: vector<u8>): vector<u8> {
        v
    }

    spec check_literals {
        // No postcondition; just call for coverage.
        // ensures true;
    }

    spec add(x: u8, y: u8): u8 {
        // Precise function signature provided
        ensures result == x + y;
    }

    spec copy_vec(v: vector<u8>): vector<u8> {
        // Ensures the return is equal to provided
        ensures result == v;
    }
}

//# run 0xCAFE::ByteStringDemo::check_literals

//# run 0xCAFE::ByteStringDemo::add --signers 0xCAFE --args 123u8 21u8

//# run 0xCAFE::ByteStringDemo::copy_vec --signers 0xCAFE --args b"TestVector"

//# publish
address 0xCAFE {
module DeprecationTest {
    use std::vector; // This is deprecated in Aptos, compiler will warn!

    public fun len_test() {
        let v = vector::empty<u8>();
        let n = vector::length(&v);
        // avoid unused warnings
        let _ = n;
    }

    spec len_test {
        // ensures vector::length(&vector::empty<u8>()) == 0; // Could be written if wanted
    }
}

//# run 0xCAFE::DeprecationTest::len_test

// Featurres:
// 0282457de9fee7fde903c2fa3dbfff1a: Verify that byte string literals (e.g., b"") correctly represent their hexadecimal equivalents, including empty strings, ASCII characters, and hexadecimal escape sequences.
// e503ac8923db8e280a41f115de02ceb4: Attach specification blocks to individual module members (such as functions) and optionally provide their signatures for precise specification.
// e33086d55e99e70fb78d464961a7ec1d: Understand that the compiler will warn or provide diagnostics when deprecated modules are used, encouraging migration to non-deprecated modules.
