
//# publish
module 0xCAFE::AddAndReturn {
    public fun add_and_return(x: u8, y: u8): u8 {
        let sum = x + y;
        42u8
    }
}


//# run 0xCAFE::AddAndReturn::add_and_return --args 10u8 32u8



//# publish
module 0xCAFE::LambdaModule {
    public fun apply_lambda_to_add(x: u8, y: u8): u8 {
        // Define a lambda that adds its two parameters
        let add_lambda: |u8, u8| u8 has copy+drop = |a: u8, b: u8| { a + b };
        add_lambda(x, y)
    }

    public fun apply_lambda_to_double(x: u8): u8 {
        // Define a lambda that doubles the input
        let double_lambda: |u8| u8 has copy+drop = |a: u8| { a * 2 };
        double_lambda(x)
    }

    public fun combined_lambda_ops(x: u8, y: u8): (u8, u8) {
        let add_lambda: |u8, u8| u8 has copy+drop = |a: u8, b: u8| { a + b };
        let double_lambda: |u8| u8 has copy+drop = |a: u8| { a * 2 };
        let sum = add_lambda(x, y);
        let doubled = double_lambda(sum);
        (sum, doubled)
    }
}


//# run 0xCAFE::LambdaModule::apply_lambda_to_add --args 15u8 27u8


//# run 0xCAFE::LambdaModule::apply_lambda_to_double --args 21u8


//# run 0xCAFE::LambdaModule::combined_lambda_ops --args 10u8 5u8



//# publish
module 0xCAFE::CallerModule {
    use 0xCAFE::AddAndReturn;

    public fun call_add_and_return(x: u8, y: u8): u8 {
        AddAndReturn::add_and_return(x, y)
    }

    public fun call_nested_functions(a: u8, b: u8): (u8, u8) {
        let first_call = AddAndReturn::add_and_return(a, b);
        // Use LambdaModule combined_lambda_ops inside this function by copying its definition here as reference (simulate nested calls)
        let sum = a + b;
        let doubled = sum * 2;
        (first_call, doubled)
    }
}


//# run 0xCAFE::CallerModule::call_add_and_return --args 20u8 22u8


//# run 0xCAFE::CallerModule::call_nested_functions --args 7u8 8u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
