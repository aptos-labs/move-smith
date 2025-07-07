
//# publish
module 0xCAFE::LambdaAndInline {
    // Module to test lambda expressions and inline function calls

    public fun apply_lambda(x: u8): u8 {
        let lambda: |u8| u8 has copy+drop = |a: u8| {
            a + 10
        };
        lambda(x)
    }

    public inline fun inline_addition(a: u64, b: u64): u64 {
        a + b
    }

    public fun nested_inline_call(a: u64, b: u64, c: u64): u64 {
        let sum_ab = inline_addition(a, b);
        inline_addition(sum_ab, c)
    }
}




//# run 0xCAFE::LambdaAndInline::apply_lambda --args 5u8




//# run 0xCAFE::LambdaAndInline::nested_inline_call --args 1u64 2u64 3u64




//# publish
module 0xCAFE::Function66Args {
    // Module to test a function that takes exactly 66 u64 arguments and sums them all
    
    public fun takes_66_args(
        a0: u64, a1: u64, a2: u64, a3: u64, a4: u64, a5: u64, a6: u64, a7: u64, a8: u64, a9: u64,
        a10: u64, a11: u64, a12: u64, a13: u64, a14: u64, a15: u64, a16: u64, a17: u64, a18: u64, a19: u64,
        a20: u64, a21: u64, a22: u64, a23: u64, a24: u64, a25: u64, a26: u64, a27: u64, a28: u64, a29: u64,
        a30: u64, a31: u64, a32: u64, a33: u64, a34: u64, a35: u64, a36: u64, a37: u64, a38: u64, a39: u64,
        a40: u64, a41: u64, a42: u64, a43: u64, a44: u64, a45: u64, a46: u64, a47: u64, a48: u64, a49: u64,
        a50: u64, a51: u64, a52: u64, a53: u64, a54: u64, a55: u64, a56: u64, a57: u64, a58: u64, a59: u64,
        a60: u64, a61: u64, a62: u64, a63: u64, a64: u64, a65: u64
    ): u64 {
        // sum all 66 args
        a0 + a1 + a2 + a3 + a4 + a5 + a6 + a7 + a8 + a9 +
        a10 + a11 + a12 + a13 + a14 + a15 + a16 + a17 + a18 + a19 +
        a20 + a21 + a22 + a23 + a24 + a25 + a26 + a27 + a28 + a29 +
        a30 + a31 + a32 + a33 + a34 + a35 + a36 + a37 + a38 + a39 +
        a40 + a41 + a42 + a43 + a44 + a45 + a46 + a47 + a48 + a49 +
        a50 + a51 + a52 + a53 + a54 + a55 + a56 + a57 + a58 + a59 +
        a60 + a61 + a62 + a63 + a64 + a65
    }
}




//# run 0xCAFE::Function66Args::takes_66_args --args 1u64 1u64 1u64 1u64 1u64 1u64 1u64 1u64 1u64 1u64 1u64 1u64 1u64 1u64 1u64 1u64 1u64 1u64 1u64 1u64 1u64 1u64 1u64 1u64 1u64 1u64 1u64 1u64 1u64 1u64 1u64 1u64 1u64 1u64 1u64 1u64 1u64 1u64 1u64 1u64 1u64 1u64 1u64 1u64 1u64 1u64 1u64 1u64 1u64 1u64 1u64 1u64 1u64 1u64 1u64 1u64 1u64 1u64 1u64 1u64 1u64 1u64 1u64 1u64 1u64 1u64 1u64 1u64




//# publish
module 0xCAFE::ValueExpressions {
    // This module tests the usage of the `value` expression by creating simple values

    public fun create_value_bool(): bool {
        true
    }

    public fun create_value_u8(): u8 {
        123u8
    }

    public fun create_value_u64(): u64 {
        9876543210u64
    }

    public fun create_value_address(): address {
        @0xCAFE
    }
}




//# run 0xCAFE::ValueExpressions::create_value_bool




//# run 0xCAFE::ValueExpressions::create_value_u8




//# run 0xCAFE::ValueExpressions::create_value_u64




//# run 0xCAFE::ValueExpressions::create_value_address




//# run --signers 0xCAFE
script {
    use std::vector;
    use std::signer;

    fun main(account: signer) {
        let v = vector::empty<u8>();
        // Now mutable vector
        let r = &v;
        // Get mutable reference
        let r_mut = &mut v;
        // This line now is allowed because we have a mutable vector and a mutable reference to it
        vector::push_back(r_mut, 42u8);
    }
}
