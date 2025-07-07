
//# publish
module 0xCAFE::AddModule {
    public fun add_and_return_constant(a: u8, b: u8): u8 {
        let sum = a + b;
        let _ = sum;
        42u8
    }

    public fun lambda_demo(x: u8): u8 {
        let increment: |u8|u8 has copy+drop = |a: u8| { a + 1 };
        let double: |u8|u8 has copy+drop = |a: u8| { a * 2 };
        let y = increment(x);
        let z = double(y);
        z
    }

    public inline fun inline_func(x: u8): u8 {
        x + 3
    }
}


//# publish
module 0xCAFE::CallerModule {
    use 0xCAFE::AddModule;

    public fun call_add_and_return_constant(a: u8, b: u8): u8 {
        AddModule::add_and_return_constant(a, b)
    }

    public fun call_lambda_demo(x: u8): u8 {
        AddModule::lambda_demo(x)
    }

    public fun call_inline_func_twice(a: u8): u8 {
        let first = AddModule::inline_func(a);
        let second = AddModule::inline_func(first);
        second
    }
}


//# run 0xCAFE::AddModule::add_and_return_constant --args 10u8 32u8


//# run 0xCAFE::AddModule::lambda_demo --args 4u8


//# run 0xCAFE::CallerModule::call_add_and_return_constant --args 5u8 20u8


//# run 0xCAFE::CallerModule::call_lambda_demo --args 6u8


//# run 0xCAFE::CallerModule::call_inline_func_twice --args 7u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
