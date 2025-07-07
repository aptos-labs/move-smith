//# publish
module 0xCAFE::LargeArgsTest {
    // This module tests a function with 66 u64 arguments summing all to verify argument passing and summation.

    public inline fun inc(a: u64): u64 {
        a + 1
    }

    public fun takes_66_args(
        a1: u64,  a2: u64,  a3: u64,  a4: u64,  a5: u64,  a6: u64,  a7: u64,  a8: u64,  a9: u64,
        a10: u64, a11: u64, a12: u64, a13: u64, a14: u64, a15: u64, a16: u64, a17: u64, a18: u64,
        a19: u64, a20: u64, a21: u64, a22: u64, a23: u64, a24: u64, a25: u64, a26: u64, a27: u64,
        a28: u64, a29: u64, a30: u64, a31: u64, a32: u64, a33: u64, a34: u64, a35: u64, a36: u64,
        a37: u64, a38: u64, a39: u64, a40: u64, a41: u64, a42: u64, a43: u64, a44: u64, a45: u64,
        a46: u64, a47: u64, a48: u64, a49: u64, a50: u64, a51: u64, a52: u64, a53: u64, a54: u64,
        a55: u64, a56: u64, a57: u64, a58: u64, a59: u64, a60: u64, a61: u64, a62: u64, a63: u64,
        a64: u64, a65: u64, a66: u64
    ): u64 {
        let sum: u64 = a1 + a2 + a3 + a4 + a5 + a6 + a7 + a8 + a9
                          + a10 + a11 + a12 + a13 + a14 + a15 + a16 + a17 + a18
                          + a19 + a20 + a21 + a22 + a23 + a24 + a25 + a26 + a27
                          + a28 + a29 + a30 + a31 + a32 + a33 + a34 + a35 + a36
                          + a37 + a38 + a39 + a40 + a41 + a42 + a43 + a44 + a45
                          + a46 + a47 + a48 + a49 + a50 + a51 + a52 + a53 + a54
                          + a55 + a56 + a57 + a58 + a59 + a60 + a61 + a62 + a63
                          + a64 + a65 + a66;
        sum
    }

    // Test function combining function calls, inline functions, closures, and tuples
    public fun complex_test(x: u8, y: bool): u8 {
        let val1 = inc(10u64) as u8;
        let val2 = if (y) { 20u8 } else { 30u8 };
        let my_lambda: |u8, u8| u8 has copy + drop = |a: u8, b: u8| {
            let sum = a + b;
            sum
        };
        let res1 = my_lambda(val1, val2);
        let (a, b) = (res1, 100u8);
        a + b + x
    }

    // Function demonstrating negated visibility (private)
    fun private_function_no_args(): u8 {
        42u8
    }

    // Public function that uses private function internally
    public fun call_private_function(): u8 {
        private_function_no_args()
    }
}

//# run 0xCAFE::LargeArgsTest::takes_66_args --args 1u64 1u64 1u64 1u64 1u64 1u64 1u64 1u64 1u64 1u64 1u64 1u64 1u64 1u64 1u64 1u64 1u64 1u64 1u64 1u64 1u64 1u64 1u64 1u64 1u64 1u64 1u64 1u64 1u64 1u64 1u64 1u64 1u64 1u64 1u64 1u64 1u64 1u64 1u64 1u64 1u64 1u64 1u64 1u64 1u64 1u64 1u64 1u64 1u64 1u64 1u64 1u64 1u64 1u64 1u64 1u64 1u64 1u64 1u64 1u64 1u64 1u64 1u64 1u64 1u64

//# run 0xCAFE::LargeArgsTest::complex_test --args 7u8 true

//# run 0xCAFE::LargeArgsTest::call_private_function

// Featurres:
// d10d1d4d747510bfe5df019e61145382: Verify that the function `takes_66_args` correctly sums 66 u64 arguments and that calling it with 66 ones returns 66.
// f1d96b651080ac0705569fa50013eef4: Test the correct functioning of function calls, inline functions, and closures, including handling of parameters, tuples, and variable assignment.
// 85d3ad6b84a3469f537b7e6d0ab2537f: Negate visibility with appropriate syntax in access specifiers.
