//# publish
module 0xCAFE::MultipleTypes {
    // This module defines multiple different types in sequence to test compiler handling of multiple type declarations.
    struct A has copy, drop, store, key {
        val: u8,
    }

    struct B has copy, drop, store, key {
        inner: A,
    }

    struct C has copy, drop, store, key {
        x: u16,
        y: u16,
    }

    struct D<T> has copy, drop {
        field: T,
    }

    const CONST_VAL: u64 = 0xCAFEBABE;

    public fun create_a(val: u8): A {
        A { val }
    }

    public fun create_b(val: u8): B {
        let a = create_a(val);
        B { inner: a }
    }

    public fun create_c(x: u16, y: u16): C {
        C { x, y }
    }

    public fun create_d_u8(val: u8): D<u8> {
        D { field: val }
    }

    public fun create_d_c(x: u16, y: u16): D<C> {
        let c = create_c(x, y);
        D { field: c }
    }

    public fun runner() {
        let _a = create_a(10u8);
        let _b = create_b(20u8);
        let _c = create_c(30u16, 40u16);
        let _d1 = create_d_u8(50u8);
        let _d2 = create_d_c(60u16, 70u16);
    }
}

//# run 0xCAFE::MultipleTypes::runner


//# publish
module 0xCAFE::EscapedStrings {
    // This module will test string literals with escaped characters.

    public fun get_escaped_quote_string(): vector<u8> {
        b"This is a string with an escaped quote: \" inside";
    }

    public fun get_escaped_backslash_string(): vector<u8> {
        b"This string contains a double backslash: \\\\ here";
    }

    public fun get_escaped_newline_tab_string(): vector<u8> {
        b"Line1\nLine2\tTabbed";
    }

    public fun runner() {
        let _q = get_escaped_quote_string();
        let _b = get_escaped_backslash_string();
        let _n = get_escaped_newline_tab_string();
    }
}

//# run 0xCAFE::EscapedStrings::runner


//# publish
module 0xCAFE::MinVersionFeatures {
    // This module deliberately uses features that require a minimum Move language version.
    // Example: `inline` is now standard, but let's also test loops and other constructs that may have version implications.

    public inline fun inline_function(x: u64): u64 {
        x * 2
    }

    public fun use_for_loop(): u64 {
        let mut sum = 0u64;
        for (i in 0..5) {
            sum = sum + i;
        };
        sum
    }

    public fun use_loop_with_break(): u64 {
        let mut counter = 5u64;
        let mut accum = 0u64;
        loop {
            accum = accum + counter;
            if (counter == 0) {
                break;
            };
            counter = counter - 1;
        };
        accum
    }

    public fun run_all(): (u64, u64, u64) {
        let a = inline_function(10u64);
        let b = use_for_loop();
        let c = use_loop_with_break();
        (a, b, c)
    }
}

//# run 0xCAFE::MinVersionFeatures::run_all

// Featurres:
// c423383e13619580fa0d6477f9a16cca: Create multiple types in a sequence with 'Multiple'.
// dd9eb9a3733e0e74b7e233c25e26ff6b: Write string literals that support escaped characters (such as \" and \\) inside the string.
// 81d7b796a8282833827611e111ad9db6: Use language constructs that require a minimum Move language version.
