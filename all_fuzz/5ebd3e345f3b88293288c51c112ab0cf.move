
//# publish
module 0xCAFE::AdditionModule {
    public fun add_and_return(x: u8, y: u8): u8 {
        let sum = x + y;
        if (sum > 10) {
            42u8
        } else {
            sum
        }
    }

    public fun use_lambda(x: u8, y: u8): u8 {
        let f: |u8, u8| u8 has copy+drop = |a: u8, b: u8| {
            a + b
        };
        f(x, y)
    }

    public inline fun inline_add(a: u8, b: u8): u8 {
        a + b
    }
}


//# run 0xCAFE::AdditionModule::add_and_return --args 3u8 4u8


//# run 0xCAFE::AdditionModule::add_and_return --args 8u8 5u8


//# run 0xCAFE::AdditionModule::use_lambda --args 7u8 2u8


//# publish
module 0xCAFE::CallerModule {
    use 0xCAFE::AdditionModule;

    public fun call_inline_and_lambda(x: u8, y: u8): (u8, u8) {
        let sum = AdditionModule::inline_add(x, y);
        let lambda_result = AdditionModule::use_lambda(x, y);
        (sum, lambda_result)
    }
}


//# run 0xCAFE::CallerModule::call_inline_and_lambda --args 12u8 18u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
