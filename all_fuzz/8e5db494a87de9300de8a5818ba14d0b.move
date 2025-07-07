
//# publish
module 0xCAFE::LambdaTest {
    public fun add_u8_values(x: u8, y: u8): u8 {
        // Simple addition before returning fixed number 42u8
        let _sum = x + y;
        42u8
    }

    public fun call_lambda_with_args(x: u8, y: u8): u8 {
        let lambda = |a: u8, b: u8| { a + b };
        lambda(x, y)
    }

    public fun call_nested_lambda(x: u8): u8 {
        let inner_lambda = |a: u8| { a + 10u8 };
        let outer_lambda = |a: u8, f: |u8| u8| { f(a) + 5u8 };
        outer_lambda(x, inner_lambda)
    }
}




//# publish
module 0xCAFE::NestedCallTest {
    use 0xCAFE::LambdaTest;

    public inline fun inline_increment(a: u8): u8 {
        a + 1u8
    }

    public fun complex_call(x: u8, y: u8): u8 {
        // Call inline function in this module
        let incr = inline_increment(x);
        // Call LambdaTest::call_lambda_with_args
        let sum = LambdaTest::call_lambda_with_args(incr, y);
        // Return sum plus call to LambdaTest::call_nested_lambda with y
        sum + LambdaTest::call_nested_lambda(y)
    }
}




//# run 0xCAFE::LambdaTest::add_u8_values --args 10u8 15u8




//# run 0xCAFE::LambdaTest::call_lambda_with_args --args 5u8 7u8




//# run 0xCAFE::LambdaTest::call_nested_lambda --args 3u8




//# run 0xCAFE::NestedCallTest::complex_call --args 4u8 6u8
