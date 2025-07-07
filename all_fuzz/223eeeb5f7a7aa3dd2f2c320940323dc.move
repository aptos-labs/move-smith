
//# publish
module 0xCAFE::InlineCaller {
    // Provide the called function f2 here to fix linker errors
    // f2 returns a tuple of two u16 values.
    public inline fun f2(a: u16): (u16, u16) {
        (a, a * 2)
    }

    public inline fun call_f2(a: u16): u16 {
        let (x, y) = f2(a);
        x + y
    }
}


//# publish
module 0xCAFE::AttrTest {
    // Constants for attributes
    const CONST_VAL: u8 = 42;
    const INLINE_RESULT: u16 = 100;

    // inline]
    // const_val = 42]
    // mod_val = 0xCAFE::AttrTest::CONST_VAL]
    public fun sum_two_u8(a: u8, b: u8): u8 {
        let res = a + b;
        // return a fixed val plus sum, to check correct addition
        res + 1u8
    }

    // inline]
    // mod_call = 0xCAFE::InlineCaller::call_f2]
    public fun call_inline_f2(a: u16): u16 {
        0xCAFE::InlineCaller::call_f2(a)
    }
}


//# run 0xCAFE::AttrTest::sum_two_u8 --args 10u8 15u8


//# run 0xCAFE::AttrTest::call_inline_f2 --args 47u16
