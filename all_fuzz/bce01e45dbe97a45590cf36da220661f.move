
//# publish
module 0xCAFE::LambdaAdd {
    public fun add_two_u8(a: u8, b: u8): u8 {
        let sum = a + b;
        sum + 10u8
    }

    public fun with_lambda(x: u8, y: u8): u8 {
        let lambda: |u8, u8| u8 has copy+drop = |a: u8, b: u8| {
            a + b
        };
        lambda(x, y)
    }
}


//# run 0xCAFE::LambdaAdd::add_two_u8 --args 7u8 4u8


//# run 0xCAFE::LambdaAdd::with_lambda --args 8u8 5u8


//# publish
module 0xCAFE::NestedInlineCall {
    use 0xCAFE::LambdaAdd;

    public inline fun inline_add(a: u8, b: u8): u8 {
        let c = a + b;
        c
    }

    public fun call_nested_add(a: u8, b: u8): u8 {
        let x = inline_add(a, b);
        let y = LambdaAdd::add_two_u8(x, 1u8);
        y
    }
}


//# run 0xCAFE::NestedInlineCall::call_nested_add --args 10u8 20u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
