
//# publish
module 0xCAFE::AddModule {
    public fun add_and_return_sum(a: u8, b: u8): u8 {
        let sum = a + b;
        sum
    }

    public fun call_lambda_with_values(): u8 {
        let lambda: |u8, u8| u8 has copy+drop = |x: u8, y: u8| {
            x + y
        };
        lambda(7u8, 8u8)
    }

    public inline fun inline_add(a: u8, b: u8): u8 {
        a + b
    }
}


//# run 0xCAFE::AddModule::add_and_return_sum --args 10u8 20u8


//# run 0xCAFE::AddModule::call_lambda_with_values


//# publish
module 0xCAFE::CallInlineModule {
    use 0xCAFE::AddModule;

    public fun call_external_inline(a: u8, b: u8): u8 {
        let temp_sum = AddModule::inline_add(a, b);
        let result = AddModule::add_and_return_sum(temp_sum, 5u8);
        result
    }
}


//# run 0xCAFE::CallInlineModule::call_external_inline --args 3u8 4u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
