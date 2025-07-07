
//# publish
module 0xCAFE::Adder {
    public fun add_and_compare(a: u8, b: u8): u8 {
        let sum = a + b;
        if (sum > 10) {
            42u8
        } else {
            sum
        }
    }

    public fun with_lambda_example(a: u8, b: u8): u8 {
        let lambda: |u8, u8|u8 has copy+drop = |x: u8, y: u8| {
            x + y
        };
        lambda(a, b)
    }

    public inline fun inline_add(a: u8, b: u8): u8 {
        a + b
    }
}


//# run 0xCAFE::Adder::add_and_compare --args 5u8 7u8


//# run 0xCAFE::Adder::add_and_compare --args 3u8 4u8


//# run 0xCAFE::Adder::with_lambda_example --args 8u8 2u8


//# publish
module 0xCAFE::NestedCalls {
    use 0xCAFE::Adder;

    public fun call_inline_add_and_compare(a: u8, b: u8): u8 {
        let intermediate_sum = Adder::inline_add(a, b);
        Adder::add_and_compare(intermediate_sum, 1u8)
    }
}


//# run 0xCAFE::NestedCalls::call_inline_add_and_compare --args 4u8 5u8


//# run 0xCAFE::NestedCalls::call_inline_add_and_compare --args 1u8 2u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
