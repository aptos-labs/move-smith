
//# publish
module 0xCAFE::AddModule {
    public fun add_two_values(a: u8, b: u8): u8 {
        let sum = a + b;
        // Return sum + 1 as a specific value
        sum + 1
    }

    public fun with_lambda(a: u8, b: u8): u8 {
        let add_lambda: |u8, u8| u8 has copy+drop = |x: u8, y: u8| {
            x + y
        };
        add_lambda(a, b)
    }

    public inline fun inline_add(a: u8, b: u8): u8 {
        a + b
    }
}


//# publish
module 0xCAFE::CallerModule {
    use 0xCAFE::AddModule;

    public fun call_inline_add(a: u8, b: u8): u8 {
        let inner_sum = AddModule::inline_add(a, b);
        inner_sum + 1
    }

    public fun call_add_two_values(a: u8, b: u8): u8 {
        AddModule::add_two_values(a, b)
    }

    public fun test_lambda_usage(a: u8, b: u8): u8 {
        AddModule::with_lambda(a, b)
    }
}


//# run 0xCAFE::AddModule::add_two_values --args 10u8 20u8


//# run 0xCAFE::AddModule::with_lambda --args 15u8 25u8


//# run 0xCAFE::CallerModule::call_inline_add --args 5u8 10u8


//# run 0xCAFE::CallerModule::call_add_two_values --args 7u8 8u8


//# run 0xCAFE::CallerModule::test_lambda_usage --args 12u8 3u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
