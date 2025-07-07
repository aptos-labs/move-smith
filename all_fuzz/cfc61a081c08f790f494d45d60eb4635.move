
//# publish
module 0xCAFE::AddModule {
    public fun add_then_return_fixed(a: u8, b: u8): u8 {
        let sum = a + b;
        let fixed_value = 42u8;
        // We ignore sum and just return fixed value for test purpose
        fixed_value
    }

    public fun lambda_example(x: u8): u8 {
        let add_one: |u8|u8 has copy+drop = |a: u8| { a + 1 };
        add_one(x)
    }

    public inline fun inline_add(x: u8, y: u8): u8 {
        x + y
    }
}


//# publish
module 0xCAFE::CallerModule {
    use 0xCAFE::AddModule;

    public fun call_inline_add(x: u8, y: u8): u8 {
        let result = AddModule::inline_add(x, y);
        result
    }

    public fun call_lambda_example(x: u8): u8 {
        AddModule::lambda_example(x)
    }
}


//# run 0xCAFE::AddModule::add_then_return_fixed --args 10u8 32u8


//# run 0xCAFE::AddModule::lambda_example --args 5u8


//# run 0xCAFE::CallerModule::call_inline_add --args 7u8 8u8


//# run 0xCAFE::CallerModule::call_lambda_example --args 9u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
