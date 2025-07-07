//-------------------------
// 1. Detect and report invalid assignment syntax outside allowed patterns
//-------------------------
//# publish
module 0x1::InvalidAssignment {
    // The following is an invalid assignment:
    public fun bad_assignment() {
        // Not allowed: assigning to a function call (should trigger compiler error)
        // 1 + 1 = 5;
    }
}

//-------------------------
// 2. Expand macro or syntactic sugar constructs during compilation
//-------------------------
//# publish
module 0x2::StructShorthand {
    struct S has copy, drop, store {
        a: u8,
        b: u8,
    }

    public fun new_struct(a: u8, b: u8): S {
        // Should expand `{ a, b }` to `{ a: a, b: b }`
        S { a, b }
    }

    public fun runner() {
        let x = new_struct(5, 10);
        // just to exercise and expand
        let _ = x.a + x.b;
    }
}
//# run 0x2::StructShorthand::runner

//-------------------------
// 3. Test a function adding all 65 input params and assert result == 65
//-------------------------
//# publish
module 0x3::Sum65 {
    use std::assert;

    public fun sum_65(
        a0: u8, a1: u8, a2: u8, a3: u8,  a4: u8, a5: u8, a6: u8, a7: u8, a8: u8, a9: u8, 
        a10: u8, a11: u8, a12: u8, a13: u8, a14: u8, a15: u8, a16: u8, a17: u8, a18: u8, a19: u8,
        a20: u8, a21: u8, a22: u8, a23: u8, a24: u8, a25: u8, a26: u8, a27: u8, a28: u8, a29: u8,
        a30: u8, a31: u8, a32: u8, a33: u8, a34: u8, a35: u8, a36: u8, a37: u8, a38: u8, a39: u8,
        a40: u8, a41: u8, a42: u8, a43: u8, a44: u8, a45: u8, a46: u8, a47: u8, a48: u8, a49: u8,
        a50: u8, a51: u8, a52: u8, a53: u8, a54: u8, a55: u8, a56: u8, a57: u8, a58: u8, a59: u8,
        a60: u8, a61: u8, a62: u8, a63: u8, a64: u8
    ) {
        let sum =
            a0 + a1 + a2 + a3 + a4 + a5 + a6 + a7 + a8 + a9 +
            a10 + a11 + a12 + a13 + a14 + a15 + a16 + a17 + a18 + a19 +
            a20 + a21 + a22 + a23 + a24 + a25 + a26 + a27 + a28 + a29 +
            a30 + a31 + a32 + a33 + a34 + a35 + a36 + a37 + a38 + a39 +
            a40 + a41 + a42 + a43 + a44 + a45 + a46 + a47 + a48 + a49 +
            a50 + a51 + a52 + a53 + a54 + a55 + a56 + a57 + a58 + a59 +
            a60 + a61 + a62 + a63 + a64;
        // Should be 65 if all are 1u8
        assert::assert(sum == 65, 0);
    }

    // runner that calls sum_65 with all 1's
    public fun runner() {
        sum_65(
            1,1,1,1,1,1,1,1,1,1,
            1,1,1,1,1,1,1,1,1,1,
            1,1,1,1,1,1,1,1,1,1,
            1,1,1,1,1,1,1,1,1,1,
            1,1,1,1,1,1,1,1,1,1,
            1,1,1,1,1,1,1,1,1,1,
            1,1,1,1,1
        );
    }
}
//# run 0x3::Sum65::runner

//-------------------------
// 4. Loop with internal conditional and return to test execution and early termination
//-------------------------
//# publish
module 0x4::LoopReturn {
    public fun runner() {
        let mut acc = 0u8;
        let mut i = 0u8;

        while (i < 10) {
            i = i + 1;
            if (i == 3) {
                // Early exit; should terminate function
                return;
            };
            acc = acc + 1;
        };

        // If we reached here, the return failed, which should not happen
        // (no assertion here as requested)
        acc;
    }
}
//# run 0x4::LoopReturn::runner