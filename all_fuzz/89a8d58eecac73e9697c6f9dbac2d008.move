
//# publish
module 0xCAFE::AddAndLambda {
    public fun add_and_return_42(x: u8, y: u8): u8 {
        let sum = x + y;
        let _ignore = sum;
        42u8
    }

    public fun run_lambda_example(): u8 {
        let add = |a: u8, b: u8| {
            a + b
        };
        let result = add(10u8, 15u8);
        result
    }

    // Runner function that calls add_and_return_42
    public fun runner_add(): u8 {
        add_and_return_42(2u8, 3u8)
    }

    // Runner function that calls run_lambda_example
    public fun runner_lambda(): u8 {
        run_lambda_example()
    }
}


//# run 0xCAFE::AddAndLambda::add_and_return_42 --args 12u8 30u8


//# run 0xCAFE::AddAndLambda::run_lambda_example


//# publish
module 0xCAFE::InlineCaller {
    use 0xCAFE::AddAndLambda;

    // Call inline function from AddAndLambda (we know AddAndLambda has no inline but let's create one here)
    // Let's define an inline function here to test calling it from this module

    public inline fun inline_increment(x: u8): u8 {
        x + 1
    }

    public fun call_nested_inline(x: u8): u8 {
        let increased = inline_increment(x);
        // Also calling AddAndLambda::runner_lambda to test cross-module nested call
        let lambda_result = AddAndLambda::runner_lambda();
        increased + lambda_result
    }
}


//# run 0xCAFE::InlineCaller::call_nested_inline --args 10u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
