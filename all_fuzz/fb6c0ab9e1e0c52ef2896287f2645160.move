
//# publish
module 0xCAFE::LambdaTest {
    public fun add_and_return_sum(a: u8, b: u8): u8 {
        // compute sum
        let sum = a + b;
        // return sum + 1
        sum + 1
    }

    public fun make_lambda() : |u8, u8| u8 {
        // Returns a lambda function that adds two u8 values
        |x: u8, y: u8| { x + y }
    }

    public fun call_lambda_with_args(f: |u8, u8| u8, x: u8, y: u8): u8 {
        f(x, y)
    }

    public fun call_closure_arg(f: |u8| u8, x: u8): u8 {
        f(x)
    }

    public fun runner() {
        let lambda = make_lambda();
        let _ = call_lambda_with_args(lambda, 10u8, 20u8);
        let result = add_and_return_sum(5u8, 7u8);
        let closure = |x: u8| { x + 3u8 };
        let _ = call_closure_arg(closure, 12u8);
    }
}


//# run 0xCAFE::LambdaTest::add_and_return_sum --args 3u8 4u8


//# run 0xCAFE::LambdaTest::runner


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 6c7f57231e4d203ef1b2da0870bd7436: Test that an inline function can accept closures as arguments and correctly invoke them with given parameters.
