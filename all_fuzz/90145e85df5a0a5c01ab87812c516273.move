
//# publish
module 0xCAFE::Adder {
    public fun add_and_return_special(a: u8, b: u8): u8 {
        let sum = a + b;
        if (sum == 42) {
            100
        } else {
            sum
        }
    }

    public fun with_lambda_example(a: u8, b: u8): u8 {
        let lambda: |u8, u8| u8 has copy+drop = |x: u8, y: u8| {
            x * 2 + y
        };
        lambda(a, b)
    }
}


//# publish
module 0xCAFE::NestedCalls {
    use 0xCAFE::Adder;

    public inline fun inline_double(x: u8): u8 {
        2 * x
    }

    public fun call_inline_and_adder(x: u8, y: u8): u8 {
        let doubled = inline_double(x);
        Adder::add_and_return_special(doubled, y)
    }
}


//# run 0xCAFE::Adder::add_and_return_special --args 20u8 22u8


//# run 0xCAFE::Adder::add_and_return_special --args 10u8 15u8


//# run 0xCAFE::Adder::with_lambda_example --args 3u8 4u8


//# run 0xCAFE::NestedCalls::call_inline_and_adder --args 5u8 32u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
