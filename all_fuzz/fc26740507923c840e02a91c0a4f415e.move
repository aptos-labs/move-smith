// #publish
//# publish
module 0xCAFE::AddAndReturn {
    public fun add_two_values_and_return_result(a: u8, b: u8): u8 {
        let sum = a + b;
        let result = sum + 10;
        result
    }
}


// #run 0xCAFE::AddAndReturn::add_two_values_and_return_result --args 5u8 10u8


// #publish
//# publish
module 0xCAFE::LambdaExamples {
    // Add the 'has copy+drop' to the function parameter 'lambda' type to match usage and prevent deserialization error
    public fun call_lambda_addition(a: u8, b: u8): u8 {
        let add_lambda: |u8, u8| u8 has copy+drop = |x: u8, y: u8| {
            x + y
        };
        add_lambda(a, b)
    }

    // Fix: add `has copy+drop` to the `lambda` parameter to match deserialization requirements
    public fun use_lambda_as_argument(lambda: |u8, u8| u8 has copy+drop, x: u8, y: u8): u8 {
        lambda(x, y)
    }

    public fun nested_lambda() {
        let outer_lambda: |u8| (|u8| u8) has copy+drop = |x: u8| {
            let inner_lambda: |u8| u8 has copy+drop = |y: u8| { x + y };
            inner_lambda
        };
        let inner = outer_lambda(3u8);
        let _res = inner(4u8);
    }
}

// #run 0xCAFE::LambdaExamples::call_lambda_addition --args 7u8 8u8

// Fix: Provide a proper signer when running this with lambda argument.
// Let's create another inline function to pass a lambda from this module that can be called 
// But more importantly, the run command for `use_lambda_as_argument` requires a signer and a lambda parameter passed,
// which the test infrastructure can't pass inside CLI easily unless a wrapper function is used.

// Since tests provide only args but not complex types as input params, we fix the test by changing the run invocation:
// - Instead of running `use_lambda_as_argument` directly with manual args, add a wrapper function that calls it internally with a lambda.
// Then run that wrapper without needing to deserialize a lambda argument.

// Add this helper function to avoid needing to serialize the lambda argument at call site:

//# publish
module 0xCAFE::LambdaExampleWrappers {
    use 0xCAFE::LambdaExamples;

    public fun run_use_lambda_as_argument(x: u8, y: u8): u8 {
        let add_lambda: |u8, u8| u8 has copy+drop = |a, b| a + b;
        LambdaExamples::use_lambda_as_argument(add_lambda, x, y)
    }
}

// #run 0xCAFE::LambdaExamples::nested_lambda

// #run 0xCAFE::LambdaExampleWrappers::run_use_lambda_as_argument --args 10u8 11u8 --signers 0xBEEF


// #publish
//# publish
module 0xCAFE::CallerModule {
    use 0xCAFE::AddAndReturn;

    public fun call_inline_add_and_return(a: u8, b: u8): u8 {
        AddAndReturn::add_two_values_and_return_result(a, b)
    }
}

// #run 0xCAFE::CallerModule::call_inline_add_and_return --args 2u8 3u8


// Features:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
