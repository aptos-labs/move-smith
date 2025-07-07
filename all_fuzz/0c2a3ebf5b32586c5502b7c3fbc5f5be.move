
//# publish
module 0xCAFE::Adder {
    public fun add_then_return_five(a: u8, b: u8): u8 {
        let sum = a + b;
        5u8
    }

    public fun use_lambda_and_return_sum(a: u8, b: u8): u8 {
        let lambda: |u8, u8|u8 has copy+drop = |x: u8, y: u8| {
            x + y
        };
        lambda(a, b)
    }

    public inline fun inline_add(a: u8, b: u8): u8 {
        a + b
    }
}


//# run 0xCAFE::Adder::add_then_return_five --args 10u8 20u8


//# run 0xCAFE::Adder::use_lambda_and_return_sum --args 7u8 8u8


//# publish
module 0xCAFE::NestedCaller {
    use 0xCAFE::Adder;

    public fun call_inline_add_then_add_one(x: u8, y: u8): u8 {
        let sum = Adder::inline_add(x, y);
        sum + 1u8
    }
}


//# run 0xCAFE::NestedCaller::call_inline_add_then_add_one --args 3u8 4u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
