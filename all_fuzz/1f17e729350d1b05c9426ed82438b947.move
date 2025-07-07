
//# publish
module 0xCAFE::AdditionModule {
    public fun add_and_return_sum(a: u8, b: u8): u8 {
        let sum = a + b;
        sum
    }

    public fun lambda_demo(x: u8): u8 {
        let square: |u8|u8 has copy+drop = |n: u8| {
            n * n
        };
        square(x)
    }
}


//# publish
module 0xCAFE::CallerModule {
    use 0xCAFE::AdditionModule;

    public fun call_add_and_double(a: u8, b: u8): u8 {
        let sum = AdditionModule::add_and_return_sum(a, b);
        // Double the sum
        sum * 2
    }

    public fun call_lambda_demo(x: u8): u8 {
        AdditionModule::lambda_demo(x)
    }

    public inline fun inline_no_arg(): u8 {
        42u8
    }

    public fun call_inline_no_arg_plus(a: u8): u8 {
        let val = inline_no_arg();
        val + a
    }
}


//# run 0xCAFE::AdditionModule::add_and_return_sum --args 10u8 15u8


//# run 0xCAFE::AdditionModule::lambda_demo --args 7u8


//# run 0xCAFE::CallerModule::call_add_and_double --args 12u8 3u8


//# run 0xCAFE::CallerModule::call_lambda_demo --args 8u8


//# run 0xCAFE::CallerModule::call_inline_no_arg_plus --args 10u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
