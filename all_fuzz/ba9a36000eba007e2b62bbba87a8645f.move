
//# publish
module 0xCAFE::LambdaTest {
    public fun add_then_return_sum(a: u8, b: u8): u8 {
        let sum = a + b;

        let lambda: |u8|u8 has copy+drop = |x: u8| {
            // Just return the input to check lambda call
            x
        };
        let _ = lambda(sum);

        sum + 10u8
    }

    public fun nested_lambda_operations(a: u8, b: u8): u8 {
        let sum_lambda: |u8, u8|u8 has copy+drop = |x: u8, y: u8| {
            x + y
        };

        let mul_lambda: |u8, u8|u8 has copy+drop = |x: u8, y: u8| {
            x * y
        };

        let sum_result = sum_lambda(a, b);
        let mul_result = mul_lambda(a, b);

        sum_result + mul_result
    }
}


//# publish
module 0xCAFE::InlineCalls {
    use 0xCAFE::LambdaTest;

    public inline fun inline_double(a: u8): u8 {
        a * 2u8
    }

    public fun call_lambda_and_inline(a: u8, b: u8): u8 {
        let sum = LambdaTest::add_then_return_sum(a, b);
        let doubled = inline_double(sum);
        doubled
    }

    public fun call_nested_lambda(a: u8, b: u8): u8 {
        LambdaTest::nested_lambda_operations(a, b)
    }
}


//# run 0xCAFE::LambdaTest::add_then_return_sum --args 5u8 7u8


//# run 0xCAFE::LambdaTest::nested_lambda_operations --args 3u8 4u8


//# run 0xCAFE::InlineCalls::call_lambda_and_inline --args 10u8 5u8


//# run 0xCAFE::InlineCalls::call_nested_lambda --args 6u8 7u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
