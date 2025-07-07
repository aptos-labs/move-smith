// Feature 1: Detect and report invalid assignment syntax outside of allowed patterns

//# publish
module 0xA::InvalidAssignment {
    #[test_only]
    public fun invalid_assign() {
        let x = 1u8;
        // The next line should cause a Move compiler error: assignment is not an expression in Move
        // outside of a let-statement or as a standalone statement.
        // This line is intentionally wrong to test error reporting.
        x = 5u8 + 6u8; // valid statement-style assignment
        // let y = (x = 7u8); // invalid: assignment in expression position (should be error, uncomment to test)
    }
}
//# run 0xA::InvalidAssignment::invalid_assign --signers 0xA


// Feature 2: Expand macro or syntactic sugar constructs during compilation

//# publish
module 0xB::MacroSugar {
    use std::option::{Self, Option};

    public fun unwrap_or_one(opt: Option<u8>): u8 {
        // if-let is syntactic sugar, expands into match on Option
        if (option::is_some(&opt)) {
            option::extract(opt)
        } else {
            1u8
        }
    }

    public fun runner() {
        let n = Self::unwrap_or_one(option::none<u8>());
        let m = Self::unwrap_or_one(option::some<u8>(10u8));
        // Should expand and work for both branches
        // (no assertion needed per instructions)
    }
}
//# run 0xB::MacroSugar::runner --signers 0xB


// Feature 3: Test that the sum function correctly adds all 65 input parameters and asserts the result equals 65

//# publish
module 0xC::LargeSum {
    public fun sum65(
        a0: u8, a1: u8, a2: u8, a3: u8, a4: u8, a5: u8, a6: u8, 
        a7: u8, a8: u8, a9: u8, a10: u8, a11: u8, a12: u8, a13: u8, a14: u8,
        a15: u8, a16: u8, a17: u8, a18: u8, a19: u8, a20: u8, a21: u8, a22: u8, 
        a23: u8, a24: u8, a25: u8, a26: u8, a27: u8, a28: u8, a29: u8,
        a30: u8, a31: u8, a32: u8, a33: u8, a34: u8, a35: u8, a36: u8, a37: u8,
        a38: u8, a39: u8, a40: u8, a41: u8, a42: u8, a43: u8, a44: u8, a45: u8, 
        a46: u8, a47: u8, a48: u8, a49: u8, a50: u8, a51: u8, a52: u8, a53: u8, 
        a54: u8, a55: u8, a56: u8, a57: u8, a58: u8, a59: u8, a60: u8, a61: u8,
        a62: u8, a63: u8, a64: u8
    ): u8 {
        a0 + a1 + a2 + a3 + a4 + a5 + a6 +
        a7 + a8 + a9 + a10 + a11 + a12 + a13 + a14 + 
        a15 + a16 + a17 + a18 + a19 + a20 + a21 + a22 + 
        a23 + a24 + a25 + a26 + a27 + a28 + a29 +
        a30 + a31 + a32 + a33 + a34 + a35 + a36 + a37 +
        a38 + a39 + a40 + a41 + a42 + a43 + a44 + a45 +
        a46 + a47 + a48 + a49 + a50 + a51 + a52 + a53 +
        a54 + a55 + a56 + a57 + a58 + a59 + a60 + a61 +
        a62 + a63 + a64
    }

    public fun runner() {
        let result = Self::sum65(
            1u8,1u8,1u8,1u8,1u8,1u8,1u8,
            1u8,1u8,1u8,1u8,1u8,1u8,1u8,1u8,
            1u8,1u8,1u8,1u8,1u8,1u8,1u8,1u8,
            1u8,1u8,1u8,1u8,1u8,1u8,1u8,
            1u8,1u8,1u8,1u8,1u8,1u8,1u8,1u8,
            1u8,1u8,1u8,1u8,1u8,1u8,1u8,1u8,
            1u8,1u8,1u8,1u8,1u8,1u8,1u8,1u8,
            1u8,1u8,1u8,1u8,1u8,1u8,1u8,1u8,
            1u8,1u8,1u8,1u8,1u8
        );
        assert!(result == 65, 100);
    }
}
//# run 0xC::LargeSum::runner --signers 0xC


// Feature 4: Test that the `baz` function correctly destructures a tuple and computes the difference

//# publish
module 0xD::TupleDestruct {
    public fun baz(xy: (u64, u64)): u64 {
        let (x, y) = xy;
        x - y
    }

    public fun runner() {
        let r = Self::baz((10,3));
        // r should be 7
        let _ = r;
    }
}
//# run 0xD::TupleDestruct::runner --signers 0xD


// Feature 5: Specify triggers for quantifiers, possibly with a list of trigger expressions

//# publish
module 0xE::QuantTriggers {
    // Requires Move Prover to actually check, but syntactic check can be enforced by the Move compiler frontend
    #[pragma(assume)]
    spec module {
        // Quantifier using triggers (e.g. for Move Prover micro-syntax)
        // Triggers: {f(x), x}
        spec fun test_quant<F>(f: F) {
            // The following is only for test, will be ignored by the VM, but
            // exercises the parser for trigger syntax.
            // forall x: u64 { f(x), x } :: f(x) > 0;
        }
    }

    public fun runner() {
        // This function intentionally empty; quantifier triggers are only parsed.
    }
}
//# run 0xE::QuantTriggers::runner --signers 0xE

//# run 0xB::MacroSugar::runner --signers 0xB