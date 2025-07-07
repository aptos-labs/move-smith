
//# publish
module 0xCAFE::LambdaModule {
    public fun add_and_return_constant(a: u8, b: u8): u8 {
        let sum = a + b;
        let result = if (sum > 0) {
            42u8
        } else {
            0u8
        };
        result
    }

    public fun lambda_example(x: u8): u8 {
        let anon = |v: u8| v * 2;
        anon(x)
    }

    public fun nested_lambda_and_call(a: u8, b: u8): u8 {
        let multiply = |x: u8, y: u8| x * y;
        let apply_then_add = |f: |u8, u8|u8, x: u8, y: u8| {
            let product = f(x, y);
            product + 10u8
        };
        apply_then_add(multiply, a, b)
    }

    public inline fun inline_increment(x: u8): u8 {
        x + 1
    }
}


//# publish
module 0xCAFE::CallerModule {
    use 0xCAFE::LambdaModule;

    public fun call_inline_increment(x: u8): u8 {
        LambdaModule::inline_increment(x)
    }

    public fun call_lambda_example(x: u8): u8 {
        LambdaModule::lambda_example(x)
    }

    public fun call_add_and_return(a: u8, b: u8): u8 {
        LambdaModule::add_and_return_constant(a, b)
    }

    public fun call_nested_lambda_and_call(a: u8, b: u8): u8 {
        LambdaModule::nested_lambda_and_call(a, b)
    }
}


//# run 0xCAFE::LambdaModule::add_and_return_constant --args 10u8 20u8


//# run 0xCAFE::LambdaModule::lambda_example --args 21u8


//# run 0xCAFE::LambdaModule::nested_lambda_and_call --args 3u8 4u8


//# run 0xCAFE::CallerModule::call_inline_increment --args 5u8


//# run 0xCAFE::CallerModule::call_lambda_example --args 10u8


//# run 0xCAFE::CallerModule::call_add_and_return --args 7u8 8u8


//# run 0xCAFE::CallerModule::call_nested_lambda_and_call --args 2u8 6u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
