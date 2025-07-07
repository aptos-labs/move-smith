
//# publish
module 0xCAFE::CalcModule {
    public fun add_and_return_specific_value(x: u8, y: u8): u8 {
        let sum = x + y;
        let specific = 42u8;
        sum + specific
    }

    public fun with_lambda(x: u8, y: u8): u8 {
        let adder: |u8, u8| u8 has copy+drop = |a: u8, b: u8| {
            a + b
        };
        adder(x, y)
    }

    public inline fun inline_add(a: u8, b: u8): u8 {
        a + b
    }
}


//# run 0xCAFE::CalcModule::add_and_return_specific_value --args 10u8 20u8


//# run 0xCAFE::CalcModule::with_lambda --args 7u8 8u8


//# publish
module 0xCAFE::CallerModule {
    use 0xCAFE::CalcModule;

    public fun call_inline_add_and_add_extra(a: u8, b: u8): u8 {
        let res = CalcModule::inline_add(a, b);
        res + 5u8
    }
}


//# run 0xCAFE::CallerModule::call_inline_add_and_add_extra --args 15u8 10u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
