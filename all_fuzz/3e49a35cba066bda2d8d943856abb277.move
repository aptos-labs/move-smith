
//# publish
module 0xCAFE::ArithmeticWithLambda {
    // Removed unused 'use std::signer;' since it's unnecessary here

    public fun add_two_u8(a: u8, b: u8): u8 {
        let sum = a + b;
        // Return sum + 1 to verify computation flow
        let result = sum + 1;
        result
    }

    public fun apply_lambda_to_sum(a: u8, b: u8): u8 {
        let sum = a + b;
        let lambda: |u8|u8 has copy+drop = |x: u8| {
            x * 2
        };
        lambda(sum)
    }

    public fun arithmetic_u128_ops(a: u128, b: u128): (u128, u128, u128, u128, u128) {
        // Addition (with overflow abort)
        let c = a + b;

        // Subtraction, abort if b > a
        assert!(a >= b, 1001);
        let d = a - b;

        // Multiplication (with overflow abort)
        let e = a * b;

        // Division, abort if b == 0
        assert!(b != 0, 1002);
        let f = a / b;

        // Modulo, abort if b == 0
        assert!(b != 0, 1003);
        let g = a % b;

        (c, d, e, f, g)
    }

    public fun arithmetic_overflow_subtraction(a: u128, b: u128) {
        // To avoid abort, ensure a >= b
        assert!(a >= b, 2001);
        let _ = a - b;
    }

    public fun division_by_zero(_a: u128) {
        // Marking function as abort intentionally by dividing by zero (uncomment below to test abort)
        // let _ = _a / 0;
        abort 2002;
    }

    public fun modulo_by_zero(_a: u128) {
        // Marking function as abort intentionally by modulo by zero (uncomment below to test abort)
        // let _ = _a % 0;
        abort 2003;
    }
}



//# run 0xCAFE::ArithmeticWithLambda::add_two_u8 --args 10u8 20u8



//# run 0xCAFE::ArithmeticWithLambda::apply_lambda_to_sum --args 2u8 3u8



//# run 0xCAFE::ArithmeticWithLambda::arithmetic_u128_ops --args 1000u128 250u128



//# run 0xCAFE::ArithmeticWithLambda::arithmetic_overflow_subtraction --args 200u128 100u128

// purposely commented below runs that abort to test division/modulo by zero (aborts expected) 
// to allow testing compile/run for valid calls, uncomment to check abort behavior

// #// run 0xCAFE::ArithmeticWithLambda::division_by_zero --args 123u128

// #// run 0xCAFE::ArithmeticWithLambda::modulo_by_zero --args 123u128
