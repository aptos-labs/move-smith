
//# publish
module 0xCAFE::LambdaTests {
    use std::signer;

    public fun add_and_return_sum(x: u8, y: u8): u8 {
        let sum = x + y;
        sum
    }

    public fun lambda_example(): u8 {
        let lambda: |u8, u8| u8 has copy + drop = |a: u8, b: u8| {
            a + b
        };
        lambda(10u8, 20u8)
    }

    public fun nested_lambda_call(x: u8, y: u8): u8 {
        let lambda1: |u8| u8 has copy + drop = |a: u8| { a + 1u8 };
        let lambda2: |u8| u8 has copy + drop = |b: u8| { lambda1(b) + y };
        lambda2(x)
    }

    public fun runner_no_args(): u8 {
        let res = add_and_return_sum(7u8, 8u8);
        res
    }
}


//# run 0xCAFE::LambdaTests::add_and_return_sum --args 12u8 34u8


//# run 0xCAFE::LambdaTests::lambda_example


//# run 0xCAFE::LambdaTests::nested_lambda_call --args 3u8 4u8


//# run 0xCAFE::LambdaTests::runner_no_args



//# publish
module 0xCAFE::InlineCaller {
    use 0xCAFE::LambdaTests;

    public fun call_inline_add_and_return_sum(x: u8, y: u8): u8 {
        LambdaTests::add_and_return_sum(x, y)
    }

    public fun call_lambda_example(): u8 {
        LambdaTests::lambda_example()
    }

    public fun call_runner_no_args(): u8 {
        LambdaTests::runner_no_args()
    }
}


//# run 0xCAFE::InlineCaller::call_inline_add_and_return_sum --args 20u8 22u8


//# run 0xCAFE::InlineCaller::call_lambda_example


//# run 0xCAFE::InlineCaller::call_runner_no_args


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
