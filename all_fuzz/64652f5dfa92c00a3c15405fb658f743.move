
//# publish
module 0xCAFE::CalcModule {
    public fun add_two_u8(x: u8, y: u8): u8 {
        let sum = x + y;
        // Returns sum plus 10 to verify calculation + specific value
        sum + 10
    }

    public fun run_lambda_example(x: u8): u8 {
        let lambda: |u8| u8 has copy+drop = |a: u8| {
            a * 2u8
        };
        lambda(x)
    }

    public inline fun inline_increment(a: u8): u8 {
        a + 1u8
    }
}


//# run 0xCAFE::CalcModule::add_two_u8 --args 5u8 7u8


//# run 0xCAFE::CalcModule::run_lambda_example --args 6u8


//# publish
module 0xCAFE::CallerModule {
    use 0xCAFE::CalcModule;

    public fun call_inline_increment(x: u8): u8 {
        CalcModule::inline_increment(x)
    }
}


//# run 0xCAFE::CallerModule::call_inline_increment --args 20u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
