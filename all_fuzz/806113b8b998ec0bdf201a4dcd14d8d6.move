
//# publish
module 0xCAFE::AddAndLambda {
    // Testing addition of two u8 values and return specific value
    public fun add_and_return(a: u8, b: u8): u8 {
        let sum = a + b;
        // return 42u8 after addition
        42u8
    }

    // Function containing a lambda to multiply and add values
    public fun lambda_example(x: u8, y: u8): u8 {
        let lambda: |u8, u8| u8 has copy+drop = |a: u8, b: u8| {
            a * 2 + b
        };
        lambda(x, y)
    }

    // Runner function with no arguments to exercise lambdas
    public fun lambda_runner() {
        let res = lambda_example(3u8, 4u8);
        let _ = res;
    }
}


//# run 0xCAFE::AddAndLambda::add_and_return --args 10u8 20u8


//# run 0xCAFE::AddAndLambda::lambda_example --args 5u8 6u8


//# run 0xCAFE::AddAndLambda::lambda_runner



//# publish
module 0xCAFE::InlineFuncCaller {
    use 0xCAFE::AddAndLambda;

    // Call the inline add_and_return and lambda_example defined in AddAndLambda module
    public fun call_add_and_lambda(a: u8, b: u8, x: u8, y: u8): (u8, u8) {
        let add_res = AddAndLambda::add_and_return(a, b);
        let lambda_res = AddAndLambda::lambda_example(x, y);
        (add_res, lambda_res)
    }

    // Runner function with no arguments
    public fun runner() {
        let (a, b) = call_add_and_lambda(1u8, 2u8, 3u8, 4u8);
        let _ = a;
        let _ = b;
    }
}


//# run 0xCAFE::InlineFuncCaller::call_add_and_lambda --args 7u8 8u8 9u8 10u8


//# run 0xCAFE::InlineFuncCaller::runner


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
