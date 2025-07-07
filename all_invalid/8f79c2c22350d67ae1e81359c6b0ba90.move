//# publish
module 0x1::ByteStringAndAddressTest {
    use std::debug;
    use std::string;
    use std::address;
    use std::vector;

    /// Test for (1) Byte string literals correctness.
    public fun test_byte_strings() {
        // Empty byte string
        let empty: vector<u8> = b"";
        debug::print(&empty);

        // ASCII byte string
        let ascii: vector<u8> = b"Hello";
        debug::print(&ascii);

        // Hex escape
        let hex: vector<u8> = b"\x41\x42\x43"; // ABC
        debug::print(&hex);

        // Mixed ASCII and hex escapes
        let mixed: vector<u8> = b"\x41B\x43"; // ABC
        debug::print(&mixed);

        // Non-ASCII bytes
        let non_ascii: vector<u8> = b"\xff\x00";
        debug::print(&non_ascii);
    }

    /// Test for (2) Parsing address string into NumericalAddress
    public fun test_address_parsing() {
        // Normal 16-byte address string
        let addr_str = string::utf8(b"0xCAFEBABECAFEBABECAFEBABECAFEBABE");
        let addr_parsed = address::from_hex(addr_str);
        debug::print(&addr_parsed);

        // Short address string
        let addr2_str = string::utf8(b"0x1");
        let addr2_parsed = address::from_hex(addr2_str);
        debug::print(&addr2_parsed);
    }

    /// (3) Function with parameters
    public fun sum_bytes(byte_str: vector<u8>, addend: u8): u8 {
        let mut sum = 0u8;
        let len = vector::length(&byte_str);
        let mut i = 0;
        while (i < len) {
            sum = sum + *vector::borrow(&byte_str, i);
            i = i + 1;
        };
        sum = sum + addend;
        sum
    }

    /// "Runner" that exercises the sum_bytes parameter function.
    public fun run_sum_bytes() {
        let b = b"\x01\x02\x03";
        let s = Self::sum_bytes(b, 4);   // sum: 1+2+3+4=10u8
        debug::print(&s);
    }

    /// Main runner
    public fun run_all() {
        Self::test_byte_strings();
        Self::test_address_parsing();
        Self::run_sum_bytes();
    }
}

//# run 0x1::ByteStringAndAddressTest::run_all --signers 0x1

//# run 0x1::ByteStringAndAddressTest::sum_bytes --signers 0x1 --args b"\x05\x06" 10u8

//# run 0x1::ByteStringAndAddressTest::sum_bytes --signers 0x1 --args b"" 0u8

//# run 0x1::ByteStringAndAddressTest::sum_bytes --signers 0x1 --args b"\x01\x01\x01" 1u8

//# run 0x1::ByteStringAndAddressTest::test_address_parsing --signers 0x1

//# publish
module 0x2::ScriptTest {
    use std::debug;

    public fun param_sum(x: u8, y: u8) {
        let z = x + y;
        debug::print(&z);
    }
}

//# run 0x2::ScriptTest::param_sum --signers 0x2 --args 5u8 7u8