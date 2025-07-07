
//# publish
module 0xCAFE::LambdaTest {
    use std::signer;

    public fun add_then_return_sum(a: u8, b: u8, return_val: u8): u8 {
        let sum = a + b;
        let _ = sum; // just compute sum, then return return_val
        return_val
    }

    public fun call_lambda_example(x: u8): u8 {
        let lambda: |u8|u8 has copy+drop = |y: u8| {
            y * 2
        };
        lambda(x)
    }

    public inline fun inline_identity(z: u8): u8 {
        z
    }

    public fun call_inline_add_one(x: u8): u8 {
        let y = 0xCAFE::LambdaTest::inline_identity(x);
        y + 1
    }
}


//# publish
module 0xCAFE::NestedCall {
    use 0xCAFE::LambdaTest;

    public fun nested_calls(x: u8, y: u8): u8 {
        let add_result = LambdaTest::add_then_return_sum(x, y, 42u8);
        let lambda_result = LambdaTest::call_lambda_example(add_result);
        let inline_result = LambdaTest::call_inline_add_one(lambda_result);
        inline_result
    }
}


//# run 0xCAFE::LambdaTest::add_then_return_sum --args 10u8 20u8 99u8


//# run 0xCAFE::LambdaTest::call_lambda_example --args 7u8


//# run 0xCAFE::LambdaTest::call_inline_add_one --args 5u8


//# run 0xCAFE::NestedCall::nested_calls --args 1u8 2u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
