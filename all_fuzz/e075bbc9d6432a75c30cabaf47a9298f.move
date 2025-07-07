
//# publish
module 0xCAFE::AddModule {
    public fun add_and_return_sum(a: u8, b: u8): u8 {
        let sum = a + b;
        // Return sum plus a constant 5
        sum + 5
    }

    public fun lambda_example(x: u8): u8 {
        let increment: |u8|u8 has copy+drop = |v: u8| { v + 1 };
        increment(x)
    }

    public inline fun inline_increment(x: u8): u8 {
        x + 1
    }
}


//# publish
module 0xCAFE::CallerModule {
    use 0xCAFE::AddModule;

    public fun call_add_and_return_sum(a: u8, b: u8): u8 {
        AddModule::add_and_return_sum(a, b)
    }

    public fun call_lambda_example(x: u8): u8 {
        AddModule::lambda_example(x)
    }

    public fun nested_inline_call(x: u8): u8 {
        let y = AddModule::inline_increment(x);
        AddModule::inline_increment(y)
    }
}


//# run 0xCAFE::AddModule::add_and_return_sum --args 10u8 15u8


//# run 0xCAFE::AddModule::lambda_example --args 20u8


//# run 0xCAFE::CallerModule::call_add_and_return_sum --args 7u8 8u8


//# run 0xCAFE::CallerModule::call_lambda_example --args 33u8


//# run 0xCAFE::CallerModule::nested_inline_call --args 40u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
