
//# publish
module 0xCAFE::AdditionModule {
    public fun add_and_return_sum(a: u8, b: u8): u8 {
        let sum = a + b;
        // This function returns the sum plus one as a test
        sum + 1
    }

    public fun lambda_example(): u8 {
        let add_lambda: |u8, u8|u8 has copy+drop = |x: u8, y: u8| {
            x + y
        };
        // Call the lambda with fixed arguments
        add_lambda(10u8, 15u8)
    }
}


//# run 0xCAFE::AdditionModule::add_and_return_sum --args 20u8 30u8


//# run 0xCAFE::AdditionModule::lambda_example



//# publish
module 0xCAFE::CallerModule {
    use 0xCAFE::AdditionModule;

    public fun call_inline_function_and_double(a: u8, b: u8): u8 {
        let sum_plus_one = AdditionModule::add_and_return_sum(a, b);
        // Return double the result to test nested call and arithmetic
        sum_plus_one * 2
    }

    public fun call_lambda_in_caller(): u8 {
        // Call the lambda_example function in AdditionModule
        let result = AdditionModule::lambda_example();
        // Add 5 to the lambda result as an additional test
        result + 5
    }
}


//# run 0xCAFE::CallerModule::call_inline_function_and_double --args 1u8 2u8


//# run 0xCAFE::CallerModule::call_lambda_in_caller


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
