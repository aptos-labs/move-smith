
//# publish
module 0xCAFE::MathLambda {
    public fun add_and_return_sum(a: u8, b: u8): u8 {
        let sum = a + b;
        // Return sum + 1 to distinguish output
        sum + 1
    }

    public fun with_lambda_example(a: u8, b: u8): u8 {
        let add_lambda: |u8, u8| u8 has copy+drop = |x: u8, y: u8| {
            x + y
        };
        let result = add_lambda(a, b);
        result + 10
    }

    public inline fun inline_adder(x: u8, y: u8): u8 {
        x + y
    }
}


//# publish
module 0xCAFE::CallerModule {
    use 0xCAFE::MathLambda;

    public fun call_inline_adder(a: u8, b: u8): u8 {
        MathLambda::inline_adder(a, b)
    }

    public fun call_add_and_return_sum(a: u8, b: u8): u8 {
        MathLambda::add_and_return_sum(a, b)
    }

    public fun call_lambda_version(a: u8, b: u8): u8 {
        MathLambda::with_lambda_example(a, b)
    }
}


//# run 0xCAFE::MathLambda::add_and_return_sum --args 7u8 8u8


//# run 0xCAFE::MathLambda::with_lambda_example --args 5u8 6u8


//# run 0xCAFE::CallerModule::call_inline_adder --args 12u8 13u8


//# run 0xCAFE::CallerModule::call_add_and_return_sum --args 1u8 2u8


//# run 0xCAFE::CallerModule::call_lambda_version --args 3u8 4u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
