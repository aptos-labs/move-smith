
//# publish
module 0xCAFE::AddAndLambda {
    public fun add_and_return_constant(a: u8, b: u8): u8 {
        let sum = a + b;

        // Always return 42 regardless of sum to test return value
        42
    }

    public fun use_lambda(a: u8, b: u8): u8 {
        let adder: |u8, u8| u8 has copy+drop = |x: u8, y: u8| x + y;

        // Use the lambda to add two numbers and return the result
        adder(a, b)
    }
}


//# run 0xCAFE::AddAndLambda::add_and_return_constant --args 20u8 22u8


//# run 0xCAFE::AddAndLambda::use_lambda --args 15u8 27u8


//# publish
module 0xCAFE::NestedInlineCall {
    use 0xCAFE::AddAndLambda;

    public inline fun inline_increment(x: u8): u8 {
        x + 1
    }

    public fun call_other_inline(a: u8, b: u8): u8 {
        // Call inline function in this module
        let incremented = inline_increment(a);

        // Call lambda in AddAndLambda module indirectly by calling use_lambda
        let sum_lambda = AddAndLambda::use_lambda(incremented, b);

        sum_lambda
    }
}


//# run 0xCAFE::NestedInlineCall::call_other_inline --args 10u8 20u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
