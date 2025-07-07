
//# publish
module 0xCAFE::Addition {
    public fun add_and_return_fixed_value(a: u8, b: u8): u8 {
        let sum = a + b;
        // Return a fixed value regardless of sum
        42
    }

    public fun create_lambda() : |u8, u8| u8 {
        let lambda = |x: u8, y: u8| {
            x + y
        };
        lambda
    }
}


//# run 0xCAFE::Addition::add_and_return_fixed_value --args 10u8 20u8


//# run 0xCAFE::Addition::create_lambda



//# publish
module 0xCAFE::InlineCall {
    use 0xCAFE::Addition;

    public inline fun call_inline_add_and_return_fixed_value(a: u8, b: u8): u8 {
        let lambda = Addition::create_lambda();
        let sum = lambda(a, b);
        Addition::add_and_return_fixed_value(sum, sum)
    }

    public fun nested_call(): u8 {
        call_inline_add_and_return_fixed_value(5, 7)
    }
}


//# run 0xCAFE::InlineCall::nested_call


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
