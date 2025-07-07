
//# publish
module 0xCAFE::LambdaTest {
    public fun add_and_return_sum(x: u8, y: u8): u8 {
        let sum = x + y;
        sum
    }

    // NOTE: Move currently doesn't support anonymous lambda expressions with types like |(u8, u8) -> u8|
    // Instead, declare an inline function and call it.
    public inline fun lambda(a: u8, b: u8): u8 {
        a + b
    }

    public fun call_lambda_and_add(x: u8, y: u8): u8 {
        let result = Self::lambda(x, y);
        result
    }
}




//# publish
module 0xCAFE::NestedCall {
    use 0xCAFE::LambdaTest;

    public inline fun inline_addition(a: u8, b: u8): u8 {
        LambdaTest::add_and_return_sum(a, b)
    }

    public fun nested_calls(x: u8, y: u8): u8 {
        let sum1 = LambdaTest::call_lambda_and_add(x, y);
        let sum2 = inline_addition(sum1, x);
        sum2
    }
}




//# run 0xCAFE::LambdaTest::add_and_return_sum --args 10u8 20u8




//# run 0xCAFE::LambdaTest::call_lambda_and_add --args 5u8 7u8




//# run 0xCAFE::NestedCall::nested_calls --args 3u8 4u8
