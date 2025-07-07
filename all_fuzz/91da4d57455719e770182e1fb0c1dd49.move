
//# publish
module 0xCAFE::AddAndLambda {
    public fun add_and_return_constant(x: u8, y: u8): u8 {
        let sum = x + y;
        if (sum > 10) {
            42u8
        } else {
            24u8
        }
    }

    public fun use_lambda(x: u8, y: u8): u8 {
        let lambda: |u8, u8| u8 has copy+drop = |a: u8, b: u8| {
            a + b
        };
        lambda(x, y)
    }
}


//# run 0xCAFE::AddAndLambda::add_and_return_constant --args 3u8 12u8


//# run 0xCAFE::AddAndLambda::use_lambda --args 7u8 8u8


//# publish
module 0xCAFE::NestedInlineCall {
    use 0xCAFE::AddAndLambda;

    public inline fun inline_add(a: u8, b: u8): u8 {
        AddAndLambda::use_lambda(a, b)
    }

    public fun call_inline_twice(x: u8, y: u8): u8 {
        let first = inline_add(x, y);
        let second = inline_add(first, y);
        second
    }
}


//# run 0xCAFE::NestedInlineCall::call_inline_twice --args 3u8 5u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
