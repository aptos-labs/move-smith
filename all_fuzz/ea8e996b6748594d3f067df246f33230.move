
//# publish
module 0xCAFE::AddModule {
    public fun add_and_return_fixed(a: u8, b: u8): u8 {
        let sum = a + b;
        // Return a specific fixed value after addition
        42u8
    }

    public fun make_lambda_and_call(x: u8, y: u8): u8 {
        let anon_lambda: |u8, u8| u8 has copy+drop = |a: u8, b: u8| {
            a + b
        };
        anon_lambda(x, y)
    }
}


//# publish
module 0xCAFE::CallerModule {
    use 0xCAFE::AddModule;

    public fun call_inline_functions(a: u8, b: u8): u8 {
        // Call AddModule::make_lambda_and_call which uses a lambda internally
        let result_lambda = AddModule::make_lambda_and_call(a, b);
        // Directly use AddModule::add_and_return_fixed nested with make_lambda_and_call result
        let _ignored = AddModule::add_and_return_fixed(result_lambda, b);
        result_lambda
    }
}


//# run 0xCAFE::AddModule::add_and_return_fixed --args 10u8 15u8


//# run 0xCAFE::AddModule::make_lambda_and_call --args 7u8 8u8


//# run 0xCAFE::CallerModule::call_inline_functions --args 6u8 9u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
