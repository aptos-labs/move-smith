
//# publish
module 0xCAFE::LambdaAdd {
    public fun add_two_u8(a: u8, b: u8): u8 {
        a + b
    }

    public fun call_lambda_add(a: u8, b: u8): u8 {
        let add_lambda: |u8, u8|u8 has copy+drop = |x: u8, y: u8| {
            x + y
        };
        add_lambda(a, b)
    }

    public fun nested_lambda_operation(a: u8, b: u8): u8 {
        let add_lambda: |u8, u8| u8 has copy+drop = |x: u8, y: u8| {
            x + y
        };
        let inner_lambda: |u8|u8 has copy+drop = |z: u8| {
            add_lambda(z, a)
        };
        inner_lambda(b)
    }
}


//# publish
module 0xCAFE::InlineCaller {
    use 0xCAFE::LambdaAdd;

    public inline fun inline_add(a: u8, b: u8): u8 {
        LambdaAdd::add_two_u8(a, b)
    }

    public fun call_inline_add(a: u8, b: u8): u8 {
        inline_add(a, b)
    }

    public fun call_nested_add(a: u8, b: u8, c: u8): u8 {
        let first = inline_add(a, b);
        LambdaAdd::nested_lambda_operation(first, c)
    }
}


//# run 0xCAFE::LambdaAdd::add_two_u8 --args 10u8 15u8


//# run 0xCAFE::LambdaAdd::call_lambda_add --args 20u8 22u8


//# run 0xCAFE::LambdaAdd::nested_lambda_operation --args 3u8 4u8


//# run 0xCAFE::InlineCaller::call_inline_add --args 5u8 7u8


//# run 0xCAFE::InlineCaller::call_nested_add --args 2u8 3u8 4u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
