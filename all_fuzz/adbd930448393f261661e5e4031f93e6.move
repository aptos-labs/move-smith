
//# publish
module 0xCAFE::LambdaTest {
    public fun add_and_return_fixed(x: u8, y: u8): u8 {
        let sum = x + y;
        let fixed = 42u8;
        fixed
    }

    public fun lambda_add(x: u8, y: u8): u8 {
        let add_lambda: |u8, u8| u8 has copy+drop = |a: u8, b: u8| {
            a + b
        };
        add_lambda(x, y)
    }

    public fun call_lambda(x: u8, y: u8): u8 {
        let lambda: |u8, u8| u8 has copy+drop = |a: u8, b: u8| {
            a + b
        };
        lambda(x, y)
    }

    public inline fun inline_add(a: u8, b: u8): u8 {
        a + b
    }
}


//# publish
module 0xCAFE::InlineCaller {
    use 0xCAFE::LambdaTest;

    public fun nested_call(x: u8, y: u8): u8 {
        let sum = LambdaTest::inline_add(x, y);
        LambdaTest::add_and_return_fixed(sum, 0u8)
    }
}


//# run 0xCAFE::LambdaTest::add_and_return_fixed --args 10u8 20u8


//# run 0xCAFE::LambdaTest::lambda_add --args 5u8 6u8


//# run 0xCAFE::LambdaTest::call_lambda --args 7u8 8u8


//# run 0xCAFE::InlineCaller::nested_call --args 3u8 4u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
