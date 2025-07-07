
//# publish
module 0xCAFE::ArithmeticTest {
    public fun add_two_values(a: u8, b: u8): u8 {
        let sum = a + b;
        let result = if (sum > 10) {
            42u8
        } else {
            24u8
        };
        result
    }

    // Move does not support lambdas/inline closures.
    // Replace the lambda with a plain function call instead.
    public fun add_func(x: u8, y: u8): u8 {
        x + y
    }

    public fun use_lambda(a: u8, b: u8): u8 {
        // Call the helper function instead of lambda
        add_func(a, b)
    }

    public fun arithmetic_ops(a: u8, b: u8): (u8, u8, u8, u8, u8) {
        let add = a + b;
        let sub = if (a >= b) { a - b } else { 0u8 };
        let mul = a * b;
        let div = if (b != 0) { a / b } else { 0u8 };
        let modulo = if (b != 0) { a % b } else { 0u8 };
        (add, sub, mul, div, modulo)
    }

    public fun arithmetic_traps() {
        // Overflow add, should abort
        let _ = 255u8 + 1u8;

        // Underflow sub, should trap (will abort)
        let _ = 0u8 - 1u8;

        // Division by zero, should abort
        let _ = 5u8 / 0u8;

        // Modulus by zero, should abort
        let _ = 5u8 % 0u8;
    }

    public fun scoped_blocks(a: u8): u8 {
        let result = a;

        {
            let temp = result + 10u8;
            result = temp;
        };

        {
            let temp = result * 2u8;
            result = temp;
        };

        {
            let temp = result - 5u8;
            result = temp;
        };

        result
    }
}



//# run 0xCAFE::ArithmeticTest::add_two_values --args 5u8 4u8


//# run 0xCAFE::ArithmeticTest::add_two_values --args 7u8 5u8


//# run 0xCAFE::ArithmeticTest::use_lambda --args 3u8 8u8


//# run 0xCAFE::ArithmeticTest::arithmetic_ops --args 20u8 4u8


//# run 0xCAFE::ArithmeticTest::scoped_blocks --args 1u8
