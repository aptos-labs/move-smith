
//# publish
module 0xCAFE::AddAndLambda {
    // Module to test addition and lambda functions

    public fun add_two_u8_values(a: u8, b: u8): u8 {
        let sum = a + b;
        sum + 1u8
    }

    public fun run_lambda_example(x: u8): u8 {
        let add_one: |u8|u8 has copy+drop = |a: u8| { a + 1u8 };
        add_one(x)
    }
}


//# run 0xCAFE::AddAndLambda::add_two_u8_values --args 10u8 20u8


//# run 0xCAFE::AddAndLambda::run_lambda_example --args 5u8


//# publish
module 0xCAFE::CallerModule {
    use 0xCAFE::AddAndLambda;

    public fun call_inline_and_return(x: u8, y: u8): u8 {
        let sum = AddAndLambda::add_two_u8_values(x, y) - 1u8;
        let result = AddAndLambda::run_lambda_example(sum);
        result
    }
}


//# run 0xCAFE::CallerModule::call_inline_and_return --args 15u8 5u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
