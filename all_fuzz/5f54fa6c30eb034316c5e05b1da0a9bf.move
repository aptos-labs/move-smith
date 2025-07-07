
//# publish
module 0xCAFE::LambdaTest {
    use std::signer;

    public fun add_and_return_specific(a: u8, b: u8, specific: u8): u8 {
        let sum = a + b;
        // ignoring sum, just returning specific to check function call correctness
        specific
    }

    public fun lambda_caller(): u8 {
        let lambda: |u8, u8|(u8) has copy+drop = |x: u8, y: u8| {
            x + y
        };
        lambda(10u8, 20u8)
    }
}


//# run 0xCAFE::LambdaTest::add_and_return_specific --args 5u8 7u8 42u8


//# run 0xCAFE::LambdaTest::lambda_caller



//# publish
module 0xCAFE::NestedCall {
    use 0xCAFE::LambdaTest;

    public inline fun inline_addition(x: u8, y: u8): u8 {
        x + y
    }

    public fun call_inline_from_lambda(x: u8, y: u8): u8 {
        let lambda: |u8, u8|u8 has copy+drop = |a: u8, b: u8| {
            inline_addition(a, b)
        };
        lambda(x, y)
    }

    public fun cross_module_call(a: u8, b: u8): u8 {
        let sum = inline_addition(a, b);
        let from_lambda = LambdaTest::lambda_caller();
        sum + from_lambda
    }
}


//# run 0xCAFE::NestedCall::call_inline_from_lambda --args 15u8 10u8


//# run 0xCAFE::NestedCall::cross_module_call --args 1u8 2u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
