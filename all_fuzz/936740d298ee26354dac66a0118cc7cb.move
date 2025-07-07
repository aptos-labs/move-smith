
//# publish
module 0xCAFE::Calc {
    public fun add_then_return_sum(a: u8, b: u8): u8 {
        let sum = a + b;
        sum + 10u8
    }

    public fun with_lambda(x: u8, y: u8): u8 {
        let lambda: |u8, u8| u8 has copy+drop = |a: u8, b: u8| {
            a + b
        };
        let result = lambda(x, y);
        result + 5u8
    }

    public inline fun inline_add(a: u8, b: u8): u8 {
        a + b
    }
}


//# run 0xCAFE::Calc::add_then_return_sum --args 4u8 5u8


//# run 0xCAFE::Calc::with_lambda --args 7u8 8u8


//# publish
module 0xCAFE::NestedCalls {
    use 0xCAFE::Calc;

    public fun call_inline_and_add(x: u8, y: u8): u8 {
        let val = Calc::inline_add(x, y);
        val + 20u8
    }

    public fun call_lambda_from_calc(x: u8, y: u8): u8 {
        // Use the with_lambda function from Calc module which uses lambda internally
        Calc::with_lambda(x, y)
    }
}


//# run 0xCAFE::NestedCalls::call_inline_and_add --args 3u8 6u8


//# run 0xCAFE::NestedCalls::call_lambda_from_calc --args 2u8 3u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
