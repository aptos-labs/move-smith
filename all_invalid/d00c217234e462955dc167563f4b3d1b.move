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
        // Avoid unused warning
        let _ = (empty, empty_hex, ascii_hello, hello_hex, newline_hex, with_null_hex);
    }

    /// Returns the sum of the given numbers.
    public fun add(x: u8, y: u8): u8 {
        x + y
    }

    /// Returns a copy of a provided byte vector.
    public fun copy_vec(v: vector<u8>): vector<u8> {
        v
    }

    // Runner for testing add (runner takes no arguments)
    public fun run_add() {
        let _ = Self::add(1, 2);
    }

    // Runner for copy_vec (runner takes no arguments)
    public fun run_copy_vec() {
        let _ = Self::copy_vec(b"hello");
    }

    spec check_literals {
        // No postcondition; just call for coverage.
    }

    spec add(x: u8, y: u8): u8 {
        ensures result == x + y;
    }

    spec copy_vec(v: vector<u8>): vector<u8> {
        ensures result == v;
    }
}

//# run 0xCAFE::ByteStringDemo::check_literals
//# run 0xCAFE::ByteStringDemo::run_add
//# run 0xCAFE::ByteStringDemo::run_copy_vec

//# publish
address 0xCAFE {
module DeprecationTest {
    use std::vector; // This is deprecated in Aptos, compiler will warn!

    public fun len_test() {
        let v = vector::empty<u8>();
        let n = vector::length(&v);
        // avoid unused warning
        let _ = n;
    }

    // Runner function (for no-arg call)
    public fun run_len_test() {
        Self::len_test();
    }

    spec len_test {
        // ensures vector::length(&vector::empty<u8>()) == 0;
    }
}

//# run 0xCAFE::DeprecationTest::run_len_test

// Features:
// 0282457de9fee7fde903c2fa3dbfff1a: Verify that byte string literals (e.g., b"") correctly represent their hexadecimal equivalents, including empty strings, ASCII characters, and hexadecimal escape sequences.
// e503ac8923db8e280a41f115de02ceb4: Attach specification blocks to individual module members (such as functions) and optionally provide their signatures for precise specification.
// e33086d55e99e70fb78d464961a7ec1d: Understand that the compiler will warn or provide diagnostics when deprecated modules are used, encouraging migration to non-deprecated modules.