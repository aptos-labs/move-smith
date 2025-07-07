
//# publish
module 0xCAFE::AddModule {
    public fun add_two_values(a: u8, b: u8): u8 {
        let sum = a + b;
        if (sum < 100) {
            sum + 10
        } else {
            sum
        };
        sum
    }

    public fun lambda_example(x: u8): u8 {
        let double_lambda: |u8| u8 has copy+drop = |v: u8| { v * 2 };
        double_lambda(x)
    }

    public inline fun inline_adder(a: u8, b: u8): u8 {
        a + b
    }
}


//# publish
module 0xCAFE::CallerModule {
    use 0xCAFE::AddModule;

    public fun nested_call(x: u8, y: u8): u8 {
        let sum1 = AddModule::inline_adder(x, y);
        let sum2 = AddModule::add_two_values(sum1, 5u8);
        sum2
    }
}


//# run 0xCAFE::AddModule::add_two_values --args 10u8 20u8


//# run 0xCAFE::AddModule::lambda_example --args 15u8


//# run 0xCAFE::CallerModule::nested_call --args 10u8 20u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
// 6248fd9a6f45de6308e0feb6039d899c: Configure the compiler to include backtrace information during errors by setting the 'MOVE_COMPILER_BACKTRACE_ENV_VAR' environment variable.
