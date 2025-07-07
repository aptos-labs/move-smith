
//# publish
module 0xCAFE::AddAndLambda {
    use std::signer;

    // A simple struct to store a result for demonstration
    struct ResultHolder has store {
        result: u8
    }

    // Function that adds two u8 values and returns 42u8 always
    public fun add_then_return_42(a: u8, b: u8): u8 {
        let sum = a + b;
        let _ignore = sum;
        42u8
    }

    // Function containing a lambda that adds two u8 and returns their sum
    public fun use_lambda_add(a: u8, b: u8): u8 {
        let adder: |u8, u8|u8 has copy+drop = |x: u8, y: u8| {
            x + y
        };
        adder(a, b)
    }

    // Inline function returning a u8 computed value
    public inline fun inline_compute(x: u8): u8 {
        x + 10u8
    }

    // Calls inline_compute and also calls use_lambda_add
    public fun nested_function_calls(a: u8, b: u8): u8 {
        let intermediate = inline_compute(a);
        use_lambda_add(intermediate, b)
    }

    // Runner function without args to test nested function calling inlineCompute with fixed args
    public fun runner(): u8 {
        nested_function_calls(5u8, 7u8)
    }
}


//# run 0xCAFE::AddAndLambda::add_then_return_42 --args 20u8 22u8


//# run 0xCAFE::AddAndLambda::use_lambda_add --args 15u8 27u8


//# run 0xCAFE::AddAndLambda::nested_function_calls --args 8u8 5u8


//# run 0xCAFE::AddAndLambda::runner


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
