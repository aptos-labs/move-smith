// 1. INVALID ASSIGNMENT SYNTAX
//# publish
address 0x1 {
module InvalidAssignmentTest {
    // This function has an invalid assignment syntax (outside allowed patterns)
    public fun test_invalid() {
        let x = 0;
        // Invalid syntax: `x, y = 1, 2;` (deconstructing more than one variable is not allowed in Move)
        // This should be reported by the compiler as an error.
        x, y = 1, 2; // invalid
    }
}
}

// 2. MACRO/SYNTACTIC SUGAR EXPANSION
//# publish
address 0x2 {
module MacroExpansionTest {
    // Below, `let mut x = 0;` is not valid Move, but for this case, let's use
    // the for-loop sugar, which expands into a while loop during compilation.
    public fun expand_for_loop() {
        let mut sum = 0;
        // Syntactic sugar: the following expands to a loop with iterators
        for i in 0..3 {
            sum = sum + i;
        }
        // expected expansion (for reference, not actual code to run):
        // let i = 0;
        // while (i < 3) {
        //     sum = sum + i;
        //     i = i + 1;
        // }
    }
}
}

// 3. SUM FUNCTION WITH 65 PARAMETERS
//# publish
address 0x3 {
module SumTest {
    public fun sum_65(
        // 65 u8 parameters
        a0: u8, a1: u8, a2: u8, a3: u8, a4: u8, a5: u8, a6: u8, a7: u8, a8: u8, a9: u8,
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
        // The correct sum, if each parameter is 1, is 65.
        assert!(sum == 65, 0);
    }

    // Runner function to call sum_65 with 1 for every parameter
    public fun run_sum_65() {
        Self::sum_65(
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
//# run 0x3::SumTest::run_sum_65

// 4. GENERIC TYPE PARAMETER IN STRUCT & 5. EXPLICIT TYPE ANNOTATION
//# publish
address 0x4 {
module GenericsStructTest {
    // Struct with generic type parameter T
    struct Wrapper<T> {
        #[skip(mutable_reference)] // 6. SKIP LINT EXAMPLE: Skip mutable_reference lint on this field
        // field with explicit type annotation, e.g., value: T
        value: T,
    }

    public fun make_u64_wrapper(): Wrapper<u64> {
        Wrapper<u64> { value: 42 }
    }

    // Runner function to instantiate and just ignore result
    public fun run_generic_struct() {
        let _w = Self::make_u64_wrapper();
    }
}
//# run 0x4::GenericsStructTest::run_generic_struct

// 6. SKIP LINT ATTRIBUTE IN USE
//# publish
address 0x5 {
module LintSkipTest {
    #[skip(large_stack_frame)]
    public fun do_something_weird() {
        // Deliberately create a huge stack frame (by declaring many variables).
        let a: u8 = 1;
        let b: u8 = 2;
        let c: u8 = 3;
        let d: u8 = 4;
        let e: u8 = 5;
        let f: u8 = 6;
        let g: u8 = 7;
        let h: u8 = 8;
        let i: u8 = 9;
        let j: u8 = 10;
        let k: u8 = 11;
        let l: u8 = 12;
        let m: u8 = 13;
        let n: u8 = 14;
        let o: u8 = 15;
        let p: u8 = 16;
        let q: u8 = 17;
        let r: u8 = 18;
        let s: u8 = 19;
        let t: u8 = 20;
        // ... etc ...
        let _ = a + b + c + d + e + f + g + h + i + j + k + l + m + n + o + p + q + r + s + t;
    }

    public fun run() {
        Self::do_something_weird();
    }
}
//# run 0x5::LintSkipTest::run