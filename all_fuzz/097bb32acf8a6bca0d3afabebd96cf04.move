
//# publish
module 0xCAFE::AdditionModule {
    public fun add_and_return_fixed(x: u8, y: u8): u8 {
        let sum = x + y;
        let fixed_value = 42u8;
        fixed_value
    }

    public fun lambda_example(): u8 {
        let add: |u8, u8| u8 has copy+drop = |a: u8, b: u8| {
            a + b
        };
        add(10u8, 15u8)
    }

    // Runner function calling lambda_example without args
    public fun runner_lambda(): u8 {
        lambda_example()
    }
}


//# run 0xCAFE::AdditionModule::add_and_return_fixed --args 10u8 20u8


//# run 0xCAFE::AdditionModule::runner_lambda


//# publish
module 0xCAFE::CallerModule {
    use 0xCAFE::AdditionModule;

    // Call inline function in AdditionModule: lambda_example (indirectly through runner_lambda)
    public fun call_lambda_from_other_module(): u8 {
        AdditionModule::runner_lambda()
    }

    // Call add_and_return_fixed also
    public fun call_add_and_return_fixed(): u8 {
        AdditionModule::add_and_return_fixed(5u8, 7u8)
    }

    // Runner function to call both and combine results
    public fun runner_combined(): (u8, u8) {
        let r1 = call_lambda_from_other_module();
        let r2 = call_add_and_return_fixed();
        (r1, r2)
    }
}


//# run 0xCAFE::CallerModule::call_lambda_from_other_module


//# run 0xCAFE::CallerModule::call_add_and_return_fixed


//# run 0xCAFE::CallerModule::runner_combined


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
