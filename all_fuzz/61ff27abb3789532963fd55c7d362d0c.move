
//# publish
module 0xCAFE::Calculator {
    public fun add_and_return_sum(a: u8, b: u8): u8 {
        let sum = a + b;
        // Return sum + 1 to check correct addition + some logic
        sum + 1
    }

    public fun lambda_test(x: u8): u8 {
        let add_two: |u8| u8 has copy+drop = |a: u8| {
            a + 2
        };
        add_two(x)
    }

    public inline fun inline_increment(x: u8): u8 {
        x + 1
    }
}


//# run 0xCAFE::Calculator::add_and_return_sum --args 10u8 20u8


//# run 0xCAFE::Calculator::lambda_test --args 5u8


//# publish
module 0xCAFE::NestedCall {
    use 0xCAFE::Calculator;

    public fun call_inline_increment_twice(x: u8): u8 {
        let first = Calculator::inline_increment(x);
        let second = Calculator::inline_increment(first);
        second
    }

    public fun runner() {
        let _ = call_inline_increment_twice(5u8);
    }
}


//# run 0xCAFE::NestedCall::runner


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
