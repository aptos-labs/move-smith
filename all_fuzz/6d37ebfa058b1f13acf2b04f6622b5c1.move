
//# publish
module 0xCAFE::LambdaModule {
    public fun add_and_return_fixed(a: u8, b: u8): u8 {
        let sum = a + b;
        // Return fixed value to confirm operation
        42u8
    }

    public fun call_lambda(x: u8): u8 {
        let lambda: |u8|u8 has copy+drop = |v: u8| {
            v * 2
        };
        lambda(x)
    }
}


//# publish
module 0xCAFE::NestedCallModule {
    use 0xCAFE::LambdaModule;

    public inline fun inline_add(a: u8, b: u8): u8 {
        a + b
    }

    public fun call_inline_and_lambda(a: u8, b: u8): u8 {
        let add_result = inline_add(a, b);
        let lambda_result = LambdaModule::call_lambda(add_result);
        lambda_result
    }
}


//# run 0xCAFE::LambdaModule::add_and_return_fixed --args 10u8 20u8


//# run 0xCAFE::LambdaModule::call_lambda --args 21u8


//# run 0xCAFE::NestedCallModule::call_inline_and_lambda --args 5u8 10u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
