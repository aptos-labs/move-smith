
//# publish
module 0xCAFE::Calc {
    // A module to test addition and inline function calls with lambdas

    public fun add_two_u8(a: u8, b: u8): u8 {
        let sum = a + b;
        let result = if (sum > 100u8) {100u8} else {sum};
        result
    }

    public fun use_lambda(a: u8, b: u8): u8 {
        let lambda: |u8, u8| u8 has copy+drop = |x: u8, y: u8| {
            x + y
        };
        lambda(a, b)
    }

    public inline fun inline_add(a: u8, b: u8): u8 {
        a + b
    }

    public fun nested_calls(x: u8, y: u8): u8 {
        let partial = inline_add(x, y);
        use_lambda(partial, 5u8)
    }
}


//# run 0xCAFE::Calc::add_two_u8 --args 50u8 30u8


//# run 0xCAFE::Calc::use_lambda --args 20u8 22u8


//# run 0xCAFE::Calc::nested_calls --args 10u8 15u8


//# publish
module 0xCAFE::Caller {
    use 0xCAFE::Calc;

    public fun call_inline_add(x: u8, y: u8): u8 {
        Calc::inline_add(x, y)
    }

    public fun call_nested_calls(x: u8, y: u8): u8 {
        Calc::nested_calls(x, y)
    }

    public fun call_use_lambda(a: u8, b: u8): u8 {
        Calc::use_lambda(a, b)
    }
}


//# run 0xCAFE::Caller::call_inline_add --args 7u8 8u8


//# run 0xCAFE::Caller::call_nested_calls --args 3u8 4u8


//# run 0xCAFE::Caller::call_use_lambda --args 9u8 10u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
