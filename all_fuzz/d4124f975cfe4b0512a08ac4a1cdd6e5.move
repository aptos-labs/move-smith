
//# publish
module 0xCAFE::Calculator {
    public fun add_and_return_sum(a: u8, b: u8): u8 {
        let sum = a + b;
        sum
    }

    public fun with_lambda(a: u8, b: u8): u8 {
        let sum_lambda: |u8, u8| u8 has copy+drop = |x: u8, y: u8| {
            x + y
        };
        sum_lambda(a, b)
    }
}


//# run 0xCAFE::Calculator::add_and_return_sum --args 10u8 20u8


//# run 0xCAFE::Calculator::with_lambda --args 7u8 8u8


//# publish
module 0xCAFE::NestedCaller {
    use 0xCAFE::Calculator;

    public inline fun call_inline_add(a: u8, b: u8): u8 {
        Calculator::add_and_return_sum(a, b)
    }

    public fun run_test(): u8 {
        let res = call_inline_add(5u8, 15u8);
        res
    }
}


//# run 0xCAFE::NestedCaller::run_test


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
