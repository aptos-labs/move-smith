// This transactional test exercises the Move compiler and VM with:
// 1. Lexical scoping/capturing/shadowing via lambdas/inline functions.
// 2. Dotted expressions (struct field access).
// 3. Functions with the maximum possible number of parameters (65) and lambda captures.

//# publish
module 0xCAFE::ShadowAndFields {
    struct Point has copy, drop, store {
        x: u64,
        y: u64,
    }

    // 1. Test shadowing/capturing: pass inner function to 'foo' and capture/shadow 'x'
    public fun foo(mut x: u64, f: fun(&mut u64)) {
        f(&mut x); // function modifies x (by reference)
        // After foo: x should be updated in this scope
        let _ = x;
    }

    // Companion runner that tests shadowing/capturing.
    public fun runner() {
        let mut x = 1u64;
        let f = fun(p: &mut u64) {
            // Shadow x in inner scope (not strictly capturing, but updates &mut param).
            *p = 3;
        };
        Self::foo(x, f);
        // x here is still 1, because foo does not return new x.
        // To test outer variable update, pass &mut x:
        let mut outer = 1u64;
        let updater = fun(q: &mut u64) { *q = 3; };
        Self::foo(&mut outer, updater);
        assert!(outer == 3, 100);
    }

    // 2. Test field access (dotted expressions)
    public fun point_field_access(): u64 {
        let p = Point { x: 42, y: 15 };
        let xval = p.x;
        let yval = p.y;
        (xval + yval)
    }

    // 3. Function with 65 parameters (u8s), captured in a lambda.
    public fun sum_65(
        a0: u8, a1: u8, a2: u8, a3: u8, a4: u8, a5: u8, a6: u8, a7: u8, a8: u8, a9: u8,
        a10: u8, a11: u8, a12: u8, a13: u8, a14: u8, a15: u8, a16: u8, a17: u8, a18: u8, a19: u8,
        a20: u8, a21: u8, a22: u8, a23: u8, a24: u8, a25: u8, a26: u8, a27: u8, a28: u8, a29: u8,
        a30: u8, a31: u8, a32: u8, a33: u8, a34: u8, a35: u8, a36: u8, a37: u8, a38: u8, a39: u8,
        a40: u8, a41: u8, a42: u8, a43: u8, a44: u8, a45: u8, a46: u8, a47: u8, a48: u8, a49: u8,
        a50: u8, a51: u8, a52: u8, a53: u8, a54: u8, a55: u8, a56: u8, a57: u8, a58: u8, a59: u8,
        a60: u8, a61: u8, a62: u8, a63: u8, a64: u8
    ): u64 {
        // Capture all in a lambda, sum them, and return as u64
        let f = fun() : u64 {
            (a0 as u64) + (a1 as u64) + (a2 as u64) + (a3 as u64) + (a4 as u64) +
            (a5 as u64) + (a6 as u64) + (a7 as u64) + (a8 as u64) + (a9 as u64) +
            (a10 as u64) + (a11 as u64) + (a12 as u64) + (a13 as u64) + (a14 as u64) +
            (a15 as u64) + (a16 as u64) + (a17 as u64) + (a18 as u64) + (a19 as u64) +
            (a20 as u64) + (a21 as u64) + (a22 as u64) + (a23 as u64) + (a24 as u64) +
            (a25 as u64) + (a26 as u64) + (a27 as u64) + (a28 as u64) + (a29 as u64) +
            (a30 as u64) + (a31 as u64) + (a32 as u64) + (a33 as u64) + (a34 as u64) +
            (a35 as u64) + (a36 as u64) + (a37 as u64) + (a38 as u64) + (a39 as u64) +
            (a40 as u64) + (a41 as u64) + (a42 as u64) + (a43 as u64) + (a44 as u64) +
            (a45 as u64) + (a46 as u64) + (a47 as u64) + (a48 as u64) + (a49 as u64) +
            (a50 as u64) + (a51 as u64) + (a52 as u64) + (a53 as u64) + (a54 as u64) +
            (a55 as u64) + (a56 as u64) + (a57 as u64) + (a58 as u64) + (a59 as u64) +
            (a60 as u64) + (a61 as u64) + (a62 as u64) + (a63 as u64) + (a64 as u64)
        };
        f()
    }

    public fun runner_sum_65(): u64 {
        // All 1, so should get 65 as u64
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

//# run 0xCAFE::ShadowAndFields::runner

//# run 0xCAFE::ShadowAndFields::point_field_access

//# run 0xCAFE::ShadowAndFields::runner_sum_65

// Featurres:
// 5b419bfb309cdf2d1d8022392b3e2362: Verify that the inner function passed to 'foo' can correctly access and modify the outer variable 'x' through shadowing or capturing, ensuring the value of 'x' updates to 3 after the function call.
// 232b89599d79eae82e64e4ab36d5a3e8: Create dotted expressions involving field access.
// d0921d70165ce83b0824987f7aed05f4: Test that a function can have 65 parameters and that all of them are correctly captured and usable in a lambda expression.
