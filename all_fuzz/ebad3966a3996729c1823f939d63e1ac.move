
//# publish
module 0xCAFE::LambdaAdd {
    // This module defines a function to add two u8 values and return a specific result.
    public fun add_and_return_sum(a: u8, b: u8): u8 {
        let sum = a + b;
        // Return sum + 10 for testing purposes
        sum + 10
    }

    // Function containing a lambda expression to add two u8 and multiply the result by 2.
    public fun lambda_double_sum(a: u8, b: u8): u8 {
        let add = |x: u8, y: u8| x + y;
        let sum = add(a, b);
        sum * 2
    }
}


//# run 0xCAFE::LambdaAdd::add_and_return_sum --args 12u8 34u8


//# run 0xCAFE::LambdaAdd::lambda_double_sum --args 6u8 7u8


//# publish
module 0xCAFE::CallerModule {
    use 0xCAFE::LambdaAdd;

    // Calls the add_and_return_sum function from LambdaAdd module multiple times,
    // then calls a nested inline function defined here.
    public inline fun inline_add(a: u8, b: u8): u8 {
        LambdaAdd::add_and_return_sum(a, b)
    }

    public fun call_nested_and_return(a: u8, b: u8): u8 {
        let first_call = LambdaAdd::add_and_return_sum(a, b);
        let second_call = LambdaAdd::lambda_double_sum(a, b);
        let nested_call = inline_add(a, b);
        first_call + second_call + nested_call
    }
}


//# run 0xCAFE::CallerModule::call_nested_and_return --args 3u8 7u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
