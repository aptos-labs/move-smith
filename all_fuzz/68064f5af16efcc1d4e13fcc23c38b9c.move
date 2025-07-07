
//# publish
module 0xCAFE::AddAndLambda {
    // Test addition of two u8 values and return a specific value
    public fun add_and_return(a: u8, b: u8): u8 {
        let sum = a + b;
        // Return constant 42 after computing sum (to test correct computation but return separate value)
        let _ = sum;
        42u8
    }

    // Function containing a lambda (anonymous function) expression that adds and multiplies two u8s
    public fun do_lambda_ops(x: u8, y: u8): (u8, u8) {
        let op: |u8, u8| (u8, u8) has copy+drop = |a: u8, b: u8| {
            let sum = a + b;
            let product = a * b;
            (sum, product)
        };
        op(x, y)
    }
}


//# run 0xCAFE::AddAndLambda::add_and_return --args 5u8 7u8


//# run 0xCAFE::AddAndLambda::do_lambda_ops --args 6u8 9u8


//# publish
module 0xCAFE::InlineCall {
    use 0xCAFE::AddAndLambda;

    // Function that calls an inline function in AddAndLambda through nested calls
    public inline fun inline_increment(x: u8): u8 {
        x + 1
    }

    public fun call_nested_inline(x: u8): u8 {
        // Call AddAndLambda::add_and_return which internally tests addition but returns 42
        let val = AddAndLambda::add_and_return(x, 1);
        // Then call inline function in this module with that result
        inline_increment(val)
    }
}


//# run 0xCAFE::InlineCall::call_nested_inline --args 10u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
