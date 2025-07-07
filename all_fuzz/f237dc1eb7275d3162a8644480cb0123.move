
//# publish
module 0xCAFE::AddModule {
    // Module to test simple addition and lambdas

    public fun add_two_and_return_sum(x: u8, y: u8): u8 {
        let sum = x + y;
        sum + 10u8
    }

    public fun with_lambda(x: u8, y: u8): u8 {
        let lambda: |u8, u8| u8 has copy+drop = |a: u8, b: u8| {
            a + b
        };
        lambda(x, y)
    }

    public inline fun inline_adder(x: u8, y: u8): u8 {
        x + y
    }
}


//# publish
module 0xCAFE::CallerModule {
    use 0xCAFE::AddModule;

    public fun call_add_and_inline(x: u8, y: u8): u8 {
        let a = AddModule::add_two_and_return_sum(x, y);
        let b = AddModule::inline_adder(x, y);
        a + b
    }

    public fun call_lambda(x: u8, y: u8): u8 {
        AddModule::with_lambda(x, y)
    }
}


//# run 0xCAFE::AddModule::add_two_and_return_sum --args 20u8 22u8


//# run 0xCAFE::AddModule::with_lambda --args 5u8 7u8


//# run 0xCAFE::CallerModule::call_add_and_inline --args 10u8 15u8


//# run 0xCAFE::CallerModule::call_lambda --args 100u8 55u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
