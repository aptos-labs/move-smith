
//# publish
module 0xCAFE::LambdaTest {
    public fun add_two_u8(a: u8, b: u8): u8 {
        let sum = a + b;
        sum + 10u8
    }

    public fun lambda_add_two(a: u8, b: u8): u8 {
        let adder: |u8, u8| u8 has copy+drop = |x: u8, y: u8| {
            x + y
        };
        let res = adder(a, b);
        res + 20u8
    }

    public fun lambda_return_lambda(): |u8, u8| u8 has copy+drop {
        let adder: |u8, u8| u8 has copy+drop = |x: u8, y: u8| {
            x + y + 1u8
        };
        adder
    }
}


//# run 0xCAFE::LambdaTest::add_two_u8 --args 5u8 10u8


//# run 0xCAFE::LambdaTest::lambda_add_two --args 3u8 4u8


//# run 0xCAFE::LambdaTest::lambda_return_lambda



//# publish
module 0xCAFE::InlineCaller {
    use 0xCAFE::LambdaTest;

    public inline fun call_add_two_u8(a: u8, b: u8): u8 {
        LambdaTest::add_two_u8(a, b)
    }

    public fun call_lambda_add_two(a: u8, b: u8): u8 {
        LambdaTest::lambda_add_two(a, b)
    }

    public fun apply_returned_lambda(a: u8, b: u8): u8 {
        let f = LambdaTest::lambda_return_lambda();
        f(a, b)
    }

    public fun runner() {
        let _ = call_add_two_u8(1u8, 2u8);
        let _ = call_lambda_add_two(2u8, 3u8);
        let _ = apply_returned_lambda(3u8, 4u8);
    }
}


//# run 0xCAFE::InlineCaller::runner


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
