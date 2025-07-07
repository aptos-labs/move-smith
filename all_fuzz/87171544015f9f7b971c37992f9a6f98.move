
//# publish
module 0xCAFE::Calculator {
    public fun add_and_return_sum(a: u8, b: u8): u8 {
        let sum = a + b;
        // Return sum plus fixed value 10 for testing
        sum + 10
    }

    public fun lambda_test(x: u8, y: u8): u8 {
        let add = |a: u8, b: u8| {
            a + b
        };
        add(x, y)
    }

    public inline fun inline_adder(a: u8, b: u8): u8 {
        a + b
    }
}


//# run 0xCAFE::Calculator::add_and_return_sum --args 5u8 10u8


//# run 0xCAFE::Calculator::lambda_test --args 7u8 8u8


//# publish
module 0xCAFE::Caller {
    use 0xCAFE::Calculator;

    public fun call_inline_adder(a: u8, b: u8): u8 {
        Calculator::inline_adder(a, b)
    }

    public fun combined_call(a: u8, b: u8): u8 {
        let res1 = Calculator::add_and_return_sum(a, b);
        let res2 = Calculator::inline_adder(a, b);
        res1 + res2
    }
}


//# run 0xCAFE::Caller::call_inline_adder --args 3u8 4u8


//# run 0xCAFE::Caller::combined_call --args 1u8 2u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
