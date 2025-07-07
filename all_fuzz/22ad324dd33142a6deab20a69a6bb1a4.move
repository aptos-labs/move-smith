
//# publish
module 0xCAFE::LambdaAdder {
    public fun add_and_return_special(x: u8, y: u8): u8 {
        let sum = x + y;
        // return a special value, e.g., sum + 10
        sum + 10
    }

    public fun call_lambda(x: u8, y: u8): u8 {
        let lambda: |u8, u8| (u8) has copy+drop = |a: u8, b: u8| a + b;
        lambda(x, y)
    }

    public fun call_lambda_with_capture(x: u8): u8 {
        let captured = 5u8;
        let lambda: |u8| u8 has copy+drop = |a: u8| a + captured;
        lambda(x)
    }
}


//# run 0xCAFE::LambdaAdder::add_and_return_special --args 10u8 20u8


//# run 0xCAFE::LambdaAdder::call_lambda --args 7u8 8u8


//# run 0xCAFE::LambdaAdder::call_lambda_with_capture --args 10u8



//# publish
module 0xCAFE::InlineCall {
    use 0xCAFE::LambdaAdder;

    public inline fun inline_add_twice(a: u8, b: u8): u8 {
        let first = LambdaAdder::add_and_return_special(a, b);
        let second = LambdaAdder::call_lambda(a, b);
        first + second
    }

    public fun runner(): u8 {
        inline_add_twice(3u8, 4u8)
    }
}


//# run 0xCAFE::InlineCall::runner


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
