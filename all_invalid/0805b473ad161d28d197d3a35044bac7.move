
//# publish
module 0xCAFE::MathFunctions {
    // This module tests addition and inline function usage.

    public fun add_u8_values(a: u8, b: u8): u8 {
        let sum = a + b;
        // Returns sum + 1 to distinguish result
        sum + 1u8
    }

    public inline fun inline_increment(x: u8): u8 {
        x + 1u8
    }
}



//# run 0xCAFE::MathFunctions::add_u8_values --args 10u8 20u8



//# publish
module 0xCAFE::LambdaFunctions {
    // This module tests lambda expressions usage.

    public fun call_lambda(a: u8, b: u8): u8 {
        let double_sum: |u8, u8| u8 has copy + drop = |x: u8, y: u8| {
            let s = x + y;
            s * 2u8
        };
        double_sum(a, b)
    }

    // Modified function: define lambda internally, avoid passing closure argument.
    public fun call_lambda_inline_arg(val: u8): u8 {
        let lambda: |u8|u8 has copy + drop = |x: u8| {
            x + 1u8
        };
        lambda(val)
    }
}



//# run 0xCAFE::LambdaFunctions::call_lambda --args 7u8 3u8



//# run 0xCAFE::LambdaFunctions::call_lambda_inline_arg --args 5u8



//# publish
module 0xCAFE::NestedCalls {
    use 0xCAFE::MathFunctions;
    use 0xCAFE::LambdaFunctions;

    public fun nested_call(a: u8, b: u8): u8 {
        // Call add_u8_values from MathFunctions
        let sum_plus_one = MathFunctions::add_u8_values(a, b);

        // Define a lambda that calls inline_increment
        let lambda_increment: |u8|u8 has copy + drop = |v: u8| MathFunctions::inline_increment(v);

        // Call lambda with sum_plus_one as argument
        let result = LambdaFunctions::call_lambda_inline_arg(lambda_increment, sum_plus_one);

        // Return result
        result
    }
}



//# run 0xCAFE::NestedCalls::nested_call --args 10u8 20u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
