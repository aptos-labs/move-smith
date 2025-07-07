//# publish
module 0x1::InvalidAssignment {
    // Test 1: Detect and report invalid assignment syntax outside allowed patterns.
    // The line below is invalid: cannot assign to a numeric literal on the LHS.
    fun invalid() {
        // The following should cause a compiler error due to invalid assignment.
        123 = 5;
    }
}

//# publish
module 0x1::MacroExpansionTest {
    // Test 2: Expand macro or syntactic sugar constructs during compilation.

    // This tests tuple destructuring, which is syntactic sugar.
    public fun tuple_destructuring_expansion(): u8 {
        let (a, b, c) = (1u8, 2u8, 3u8);
        // The desugaring should happen in compilation:
        // let tmp = (1u8, 2u8, 3u8);
        // let a = tmp.0; let b = tmp.1; let c = tmp.2;
        a + b + c
    }
}

//# run 0x1::MacroExpansionTest::tuple_destructuring_expansion

//# publish
module 0x1::Sum65 {
    // Test 3: Test that a sum function adds all 65 parameters and asserts the result equals 65.
    use std::debug;

    public fun sum_65(
        a1: u8, a2: u8, a3: u8, a4: u8, a5: u8, a6: u8, a7: u8, a8: u8, a9: u8, a10: u8,
        a11: u8, a12: u8, a13: u8, a14: u8, a15: u8, a16: u8, a17: u8, a18: u8, a19: u8, a20: u8,
        a21: u8, a22: u8, a23: u8, a24: u8, a25: u8, a26: u8, a27: u8, a28: u8, a29: u8, a30: u8,
        a31: u8, a32: u8, a33: u8, a34: u8, a35: u8, a36: u8, a37: u8, a38: u8, a39: u8, a40: u8,
        a41: u8, a42: u8, a43: u8, a44: u8, a45: u8, a46: u8, a47: u8, a48: u8, a49: u8, a50: u8,
        a51: u8, a52: u8, a53: u8, a54: u8, a55: u8, a56: u8, a57: u8, a58: u8, a59: u8, a60: u8,
        a61: u8, a62: u8, a63: u8, a64: u8, a65: u8
    ): u8 {
        let sum: u8 = 
            a1+a2+a3+a4+a5+a6+a7+a8+a9+a10+
            a11+a12+a13+a14+a15+a16+a17+a18+a19+a20+
            a21+a22+a23+a24+a25+a26+a27+a28+a29+a30+
            a31+a32+a33+a34+a35+a36+a37+a38+a39+a40+
            a41+a42+a43+a44+a45+a46+a47+a48+a49+a50+
            a51+a52+a53+a54+a55+a56+a57+a58+a59+a60+
            a61+a62+a63+a64+a65;
        assert!(sum == 65, 0);
        sum
    }

    // For easier testing, a runner function to call sum_65 with all ones
    public fun test_runner(): u8 {
        Self::sum_65(
            1,1,1,1,1,1,1,1,1,1,
            1,1,1,1,1,1,1,1,1,1,
            1,1,1,1,1,1,1,1,1,1,
            1,1,1,1,1,1,1,1,1,1,
            1,1,1,1,1,1,1,1,1,1,
            1,1,1,1,1,1,1,1,1,1,
            1,1,1,1,1
        )
    }
}

//# run 0x1::Sum65::test_runner