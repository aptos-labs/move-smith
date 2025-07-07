
//# publish
module 0xCAFE::NumericAndCopyTest {
    use std::signer;

    struct A has copy, drop, store {
        val: u8,
    }

    // pragma(inline)]
    public fun identity_u8(x: u8): u8 {
        x
    }

    // pragma(inline)]
    public fun identity_struct(a: A): A {
        // This will test copying a struct with copy ability
        a
    }

    // pragma(unused)]
    public fun test_literals(): (u8, u16, u32, u64, u128) {
        let u8_val: u8 = 42u8;
        let u16_val: u16 = 65535u16;
        let u32_val: u32 = 2_000_000_000u32;
        let u64_val: u64 = 9_223_372_036_854_775_807u64; // max positive value under unsigned 64 bit is bigger, but just a large number
        let u128_val: u128 = 340282366920938463463374607431768211455u128; // max u128
        (u8_val, u16_val, u32_val, u64_val, u128_val)
    }

    // pragma(inline)]
    public fun take_and_return_u8(x: u8): u8 {
        let y = x;
        y
    }

    public fun pass_and_return_struct() {
        let a = A {val: 7u8};
        let b = identity_struct(a);
        let _z = b.val;
    }

    public fun pass_primitive_to_other_function() {
        let n = 100u8;
        let res = identity_u8(n);
        let _ = res;
    }

    public fun runner() {
        let _ = test_literals();
        pass_and_return_struct();
        pass_primitive_to_other_function();
        let single = take_and_return_u8(255u8);
        let _ = single;
    }
}


//# run 0xCAFE::NumericAndCopyTest::runner


// Featurres:
// 50491a6bc8926e957907e98af5cd840d: Write number literals for integer and numeric values within the allowable size for their type.
// 288bbb53f3cfc5904d75300b1e72169b: Test that copying and passing primitive and struct values to functions behaves correctly without unintended side effects.
// 4e5ab487355189f82f7efc6eefaa2ae8: Use '#[pragma ...]' annotations in your Move code to specify compiler or verifier directives.
