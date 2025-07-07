
//# publish
module 0xCAFE::AddAndReturn {
    // A simple function that adds two u8 values and returns a constant 42u8
    public fun add_and_return(_a: u8, _b: u8): u8 {
        let _sum = _a + _b;
        42u8
    }

    // Function containing a lambda that adds two u8 values and returns the sum plus 10
    public fun lambda_add_plus_ten(): u8 {
        let add_lambda: |u8, u8| u8 has copy+drop = |x: u8, y: u8| x + y;
        let sum = add_lambda(5u8, 7u8);
        sum + 10u8
    }

    // Runner function to call without arguments
    public fun runner(): u8 {
        add_and_return(1u8, 2u8)
    }
}


//# run 0xCAFE::AddAndReturn::add_and_return --args 10u8 15u8


//# run 0xCAFE::AddAndReturn::lambda_add_plus_ten


//# run 0xCAFE::AddAndReturn::runner


//# publish
module 0xCAFE::CallerModule {
    use 0xCAFE::AddAndReturn;

    // Calls the lambda_add_plus_ten function from AddAndReturn module and returns its result plus 5
    public fun call_lambda_plus_five(): u8 {
        let val = AddAndReturn::lambda_add_plus_ten();
        val + 5u8
    }

    // Calls add_and_return nested twice and sums their results
    public fun nested_add_calls(): u8 {
        let val1 = AddAndReturn::add_and_return(3u8, 4u8);
        let val2 = AddAndReturn::add_and_return(5u8, 6u8);
        val1 + val2
    }

    // Runner function that runs both nested calls and returns sum
    public fun runner(): u8 {
        nested_add_calls()
    }
}


//# run 0xCAFE::CallerModule::call_lambda_plus_five


//# run 0xCAFE::CallerModule::nested_add_calls


//# run 0xCAFE::CallerModule::runner


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
