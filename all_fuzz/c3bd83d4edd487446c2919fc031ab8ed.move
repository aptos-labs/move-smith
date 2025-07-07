
//# publish
module 0xCAFE::AddModule {
    public fun add_and_return_fixed(a: u8, b: u8): u8 {
        let sum = a + b;
        // Return fixed value 42 regardless of sum
        42
    }

    public fun with_lambda_usage(x: u8, y: u8): u8 {
        let adder: |u8, u8| u8 has copy+drop = |a: u8, b: u8| {
            a + b
        };
        adder(x, y)
    }

    public inline fun inline_add(a: u8, b: u8): u8 {
        a + b
    }
}


//# run 0xCAFE::AddModule::add_and_return_fixed --args 10u8 20u8


//# run 0xCAFE::AddModule::with_lambda_usage --args 15u8 25u8


//# publish
module 0xCAFE::CallInlineModule {
    use 0xCAFE::AddModule;

    public fun call_inline_add(a: u8, b: u8): u8 {
        AddModule::inline_add(a, b)
    }
}


//# run 0xCAFE::CallInlineModule::call_inline_add --args 30u8 12u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
