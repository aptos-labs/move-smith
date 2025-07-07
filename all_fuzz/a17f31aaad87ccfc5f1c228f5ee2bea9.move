
//# publish
module 0xCAFE::AddModule {
    public fun add_two_values(a: u8, b: u8): u8 {
        let sum = a + b;
        sum + 10
    }

    public fun call_lambda_plus_one(x: u8): u8 {
        let lambda: |u8| u8 has copy+drop = |v: u8| { v + 1 };
        lambda(x)
    }

    public inline fun inline_add(a: u8, b: u8): u8 {
        a + b
    }

    public fun runner_lambda_test(): u8 {
        let l: |u8, u8| u8 has copy+drop = |x: u8, y: u8| { x * y };
        l(3u8, 4u8)
    }
}


//# publish
module 0xCAFE::CallerModule {
    use 0xCAFE::AddModule;

    public fun call_add(a: u8, b: u8): u8 {
        AddModule::add_two_values(a, b)
    }

    public fun call_inline_nested(a: u8, b: u8): u8 {
        AddModule::inline_add(a, b) + 1
    }
}


//# run 0xCAFE::AddModule::add_two_values --args 15u8 5u8


//# run 0xCAFE::AddModule::call_lambda_plus_one --args 41u8


//# run 0xCAFE::AddModule::runner_lambda_test


//# run 0xCAFE::CallerModule::call_add --args 20u8 22u8


//# run 0xCAFE::CallerModule::call_inline_nested --args 50u8 50u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
