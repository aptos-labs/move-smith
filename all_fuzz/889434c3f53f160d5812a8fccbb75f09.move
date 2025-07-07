
//# publish
module 0xCAFE::LambdaTest {
    public fun add_and_return_fixed(a: u8, b: u8): u8 {
        let sum = a + b;

        // Return fixed value
        42u8
    }

    public fun lambda_test_example(a: u8, b: u8): (u8, u8) {
        let lambda: |u8, u8| (u8, u8) has copy+drop = |x: u8, y: u8| {
            let s = x + y;
            let p = x * y;
            (s, p)
        };
        lambda(a, b)
    }
}


//# run 0xCAFE::LambdaTest::add_and_return_fixed --args 5u8 7u8


//# run 0xCAFE::LambdaTest::lambda_test_example --args 3u8 4u8


//# publish
module 0xCAFE::NestedCall {
    use 0xCAFE::LambdaTest;

    public inline fun inline_double(x: u8): u8 {
        x + x
    }

    public fun call_nested_function(a: u8, b: u8): u8 {
        let sum = LambdaTest::add_and_return_fixed(a, b);
        let double = inline_double(sum);
        double
    }
}


//# run 0xCAFE::NestedCall::call_nested_function --args 2u8 3u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
