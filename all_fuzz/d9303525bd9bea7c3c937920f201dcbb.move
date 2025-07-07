
//# publish
module 0xCAFE::Adder {
    public fun add_and_return_sum(a: u8, b: u8): u8 {
        let sum = a + b;
        sum
    }

    public fun with_lambda_example(a: u8, b: u8): u8 {
        let add_lambda: |u8, u8|u8 has copy+drop = |x: u8, y: u8| {
            x + y
        };
        add_lambda(a, b)
    }

    public inline fun inline_add(a: u8, b: u8): u8 {
        a + b
    }
}


//# publish
module 0xCAFE::NestedCall {
    use 0xCAFE::Adder;

    public fun call_inline_add(a: u8, b: u8): u8 {
        Adder::inline_add(a, b)
    }

    public fun call_add_and_return_sum(a: u8, b: u8): u8 {
        let sum = Adder::add_and_return_sum(a, b);
        sum
    }

    public fun call_with_lambda_example(a: u8, b: u8): u8 {
        Adder::with_lambda_example(a, b)
    }

    public fun runner() {
        let _ = call_inline_add(10u8, 15u8);
        let _ = call_add_and_return_sum(20u8, 25u8);
        let _ = call_with_lambda_example(30u8, 35u8);
    }
}


//# run 0xCAFE::Adder::add_and_return_sum --args 10u8 20u8


//# run 0xCAFE::Adder::with_lambda_example --args 5u8 7u8


//# run 0xCAFE::NestedCall::call_inline_add --args 1u8 2u8


//# run 0xCAFE::NestedCall::call_add_and_return_sum --args 3u8 4u8


//# run 0xCAFE::NestedCall::call_with_lambda_example --args 11u8 12u8


//# run 0xCAFE::NestedCall::runner


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
