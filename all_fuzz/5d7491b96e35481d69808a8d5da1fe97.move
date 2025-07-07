
//# publish
module 0xCAFE::AdderModule {
    public fun add_then_return(a: u8, b: u8): u8 {
        let sum = a + b;
        let result = if (sum > 10) {
            42u8
        } else {
            sum
        };
        result
    }

    public fun lambda_test(): u8 {
        let lambda: |u8, u8| u8 has copy+drop = |x: u8, y: u8| {
            x + y
        };
        lambda(5u8, 7u8)
    }
}


//# run 0xCAFE::AdderModule::add_then_return --args 3u8 4u8


//# run 0xCAFE::AdderModule::add_then_return --args 8u8 5u8


//# run 0xCAFE::AdderModule::lambda_test


//# publish
module 0xCAFE::CallerModule {
    use 0xCAFE::AdderModule;

    public fun call_inline_add(a: u8, b: u8): u8 {
        let res = AdderModule::add_then_return(a, b);
        res
    }

    public fun call_lambda_test(): u8 {
        AdderModule::lambda_test()
    }
}


//# run 0xCAFE::CallerModule::call_inline_add --args 2u8 3u8


//# run 0xCAFE::CallerModule::call_inline_add --args 10u8 15u8


//# run 0xCAFE::CallerModule::call_lambda_test


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
