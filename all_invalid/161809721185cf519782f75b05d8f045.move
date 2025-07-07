//# publish
module 0xCAFE::Patterns {
    // This module defines helper functions to demonstrate pattern matching with multiple patterns and type annotations.

    struct Dummy has copy, drop, store { val: u8 }

    /// A function that accepts multiple pattern-matched tuples separated by commas.
    /// Demonstrates multiple pattern branches.
    public fun match_multiple_patterns(x: u8): u8 {
        // Match with multiple patterns separated by commas.
        // Since Move does not have full pattern matching expressions like Rust,
        // we simulate matching with if-else branches and destructuring.
        if (x == 1 || x == 2) {
            10
        } else if (x == 3 || x == 4) {
            20
        } else {
            0
        }
    }

    /// A function to test annotated expressions.
    public fun annotated_expr(): u8 {
        // Annotate sub-expressions with types using colon syntax
        let a: u8 = 10;
        let b: u8 = 20;
        let c: u8 = a + b;
        c
    }

    /// Runner function to test the above features easily.
    public fun runner(): u8 {
        let res1 = match_multiple_patterns(1u8);
        let res2 = match_multiple_patterns(3u8);
        let res3 = annotated_expr();
        res1 + res2 + res3
    }
}
//# run 0xCAFE::Patterns::runner

//# publish
module 0xCAFE::MaxArgs {
    /// Defines a function with 65 u8 arguments.
    public fun fifty_five_args(
        a0: u8,  a1: u8,  a2: u8,  a3: u8,  a4: u8,
        a5: u8,  a6: u8,  a7: u8,  a8: u8,  a9: u8,
        a10: u8, a11: u8, a12: u8, a13: u8, a14: u8,
        a15: u8, a16: u8, a17: u8, a18: u8, a19: u8,
        a20: u8, a21: u8, a22: u8, a23: u8, a24: u8,
        a25: u8, a26: u8, a27: u8, a28: u8, a29: u8,
        a30: u8, a31: u8, a32: u8, a33: u8, a34: u8,
        a35: u8, a36: u8, a37: u8, a38: u8, a39: u8,
        a40: u8, a41: u8, a42: u8, a43: u8, a44: u8,
        a45: u8, a46: u8, a47: u8, a48: u8, a49: u8,
        a50: u8, a51: u8, a52: u8, a53: u8, a54: u8,
        a55: u8, a56: u8, a57: u8, a58: u8, a59: u8,
        a60: u8, a61: u8, a62: u8, a63: u8, a64: u8
    ): u64 {
        // Sum all arguments as u64 and return result
        let sum = (a0 + a1 + a2 + a3 + a4) as u64 +
            (a5 + a6 + a7 + a8 + a9) as u64 +
            (a10 + a11 + a12 + a13 + a14) as u64 +
            (a15 + a16 + a17 + a18 + a19) as u64 +
            (a20 + a21 + a22 + a23 + a24) as u64 +
            (a25 + a26 + a27 + a28 + a29) as u64 +
            (a30 + a31 + a32 + a33 + a34) as u64 +
            (a35 + a36 + a37 + a38 + a39) as u64 +
            (a40 + a41 + a42 + a43 + a44) as u64 +
            (a45 + a46 + a47 + a48 + a49) as u64 +
            (a50 + a51 + a52 + a53 + a54) as u64 +
            (a55 + a56 + a57 + a58 + a59) as u64 +
            (a60 + a61 + a62 + a63 + a64) as u64;
        sum
    }


    /// A function that returns a closure that captures no environment but calls fifty_five_args with all args == 1u8.
    public fun get_closure(): (fun(): u64) {
        // Closure that calls fifty_five_args with 1u8 for all 65 args.
        fun closure(): u64 {
            MaxArgs::fifty_five_args(
                1,1,1,1,1,
                1,1,1,1,1,
                1,1,1,1,1,
                1,1,1,1,1,
                1,1,1,1,1,
                1,1,1,1,1,
                1,1,1,1,1,
                1,1,1,1,1,
                1,1,1,1,1,
                1,1,1,1,1,
                1,1,1,1,1,
                1,1,1,1,1,
                1,1,1,1,1
            )
        }
        closure
    }

    /// Runner function that tests direct call and closure call of fifty_five_args
    public fun runner(): u64 {
        let direct = fifty_five_args(
            1,1,1,1,1,
            1,1,1,1,1,
            1,1,1,1,1,
            1,1,1,1,1,
            1,1,1,1,1,
            1,1,1,1,1,
            1,1,1,1,1,
            1,1,1,1,1,
            1,1,1,1,1,
            1,1,1,1,1,
            1,1,1,1,1,
            1,1,1,1,1,
            1,1,1,1,1
        );
        let closure = get_closure();
        let closure_result = closure();
        direct + closure_result // Expect 130 (65+65) u64 = 130
    }
}
//# run 0xCAFE::MaxArgs::runner

// Featurres:
// efe6f0219832d041cc27de82eac89a11: Define patterns to specify which parts of the expression the rule applies to, separated by commas.
// 5f869b549fde17cd795d12789f578890: Annotate expressions with types using the colon syntax (e: Type).
// 8b36891ef406a8cef3a48292c49c1f93: Test that a function can correctly accept and evaluate with 65 arguments, and that such a function can be invoked through a closure.
