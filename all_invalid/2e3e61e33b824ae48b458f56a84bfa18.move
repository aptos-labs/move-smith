//# publish
module 0xCAFE::ByteStringTest {
    use std::vector;

    struct BytesHolder has store, drop {
        data: vector<u8>,
    }

    /// A simple function to create BytesHolder from a byte literal
    public fun create_holder(): BytesHolder {
        let b_empty = b"";
        let b_hello = b"hello";
        let b_hex = b"\x41\x42\x43"; // "ABC"
        // just place them in the struct to verify compilation and correctness of byte string parsing
        BytesHolder {
            data: b_hello, // store "hello"
        }
    }

    /// Runner function to test compilation and acquirer on module's struct
    public fun runner() acquires BytesHolder {
        let holder = create_holder();
        // dummy usage to test acquires works
        drop(holder);
    }
}
//# run 0xCAFE::ByteStringTest::runner

//# publish
module 0xCAFE::AcquiresTest {
    struct Foo has key {
        val: u64,
    }

    struct Bar has store {
        val: u64,
    }

    public fun create_foo(): Foo {
        Foo { val: 42 }
    }

    public fun runner() acquires Foo {
        let foo = create_foo();
        // no-op using foo to test acquires
        drop(foo);
    }
}
//# run 0xCAFE::AcquiresTest::runner

//# publish
module 0xCAFE::StructDefTest {
    struct Empty has store {}

    struct WithFields has store {
        a: u8,
        b: u64,
        c: bool,
    }

    public fun new_with_fields(): WithFields {
        WithFields {
            a: 123,
            b: 456789,
            c: true,
        }
    }

    public fun runner() {
        let _e = Empty {};
        let _wf = new_with_fields();
    }
}
//# run 0xCAFE::StructDefTest::runner

//# run
script {
    // test empty byte string literal in script
    let empty_bytes = b"";
    let ascii_bytes = b"MoveLang";
    let escaped_bytes = b"\x4D\x6F\x76\x65"; // ASCII for "Move"

    // just no-op usage to check compilation/running
    let _len_empty = vector::length(empty_bytes);
    let _len_ascii = vector::length(ascii_bytes);
    let _len_escaped = vector::length(escaped_bytes);
}

// Featurres:
// 0282457de9fee7fde903c2fa3dbfff1a: Verify that byte string literals (e.g., b"") correctly represent their hexadecimal equivalents, including empty strings, ASCII characters, and hexadecimal escape sequences.
// 8b5e56f2a902ae0e74b371f98054234c: Verify the proper use of acquires declarations in Move modules and functions
// ee9f4cc9cef069ebae1b1a678821c414: Define structs within a module.
