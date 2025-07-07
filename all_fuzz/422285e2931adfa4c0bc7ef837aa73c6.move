
//# publish
module 0xCAFE::AddModule {
    public fun add_and_return_42(a: u8, b: u8): u8 {
        let sum = a + b;
        assert!(sum == (a + b), 1000); // check addition is correct
        42u8
    }

    public fun lambda_example(x: u8): u8 {
        let increment: |u8| u8 has copy+drop = |n: u8| { n + 1 };
        increment(x)
    }

    public inline fun inline_addition(a: u8, b: u8): u8 {
        a + b
    }
}


//# publish
module 0xCAFE::CallerModule {
    use 0xCAFE::AddModule;

    public fun call_inline_add(a: u8, b: u8): u8 {
        AddModule::inline_addition(a, b)
    }

    public fun call_lambda(a: u8): u8 {
        AddModule::lambda_example(a)
    }

    public fun call_add_and_return(a: u8, b: u8): u8 {
        AddModule::add_and_return_42(a, b)
    }
}


//# run 0xCAFE::AddModule::add_and_return_42 --args 10u8 32u8


//# run 0xCAFE::AddModule::lambda_example --args 10u8


//# run 0xCAFE::CallerModule::call_inline_add --args 7u8 8u8


//# run 0xCAFE::CallerModule::call_lambda --args 20u8


//# run 0xCAFE::CallerModule::call_add_and_return --args 15u8 25u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
