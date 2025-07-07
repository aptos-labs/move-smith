
//# publish
module 0xCAFE::LambdaTest {
    use std::vector;

    public fun add_and_return_sum(a: u8, b: u8): u8 {
        let sum = a + b;
        42u8 + sum
    }

    public fun lambda_sum_then_add(a: u8, b: u8): u8 {
        let sum_lambda: |u8, u8| u8 has copy+drop = |x: u8, y: u8| { x + y };
        let sum = sum_lambda(a, b);
        sum + 10u8
    }

    public inline fun inline_add(a: u8, b: u8): u8 {
        a + b
    }

    public fun call_inline_add_and_further(a: u8, b: u8): u8 {
        let inline_sum = inline_add(a, b);
        inline_sum + 5u8
    }
}


//# publish
module 0xCAFE::NestedCalls {
    use 0xCAFE::LambdaTest;

    public fun nested_call(a: u8, b: u8): u8 {
        let result = LambdaTest::call_inline_add_and_further(a, b);
        let extra = LambdaTest::lambda_sum_then_add(a, b);
        result + extra
    }
}


//# run 0xCAFE::LambdaTest::add_and_return_sum --args 10u8 20u8


//# run 0xCAFE::LambdaTest::lambda_sum_then_add --args 15u8 25u8


//# run 0xCAFE::LambdaTest::call_inline_add_and_further --args 5u8 10u8


//# run 0xCAFE::NestedCalls::nested_call --args 3u8 7u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
