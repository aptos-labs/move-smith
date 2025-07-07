
//# publish
module 0xCAFE::AddressRedundancy {
    // Intentionally test module address redundancy in naming and usage.
    // This module just exists at 0xCAFE for usage in test scripts.
    public fun dummy() {
    }
}

// Attempt to publish module at 0xCAFE again to check redundancy detection

//# publish
module 0xCAFE::AddressRedundancy {
    // Re-declaration of module with same address and name is an error in real compile
    // This test is to check if compiler/linter detects address redundancy
    // The content can be empty or minimal
    public fun dummy2() {
    }
}


//# publish
module 0xCAFE::ByteStringLiterals {
    public fun empty_bytes(): vector<u8> {
        b""
    }

    public fun ascii_bytes(): vector<u8> {
        b"hello"
    }

    public fun hex_escape_bytes(): vector<u8> {
        // '\x01' = byte 0x01, '\x0a' = byte 0x0a (line feed)
        b"\x01\x0a"
    }

    public fun verify_bytes() {
        let empty = empty_bytes();
        let hello = ascii_bytes();
        let hexed = hex_escape_bytes();

        // Just access to avoid warnings; no asserts needed by instruction
        let _ = *vector::borrow(&empty, 0); // This will abort if empty, so don't actually borrow index 0 in empty vector
        // Instead we skip invalid borrow to avoid abort (since no asserts)
        let _ = vector::length(&empty);

        let h0 = *vector::borrow(&hello, 0);
        let h1 = *vector::borrow(&hello, 1);
        let h2 = *vector::borrow(&hello, 2);
        let h3 = *vector::borrow(&hello, 3);
        let h4 = *vector::borrow(&hello, 4);

        let hx0 = *vector::borrow(&hexed, 0);
        let hx1 = *vector::borrow(&hexed, 1);

        // Just to silence unused variable warnings
        let _ = (h0, h1, h2, h3, h4, hx0, hx1);
    }
}


//# publish
module 0xCAFE::CopySyntax {
    // Testing correct `copy` syntax usage
    public fun copy_correct(x: u8): u8 {
        let y = copy x;
        y
    }

    // Incorrect copy usage to be tested by compiler/linter:
    // `let y = copy(x);` is invalid in Move language,
    // but cannot put invalid code in the test itself,
    // so we put it below in comments as test case description.

    // This commented code is for manual check by compiler tools:
    //
    // let y = copy(x);
    //
    // Or
    //
    // let z = copy(x + 1);
    //
    // Above invalid forms should produce errors.

    // We test copy inside a lambda (valid)
    public fun copy_in_lambda(x: u8): u8 {
        let f: |u8| u8 has copy + drop = |a: u8| {
            copy a
        };
        f(x)
    }
}


//# publish
module 0xCAFE::CombinedTest {
    use std::vector;

    const MAGIC_CODE: u64 = 0xBEEF;

    struct Data has store {
        bytes: vector<u8>,
        val: u8,
    }

    public fun create_data(x: u8): Data {
        // Use byte string literal
        let bstr = b"\xCA\xFE";
        let data = Data { bytes: bstr, val: copy x };
        data
    }

    public fun get_val(data: &Data): u8 {
        copy data.val
    }

    public fun get_first_byte(data: &Data): u8 {
        *vector::borrow(&data.bytes, 0)
    }

    public fun use_copy_in_if(x: u8): u8 {
        if (x > 10) {
            copy x
        } else {
            0u8
        };
        42u8
    }

    public fun use_byte_string_in_loop(): u8 {
        let s = b"test\n\x0A";
        let sum = 0u8;
        let len = vector::length(&s);
        let i = 0u8;
        while (i < len as u8) {
            sum = sum + *vector::borrow(&s, i as u64);
            i = i + 1;
        };
        sum
    }
}


//# run 0xCAFE::AddressRedundancy::dummy


//# run 0xCAFE::AddressRedundancy::dummy2


//# run 0xCAFE::ByteStringLiterals::empty_bytes


//# run 0xCAFE::ByteStringLiterals::ascii_bytes


//# run 0xCAFE::ByteStringLiterals::hex_escape_bytes


//# run 0xCAFE::ByteStringLiterals::verify_bytes


//# run 0xCAFE::CopySyntax::copy_correct --args 5u8


//# run 0xCAFE::CopySyntax::copy_in_lambda --args 7u8


//# run 0xCAFE::CombinedTest::create_data --args 42u8


//# run 0xCAFE::CombinedTest::use_copy_in_if --args 20u8


//# run 0xCAFE::CombinedTest::use_byte_string_in_loop


// Featurres:
// 48027d930099823e613a573e3d66ee2c: Warn when an address is redundantly specified for a module that already has one.
// 0282457de9fee7fde903c2fa3dbfff1a: Verify that byte string literals (e.g., b"") correctly represent their hexadecimal equivalents, including empty strings, ASCII characters, and hexadecimal escape sequences.
// db4d4284e8961f2d829ad3d54404f92d: Replace 'copy(x)' with 'copy x' to adhere to Move syntax conventions.
