
//# publish
module 0xCAFE::AdvancedFeatures {
    use std::vector;
    use std::signer;

    struct Container has copy, drop, store {
        values: vector<u8>,
    }

    public fun create_container(): Container {
        let vals = vector::empty<u8>();
        vector::push_back(&mut vals, 10);
        vector::push_back(&mut vals, 20);
        Container { values: vals }
    }

    // Test optional trailing commas in access specifier lists for functions and structs.
    // Note: In Move language spec as of now, trailing commas in access specifier list are not a thing,
    // but we simulate by having a trailing comma in struct fields list and parameter lists where allowed.
    // We use trailing comma in function parameters and fields that are allowed by spec.
    // Here we just put a trailing comma in struct fields and function parameter lists where legal.
    // (This is to test compiler allowing these commas.)

    struct TrailingCommaStruct has copy, drop, store {
        a: u8,
        b: u16,
    }

    public fun test_trailing_commas(
        x: u8,
        y: u8,
    ): u8 {
        // Simple body to test trailing commas in parameters and statements.
        let s = TrailingCommaStruct { a: x, b: (y as u16), };
        s.a + (s.b as u8)
    }

    // Create name access chains with optional wildcards.
    // Since Move does not have regex or advanced wildcard in names,
    // we test with module::struct, module::* features (wildcard imports).
    // We do a use with wildcard and access items.

    public fun use_wildcard_import(): u8 {
        // Remove wildcard import since Move does not support wildcard importing.
        // Instead, directly use signer::address_of and create a signer reference.
        let dummy_signer = signer::spec_signer();
        let addr = signer::address_of(&dummy_signer);
        1u8
    }

    // Write code blocks (sequences) comprising multiple statements and an optional final expression.

    public fun code_block_test(x: u8): u8 {
        {
            let a = x + 1;
            let b = a * 2;
            let c = b / 3;
            c
        }
    }

    public fun code_block_no_final_expr(x: u8): u8 {
        {
            let a = x + 5;
            let b = a + 10;
        };
        99u8
    }
}



//# run 0xCAFE::AdvancedFeatures::test_trailing_commas --args 5u8 6u8



//# run 0xCAFE::AdvancedFeatures::use_wildcard_import



//# run 0xCAFE::AdvancedFeatures::code_block_test --args 7u8



//# run 0xCAFE::AdvancedFeatures::code_block_no_final_expr --args 3u8
