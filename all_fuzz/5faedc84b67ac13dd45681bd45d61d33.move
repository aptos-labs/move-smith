
//# publish
module 0xCAFE::LambdaAdd {
    public fun add_two_values(a: u8, b: u8): u8 {
        let sum = a + b;
        // Return sum + 10 to have a specific return value to check
        sum + 10
    }

    public fun test_lambda_expression(a: u8, b: u8): u8 {
        let lambda: |u8, u8|u8 has copy+drop = |x: u8, y: u8| {
            x + y
        };
        lambda(a, b)
    }
}


//# run 0xCAFE::LambdaAdd::add_two_values --args 5u8 7u8


//# run 0xCAFE::LambdaAdd::test_lambda_expression --args 3u8 4u8


//# publish
module 0xCAFE::NestedInlineCall {
    use 0xCAFE::LambdaAdd;

    public inline fun inline_add(a: u8, b: u8): u8 {
        LambdaAdd::add_two_values(a, b)
    }

    public fun call_inline_add() {
        let result = inline_add(2, 3);
        let _ = result;
    }
}


//# run 0xCAFE::NestedInlineCall::call_inline_add


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
