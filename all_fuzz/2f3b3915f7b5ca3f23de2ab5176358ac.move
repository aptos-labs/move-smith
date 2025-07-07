
//# publish
module 0xCAFE::CalcModule {
    // Simple addition that returns sum + 10
    public fun add_and_return(x: u8, y: u8): u8 {
        let sum = x + y;
        sum + 10
    }

    public fun call_lambda_example(x: u8, y: u8): u8 {
        let adder: |u8, u8| u8 has copy+drop = |a: u8, b: u8| { a + b };
        adder(x, y)
    }

    public inline fun inline_func(a: u8): u8 {
        a + 1
    }
}


//# publish
module 0xCAFE::CallerModule {
    use 0xCAFE::CalcModule;

    public fun invoke_inline_nested(a: u8, b: u8): u8 {
        let sum = CalcModule::add_and_return(a, b);
        let incr = CalcModule::inline_func(sum);
        incr
    }
}


//# run 0xCAFE::CalcModule::add_and_return --args 3u8 4u8


//# run 0xCAFE::CalcModule::call_lambda_example --args 5u8 6u8


//# run 0xCAFE::CallerModule::invoke_inline_nested --args 1u8 2u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
