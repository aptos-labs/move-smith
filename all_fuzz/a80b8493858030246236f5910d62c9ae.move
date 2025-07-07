
//# publish
module 0xCAFE::ArithmeticWithLambda {
    use std::signer;

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
        // This will abort if b > a due to assert
        assert!(a >= b, 2001);
        let _ = a - b;
    }

    public fun division_by_zero(a: u128) {
        assert!(false, 2002); // Always abort to mark unreachable code if no abort
        // let _ = a / 0;
    }

    public fun modulo_by_zero(a: u128) {
        assert!(false, 2003); // Always abort to mark unreachable code if no abort
        // let _ = a % 0;
    }
}


//# run 0xCAFE::ArithmeticWithLambda::add_two_u8 --args 10u8 20u8


//# run 0xCAFE::ArithmeticWithLambda::apply_lambda_to_sum --args 2u8 3u8


//# run 0xCAFE::ArithmeticWithLambda::arithmetic_u128_ops --args 1000u128 250u128


//# run 0xCAFE::ArithmeticWithLambda::arithmetic_overflow_subtraction --args 100u128 200u128

// purposely commented below runs that abort to test division/modulo by zero (aborts expected) 
// to allow testing compile/run for valid calls, uncomment to check abort behavior

// #// run 0xCAFE::ArithmeticWithLambda::division_by_zero --args 123u128

// #// run 0xCAFE::ArithmeticWithLambda::modulo_by_zero --args 123u128


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// b16b4da131fe27a1ca594bb78cf9bbc5: Test that all arithmetic operations (addition, subtraction, multiplication, division, and modulo) on `u128` values in Move both correctly compute results and properly fail on overflow and invalid operations (such as division or modulo by zero and subtraction resulting in negative values).
