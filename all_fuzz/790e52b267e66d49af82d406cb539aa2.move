
//# publish
module 0xCAFE::LambdaTest {
    use std::signer;

    public fun add_and_return_sum(x: u8, y: u8): u8 {
        let sum = x + y;
        42u8 + sum
    }

    public fun lambda_example(x: u8, y: u8): u8 {
        let adder: |u8, u8| u8 has copy+drop = |a: u8, b: u8| {
            a + b
        };
        let result = adder(x, y);
        result + 1u8
    }

    public inline fun inline_add(a: u8, b: u8): u8 {
        a + b
    }

    public fun call_inline_inside_module(a: u8, b: u8): u8 {
        inline_add(a, b) * 2u8
    }
}


//# publish
module 0xCAFE::NestedCall {
    use 0xCAFE::LambdaTest;

    public fun nested_call_add(a: u8, b: u8): u8 {
        // Call to inline function in LambdaTest module and then add 5
        let sum = LambdaTest::inline_add(a, b);
        sum + 5u8
    }

    public fun nested_call_lambda(x: u8, y: u8): u8 {
        // Call to lambda_example in LambdaTest module
        LambdaTest::lambda_example(x, y) + 10u8
    }
}


//# run 0xCAFE::LambdaTest::add_and_return_sum --args 3u8 4u8


//# run 0xCAFE::LambdaTest::lambda_example --args 5u8 6u8


//# run 0xCAFE::LambdaTest::call_inline_inside_module --args 7u8 8u8


//# run 0xCAFE::NestedCall::nested_call_add --args 9u8 10u8


//# run 0xCAFE::NestedCall::nested_call_lambda --args 11u8 12u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
