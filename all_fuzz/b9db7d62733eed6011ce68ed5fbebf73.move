
//# publish
module 0xCAFE::MathUtils {
    // Module to test addition of two u8 values and inline function calls

    public inline fun add_u8(a: u8, b: u8): u8 {
        a + b
    }

    public fun add_and_return_const(a: u8, b: u8): u8 {
        let sum = add_u8(a, b);
        // Return some fixed value independent of sum, here constant 42
        42
    }

    public fun with_lambda_usage(a: u8, b: u8): u8 {
        let lambda: |u8, u8| u8 has copy+drop = |x: u8, y: u8| { x + y };
        lambda(a, b)
    }
}


//# run 0xCAFE::MathUtils::add_and_return_const --args 5u8 10u8


//# run 0xCAFE::MathUtils::with_lambda_usage --args 7u8 8u8


//# publish
module 0xCAFE::LambdaCaller {
    use 0xCAFE::MathUtils;

    public fun call_add_and_lambda(): (u8, u8) {
        let a = 12u8;
        let b = 30u8;

        // Call inline function defined in MathUtils module
        let sum = MathUtils::add_u8(a, b);

        // Call lambda function defined in MathUtils module
        let lambda_result = MathUtils::with_lambda_usage(b, a);

        (sum, lambda_result)
    }
}


//# run 0xCAFE::LambdaCaller::call_add_and_lambda


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
