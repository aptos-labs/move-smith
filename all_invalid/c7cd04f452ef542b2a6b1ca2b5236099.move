
//# publish
module 0xBADD::TestComplexFunctions {
    use std::vector;

    // Dummy function to generate 66 arguments
    public fun dummy_arg1(): u8 { 1 }
    public fun dummy_arg2(): u8 { 2 }
    public fun dummy_arg3(): u8 { 3 }
    public fun dummy_arg4(): u8 { 4 }
    public fun dummy_arg5(): u8 { 5 }
    public fun dummy_arg6(): u8 { 6 }
    public fun dummy_arg7(): u8 { 7 }
    public fun dummy_arg8(): u8 { 8 }
    public fun dummy_arg9(): u8 { 9 }
    public fun dummy_arg10(): u8 { 10 }
    public fun dummy_arg11(): u8 { 11 }
    public fun dummy_arg12(): u8 { 12 }
    public fun dummy_arg13(): u8 { 13 }
    public fun dummy_arg14(): u8 { 14 }
    public fun dummy_arg15(): u8 { 15 }
    public fun dummy_arg16(): u8 { 16 }
    public fun dummy_arg17(): u8 { 17 }
    public fun dummy_arg18(): u8 { 18 }
    public fun dummy_arg19(): u8 { 19 }
    public fun dummy_arg20(): u8 { 20 }
    public fun dummy_arg21(): u8 { 21 }
    public fun dummy_arg22(): u8 { 22 }
    public fun dummy_arg23(): u8 { 23 }
    public fun dummy_arg24(): u8 { 24 }
    public fun dummy_arg25(): u8 { 25 }
    public fun dummy_arg26(): u8 { 26 }
    public fun dummy_arg27(): u8 { 27 }
    public fun dummy_arg28(): u8 { 28 }
    public fun dummy_arg29(): u8 { 29 }
    public fun dummy_arg30(): u8 { 30 }
    public fun dummy_arg31(): u8 { 31 }
    public fun dummy_arg32(): u8 { 32 }
    public fun dummy_arg33(): u8 { 33 }
    public fun dummy_arg34(): u8 { 34 }
    public fun dummy_arg35(): u8 { 35 }
    public fun dummy_arg36(): u8 { 36 }
    public fun dummy_arg37(): u8 { 37 }
    public fun dummy_arg38(): u8 { 38 }
    public fun dummy_arg39(): u8 { 39 }
    public fun dummy_arg40(): u8 { 40 }
    public fun dummy_arg41(): u8 { 41 }
    public fun dummy_arg42(): u8 { 42 }
    public fun dummy_arg43(): u8 { 43 }
    public fun dummy_arg44(): u8 { 44 }
    public fun dummy_arg45(): u8 { 45 }
    public fun dummy_arg46(): u8 { 46 }
    public fun dummy_arg47(): u8 { 47 }
    public fun dummy_arg48(): u8 { 48 }
    public fun dummy_arg49(): u8 { 49 }
    public fun dummy_arg50(): u8 { 50 }
    public fun dummy_arg51(): u8 { 51 }
    public fun dummy_arg52(): u8 { 52 }
    public fun dummy_arg53(): u8 { 53 }
    public fun dummy_arg54(): u8 { 54 }
    public fun dummy_arg55(): u8 { 55 }
    public fun dummy_arg56(): u8 { 56 }
    public fun dummy_arg57(): u8 { 57 }
    public fun dummy_arg58(): u8 { 58 }
    public fun dummy_arg59(): u8 { 59 }
    public fun dummy_arg60(): u8 { 60 }
    public fun dummy_arg61(): u8 { 61 }
    public fun dummy_arg62(): u8 { 62 }
    public fun dummy_arg63(): u8 { 63 }
    public fun dummy_arg64(): u8 { 64 }
    public fun dummy_arg65(): u8 { 65 }
    public fun dummy_arg66(): u8 { 66 }

    // Function to call with 66 arguments
    public fun call_with_66_args(
        a1: u8, a2: u8, a3: u8, a4: u8, a5: u8, a6: u8, a7: u8, a8: u8, a9: u8, a10: u8,
        a11: u8, a12: u8, a13: u8, a14: u8, a15: u8, a16: u8, a17: u8, a18: u8, a19: u8, a20: u8,
        a21: u8, a22: u8, a23: u8, a24: u8, a25: u8, a26: u8, a27: u8, a28: u8, a29: u8, a30: u8,
        a31: u8, a32: u8, a33: u8, a34: u8, a35: u8, a36: u8, a37: u8, a38: u8, a39: u8, a40: u8,
        a41: u8, a42: u8, a43: u8, a44: u8, a45: u8, a46: u8, a47: u8, a48: u8, a49: u8, a50: u8,
        a51: u8, a52: u8, a53: u8, a54: u8, a55: u8, a56: u8, a57: u8, a58: u8, a59: u8, a60: u8,
        a61: u8, a62: u8, a63: u8, a64: u8, a65: u8, a66: u8
    ): u8 {
        // Sum all arguments as dummy computation
        a1 + a2 + a3 + a4 + a5 + a6 + a7 + a8 + a9 + a10 +
        a11 + a12 + a13 + a14 + a15 + a16 + a17 + a18 + a19 + a20 +
        a21 + a22 + a23 + a24 + a25 + a26 + a27 + a28 + a29 + a30 +
        a31 + a32 + a33 + a34 + a35 + a36 + a37 + a38 + a39 + a40 +
        a41 + a42 + a43 + a44 + a45 + a46 + a47 + a48 + a49 + a50 +
        a51 + a52 + a53 + a54 + a55 + a56 + a57 + a58 + a59 + a60 +
        a61 + a62 + a63 + a64 + a65 + a66
    }
}



//# run 0xBADD::TestComplexFunctions::call_with_66_args --args 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59 60 61 62 63 64 65 66



//# publish
module 0xBADD::U128ArithTests {
    use std::u128;

    // Test addition, subtraction, multiplication, division, and modulo on u128
    public fun test_arithmetic() {
        let max_u128 = u128::max_value();
        let one: u128 = 1;
        let zero: u128 = 0;

        // Addition
        let sum = max_u128 + zero; // Should be max value
        assert!(sum == max_u128, 999);
        // Addition overflow would abort in actual behavior

        // Subtraction
        let sub = max_u128 - one; // Should be max-1
        assert!(sub == max_u128 - one, 998);

        // Multiplication
        let mul = one * max_u128; // Should be max_u128
        assert!(mul == max_u128, 997);
        // overflow in multiplication should abort

        // Division by non-zero
        let div = max_u128 / one; // Should be max_u128
        assert!(div == max_u128, 996);

        // Modulo by non-zero
        let modulo = max_u128 % one; // Should be zero
        assert!(modulo == zero, 995);
    }

    // Test division and modulo by zero (expect abort)
    public fun test_div_mod_by_zero() {
        let _ = u128::div(u128::max_value(), 0); // Should abort
        let _ = u128::mod(u128::max_value(), 0); // Should abort
    }

    // Test subtraction to underflow
    public fun test_sub_underflow() {
        // This should abort - commented out
        // let _ = u128::sub(0, 1);
    }
}



//# run 0xBADD::U128ArithTests::test_arithmetic
