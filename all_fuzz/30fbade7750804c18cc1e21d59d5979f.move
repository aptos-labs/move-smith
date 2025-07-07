
//# publish
module 0xCAFE::LambdaTest {
    use std::signer;

    public fun add_two_values(a: u8, b: u8): u8 {
        let sum = a + b;
        // Return fixed value after addition to test basic arithmetic and return
        42u8 + sum
    }

    public fun lambda_example(): u8 {
        let doubler: |u8|u8 has copy + drop = |x: u8| {
            x * 2
        };
        let tripler: |u8|u8 has copy + drop = |y: u8| {
            y * 3
        };
        let x = doubler(7u8);
        let y = tripler(5u8);
        x + y
    }

    public fun runner(): u8 {
        add_two_values(10u8, 15u8) + lambda_example()
    }
}


//# publish
module 0xCAFE::InlineCall {
    use 0xCAFE::LambdaTest;

    public inline fun inline_addition(a: u8, b: u8): u8 {
        let result = a + b;
        result
    }

    public fun call_lambda_runner_and_inline(): u8 {
        let from_lambda = LambdaTest::runner();
        let from_inline = inline_addition(20u8, 22u8);
        from_lambda + from_inline
    }
}


//# run 0xCAFE::LambdaTest::add_two_values --args 5u8 10u8


//# run 0xCAFE::LambdaTest::lambda_example


//# run 0xCAFE::LambdaTest::runner


//# run 0xCAFE::InlineCall::call_lambda_runner_and_inline


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
