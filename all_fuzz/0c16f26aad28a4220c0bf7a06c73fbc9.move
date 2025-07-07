
//# publish
module 0xCAFE::MathOps {
    public fun add_then_return_sum(a: u8, b: u8): u8 {
        let sum = a + b;
        sum
    }

    public fun call_inline_lambda(x: u8, y: u8): u8 {
        let lambda: |u8, u8| u8 has copy+drop = |a: u8, b: u8| {
            a + b
        };
        lambda(x, y)
    }
}


//# publish
module 0xCAFE::CallerModule {
    use 0xCAFE::MathOps;

    public inline fun inline_increment(a: u8): u8 {
        a + 1
    }

    public fun nested_inline_call(value: u8): u8 {
        let incremented = inline_increment(value);
        let sum = MathOps::add_then_return_sum(incremented, 5u8);
        sum
    }
}


//# run 0xCAFE::MathOps::add_then_return_sum --args 10u8 15u8


//# run 0xCAFE::MathOps::call_inline_lambda --args 7u8 8u8


//# run 0xCAFE::CallerModule::nested_inline_call --args 9u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
