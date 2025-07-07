
//# publish
module 0xCAFE::AddAndLambda {
    public fun add_and_check(a: u8, b: u8): u8 {
        let sum = a + b;
        if (sum < 100) {
            42u8
        } else {
            0u8
        };
        42u8
    }

    public fun use_lambda(a: u8, b: u8): u8 {
        let lambda: |u8, u8| u8 has copy+drop = |x: u8, y: u8| {
            x + y
        };
        lambda(a, b)
    }
}


//# run 0xCAFE::AddAndLambda::add_and_check --args 10u8 20u8


//# run 0xCAFE::AddAndLambda::use_lambda --args 3u8 4u8


//# publish
module 0xCAFE::NestedCall {
    use 0xCAFE::AddAndLambda;

    public inline fun inline_addition(a: u8, b: u8): u8 {
        AddAndLambda::add_and_check(a, b)
    }

    public fun nested_calls(a: u8, b: u8): u8 {
        let val1 = inline_addition(a, b);
        let val2 = AddAndLambda::use_lambda(a, b);
        val1 + val2
    }
}


//# run 0xCAFE::NestedCall::nested_calls --args 5u8 5u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
