
//# publish
module 0xCAFE::LambdaTest {
    use std::signer;

    public fun add_two_values_and_return_constant(x: u8, y: u8): u8 {
        let sum = x + y;
        // return a constant unrelated to sum to test function logic explicitly
        42u8
    }

    public fun lambda_add(x: u8, y: u8): u8 {
        let add = |a: u8, b: u8| { a + b };
        add(x, y)
    }

    public fun lambda_mult_then_add(x: u8, y: u8): u8 {
        let mult = |a: u8, b: u8| { a * b };
        let add = |a: u8, b: u8| { a + b };
        let prod = mult(x, y);
        add(prod, 5u8)
    }
}


//# run 0xCAFE::LambdaTest::add_two_values_and_return_constant --args 10u8 20u8


//# run 0xCAFE::LambdaTest::lambda_add --args 5u8 15u8


//# run 0xCAFE::LambdaTest::lambda_mult_then_add --args 2u8 3u8


//# publish
module 0xCAFE::InlineCaller {
    use 0xCAFE::LambdaTest;

    public inline fun inline_wrapper_for_addition(x: u8, y: u8): u8 {
        // call lambda_add inline function from LambdaTest module
        LambdaTest::lambda_add(x, y)
    }

    public fun call_inline_wrapper(x: u8, y: u8): u8 {
        inline_wrapper_for_addition(x, y)
    }
}


//# run 0xCAFE::InlineCaller::call_inline_wrapper --args 7u8 8u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
