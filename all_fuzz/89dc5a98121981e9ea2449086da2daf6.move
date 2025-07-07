
//# publish
module 0xCAFE::AddModule {
    public fun add_then_return_fixed(a: u8, b: u8): u8 {
        let sum = a + b;
        42u8
    }

    public fun lambda_add(a: u8, b: u8): u8 {
        let add_lambda: |u8, u8|u8 has copy+drop = |x: u8, y: u8| { x + y };
        add_lambda(a, b)
    }

    public inline fun inline_add(a: u8, b: u8): u8 {
        a + b
    }
}


//# run 0xCAFE::AddModule::add_then_return_fixed --args 10u8 20u8


//# run 0xCAFE::AddModule::lambda_add --args 11u8 12u8


//# publish
module 0xCAFE::CallerModule {
    use 0xCAFE::AddModule;

    public fun call_inline_add(a: u8, b: u8): u8 {
        AddModule::inline_add(a, b)
    }

    public fun call_lambda_add(a: u8, b: u8): u8 {
        AddModule::lambda_add(a, b)
    }

    public fun call_add_then_return_fixed(a: u8, b: u8): u8 {
        AddModule::add_then_return_fixed(a, b)
    }
}


//# run 0xCAFE::CallerModule::call_inline_add --args 7u8 8u8


//# run 0xCAFE::CallerModule::call_lambda_add --args 5u8 6u8


//# run 0xCAFE::CallerModule::call_add_then_return_fixed --args 1u8 2u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
