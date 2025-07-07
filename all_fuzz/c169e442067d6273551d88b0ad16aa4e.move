
//# publish
module 0xCAFE::AddModule {
    // Simple add function that returns x + y + 10u8
    public fun add_and_offset(x: u8, y: u8): u8 {
        let sum = x + y;
        sum + 10u8
    }

    public fun call_lambda(x: u8, y: u8): u8 {
        let lambda: |u8, u8|u8 has copy+drop = |a: u8, b: u8| {
            a + b + 5u8
        };
        lambda(x, y)
    }

    public inline fun inline_add(a: u8, b: u8): u8 {
        a + b
    }
}


//# publish
module 0xCAFE::CallerModule {
    use 0xCAFE::AddModule;

    public fun call_add_and_offset(x: u8, y: u8): u8 {
        AddModule::add_and_offset(x, y)
    }

    public fun nested_inline_call(a: u8, b: u8): u8 {
        let temp = AddModule::inline_add(a, b);
        temp + 20u8
    }

    public fun call_lambda_through_add(x: u8, y: u8): u8 {
        AddModule::call_lambda(x, y)
    }
}


//# run 0xCAFE::AddModule::add_and_offset --args 5u8 7u8


//# run 0xCAFE::AddModule::call_lambda --args 3u8 4u8


//# run 0xCAFE::CallerModule::call_add_and_offset --args 10u8 15u8


//# run 0xCAFE::CallerModule::nested_inline_call --args 7u8 8u8


//# run 0xCAFE::CallerModule::call_lambda_through_add --args 2u8 3u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
