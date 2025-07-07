
//# publish
module 0xCAFE::Adder {
    public fun add_and_return_sum(a: u8, b: u8): u8 {
        let sum = a + b;
        sum
    }

    public fun lambda_addition(a: u8, b: u8): u8 {
        let add_lambda: |u8, u8| u8 = |x: u8, y: u8| { x + y };
        add_lambda(a, b)
    }

    public inline fun inline_increment(x: u8): u8 {
        x + 1
    }
}


//# publish
module 0xCAFE::Caller {
    use 0xCAFE::Adder;

    public fun call_inline_and_add(x: u8, y: u8): u8 {
        let incremented = Adder::inline_increment(x);
        Adder::add_and_return_sum(incremented, y)
    }

    public fun call_lambda_addition(x: u8, y: u8): u8 {
        Adder::lambda_addition(x, y)
    }
}


//# run 0xCAFE::Adder::add_and_return_sum --args 10u8 20u8


//# run 0xCAFE::Adder::lambda_addition --args 5u8 7u8


//# run 0xCAFE::Caller::call_inline_and_add --args 4u8 3u8


//# run 0xCAFE::Caller::call_lambda_addition --args 8u8 9u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
