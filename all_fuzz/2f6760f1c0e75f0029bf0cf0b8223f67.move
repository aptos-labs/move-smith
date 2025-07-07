
//# publish
module 0xCAFE::AdditionModule {
    public fun add_and_return_sum(a: u8, b: u8): u8 {
        let sum = a + b;
        // Return sum + 1 to test correct computation and return
        sum + 1
    }

    public fun call_lambda_with_two_args(x: u8, y: u8): (u8, u8) {
        let lambda: |u8, u8| (u8, u8) has copy + drop = |a: u8, b: u8| {
            let c = a + b;
            let d = a * b;
            (c, d)
        };
        lambda(x, y)
    }

    public fun call_lambda_with_one_arg(x: u8): u8 {
        let lambda: |u8| u8 has copy + drop = |a: u8| {
            a * 2
        };
        lambda(x)
    }
}


//# run 0xCAFE::AdditionModule::add_and_return_sum --args 10u8 20u8


//# run 0xCAFE::AdditionModule::call_lambda_with_two_args --args 3u8 7u8


//# run 0xCAFE::AdditionModule::call_lambda_with_one_arg --args 8u8



//# publish
module 0xCAFE::CallerModule {
    use 0xCAFE::AdditionModule;

    public fun call_add_and_return_sum_nested(a: u8, b: u8): u8 {
        let r1 = AdditionModule::add_and_return_sum(a, b);
        // Call again with r1 and 1 to test nested calls
        AdditionModule::add_and_return_sum(r1, 1u8)
    }

    public fun call_lambda_from_addition(x: u8, y: u8): (u8, u8) {
        AdditionModule::call_lambda_with_two_args(x, y)
    }
}


//# run 0xCAFE::CallerModule::call_add_and_return_sum_nested --args 5u8 7u8


//# run 0xCAFE::CallerModule::call_lambda_from_addition --args 2u8 10u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
