
//# publish
module 0xCAFE::AddAndLambda {
    use std::signer;

    // A simple function to add two u8 values and return a fixed u8 result
    public fun add_then_return_fixed(x: u8, y: u8): u8 {
        let _sum = x + y;
        // Return fixed value, e.g., 42u8
        42u8
    }

    // A function with lambda that takes two u8 and returns their product as u8
    public fun lambda_product(x: u8, y: u8): u8 {
        let multiply: |u8, u8|u8 has copy+drop = |a: u8, b: u8| {
            a * b
        };
        multiply(x, y)
    }

    // A runner function with lambda that returns a tuple (u8, u8)
    public fun lambda_sum_and_diff(x: u8, y: u8): (u8, u8) {
        let sum_diff: |u8, u8| (u8, u8) has copy+drop = |a: u8, b: u8| {
            let s = a + b;
            let d = if (a > b) { a - b } else { b - a };
            (s, d)
        };
        sum_diff(x, y)
    }
}


//# publish
module 0xCAFE::NestedInlineCalls {
    use 0xCAFE::AddAndLambda;

    // Inline function returning sum of two u8 values
    public inline fun inline_sum(a: u8, b: u8): u8 {
        a + b
    }

    // Inline function calling another inline function in AddAndLambda
    public inline fun inline_nested_calls(a: u8, b: u8): u8 {
        let c = inline_sum(a, b);
        let d = AddAndLambda::lambda_product(c, 2u8);
        d
    }

    public fun runner(): u8 {
        inline_nested_calls(3u8, 4u8)
    }
}


//# run 0xCAFE::AddAndLambda::add_then_return_fixed --args 10u8 20u8


//# run 0xCAFE::AddAndLambda::lambda_product --args 6u8 7u8


//# run 0xCAFE::AddAndLambda::lambda_sum_and_diff --args 9u8 4u8


//# run 0xCAFE::NestedInlineCalls::runner


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
