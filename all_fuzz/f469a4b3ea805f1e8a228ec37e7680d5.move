
//# publish
module 0xCAFE::LambdaTest {
    // Test module for lambdas and addition computations
    use std::signer;

    public fun add_and_return_sum(a: u8, b: u8): u8 {
        let sum = a + b;
        // Return sum + 10 to see effect
        sum + 10
    }

    public fun lambda_add(a: u8, b: u8): u8 {
        let sum_lambda: |u8,u8| u8 has copy+drop = |x: u8, y: u8| {x + y};
        sum_lambda(a, b)
    }

    public fun lambda_return_pair(a: u8, b: u8): (u8, u8) {
        let pair_lambda: |u8,u8| (u8, u8) has copy+drop = |x: u8, y: u8| {(x + y, x * y)};
        pair_lambda(a, b)
    }

    public fun runner() {
        let _ = add_and_return_sum(5u8, 7u8);
        let _ = lambda_add(8u8, 9u8);
        let (_s, _p) = lambda_return_pair(2u8, 3u8);
    }
}


//# run 0xCAFE::LambdaTest::runner


//# publish
module 0xCAFE::InlineCaller {
    use 0xCAFE::LambdaTest;

    public fun call_add_and_return_sum(a: u8, b: u8): u8 {
        LambdaTest::add_and_return_sum(a, b)
    }

    public fun nested_lambda_call(a: u8, b: u8): (u8, u8) {
        LambdaTest::lambda_return_pair(a, b)
    }

    public fun runner() {
        let _ = call_add_and_return_sum(1u8, 2u8);
        let (_x, _y) = nested_lambda_call(4u8, 5u8);
    }
}


//# run 0xCAFE::InlineCaller::runner


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
