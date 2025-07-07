
//# publish
module 0xCAFE::LambdaTest {
    public fun add_and_return_sum(a: u8, b: u8): u8 {
        let sum = a + b;
        42u8 + sum
    }

    public fun lambda_example(a: u8, b: u8): (u8, u8) {
        let lambda: |u8, u8| (u8, u8) has copy+drop = |x: u8, y: u8| {
            let add = x + y;
            let mul = x * y;
            (add, mul)
        };
        lambda(a, b)
    }
}


//# publish
module 0xCAFE::InlineCall {
    use 0xCAFE::LambdaTest;

    public inline fun inline_addition(x: u8, y: u8): u8 {
        LambdaTest::add_and_return_sum(x, y)
    }

    public fun caller_function(x: u8, y: u8): u8 {
        inline_addition(x, y)
    }
}


//# run 0xCAFE::LambdaTest::add_and_return_sum --args 10u8 32u8


//# run 0xCAFE::LambdaTest::lambda_example --args 4u8 5u8


//# run 0xCAFE::InlineCall::caller_function --args 7u8 3u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
