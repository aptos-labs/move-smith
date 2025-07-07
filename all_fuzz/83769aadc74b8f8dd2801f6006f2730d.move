
//# publish
module 0xCAFE::MathOps {
    public fun add_then_return_sum(a: u8, b: u8): u8 {
        let sum = a + b;
        let result = sum + 10u8;
        result
    }

    public fun test_lambda_expression(x: u8, y: u8): u8 {
        let lambda: |u8, u8| u8 has copy+drop = |a: u8, b: u8| {
            a + b
        };
        let sum = lambda(x, y);
        sum
    }

    public inline fun inline_add(a: u8, b: u8): u8 {
        a + b
    }
}


//# publish
module 0xCAFE::CallerModule {
    use 0xCAFE::MathOps;

    public fun call_inline_and_lambda(x: u8, y: u8): (u8, u8) {
        let inline_sum = MathOps::inline_add(x, y);
        let lambda_sum = MathOps::test_lambda_expression(x, y);
        (inline_sum, lambda_sum)
    }

    public fun call_add_then_return_sum(x: u8, y: u8): u8 {
        MathOps::add_then_return_sum(x, y)
    }
}


//# run 0xCAFE::MathOps::add_then_return_sum --args 7u8 8u8


//# run 0xCAFE::MathOps::test_lambda_expression --args 5u8 9u8


//# run 0xCAFE::CallerModule::call_inline_and_lambda --args 3u8 4u8


//# run 0xCAFE::CallerModule::call_add_then_return_sum --args 2u8 3u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
