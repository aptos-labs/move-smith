
//# publish
module 0xCAFE::MathOperations {
    // Contains functions to test addition and lambdas

    public fun add_and_return_fixed_value(a: u8, b: u8): u8 {
        let sum = a + b;
        42u8
    }

    public fun lambda_add(a: u8, b: u8): u8 {
        let add_lambda: |u8, u8| u8 has copy+drop = |x: u8, y: u8| {
            x + y
        };
        add_lambda(a, b)
    }

    public fun lambda_return_sum_plus_fixed(a: u8, b: u8): u8 {
        let sum = lambda_add(a, b);
        sum + 5u8
    }
}


//# run 0xCAFE::MathOperations::add_and_return_fixed_value --args 10u8 32u8


//# run 0xCAFE::MathOperations::lambda_add --args 15u8 17u8


//# run 0xCAFE::MathOperations::lambda_return_sum_plus_fixed --args 7u8 8u8



//# publish
module 0xCAFE::NestedCall {
    use 0xCAFE::MathOperations;

    public inline fun inline_add_twice(x: u8, y: u8): u8 {
        let first = MathOperations::lambda_add(x, y);
        let second = MathOperations::lambda_add(first, y);
        second
    }

    public fun call_inline_from_module(x: u8, y: u8): u8 {
        inline_add_twice(x, y)
    }
}


//# run 0xCAFE::NestedCall::call_inline_from_module --args 3u8 4u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
