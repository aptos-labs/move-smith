
//# publish
module 0xCAFE::AddAndLambda {
    // Test addition of two u8 values and return a specific value
    public fun add_and_return(a: u8, b: u8): u8 {
        let sum = a + b;
        // Return sum + 10 as a fixed formula
        sum + 10
    }

    // Function containing lambda (anonymous function) expressions
    public fun call_lambda_with_inputs(x: u8, y: u8): u8 {
        let add_lambda: |u8, u8| u8 has copy+drop = |a: u8, b: u8| {
            a + b
        };
        let mul_lambda: |u8, u8| u8 has copy+drop = |a: u8, b: u8| {
            a * b
        };

        let added = add_lambda(x, y);
        let multiplied = mul_lambda(x, y);

        // Return added + multiplied
        added + multiplied
    }
}


//# publish
module 0xCAFE::InlineCaller {
    use 0xCAFE::AddAndLambda;

    // Call the inline function defined here to allow nested calls
    public inline fun inline_sum(a: u8, b: u8): u8 {
        a + b
    }

    // Function that calls AddAndLambda::add_and_return and also its own inline function
    public fun nested_calls(x: u8, y: u8): u8 {
        let intermediate = AddAndLambda::add_and_return(x, y);
        let inline_result = inline_sum(x, y);
        // Return sum of both results
        intermediate + inline_result
    }
}


//# run 0xCAFE::AddAndLambda::add_and_return --args 5u8 7u8


//# run 0xCAFE::AddAndLambda::call_lambda_with_inputs --args 3u8 4u8


//# run 0xCAFE::InlineCaller::nested_calls --args 6u8 8u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
