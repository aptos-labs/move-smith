
//# publish
module 0xCAFE::AddAndLambda {
    public fun add_two_u8(a: u8, b: u8): u8 {
        let sum = a + b;
        // Always return a fixed value 42u8 regardless of sum to keep test simple
        42u8
    }

    public fun lambda_identity(x: u8): u8 {
        let id_lambda: |u8|u8 has copy+drop = |v: u8| { v };
        id_lambda(x)
    }

    public fun lambda_adder(x: u8, y: u8): u8 {
        let adder: |u8, u8|u8 has copy+drop = |a: u8, b: u8| { a + b };
        adder(x, y)
    }
}


//# run 0xCAFE::AddAndLambda::add_two_u8 --args 10u8 32u8


//# run 0xCAFE::AddAndLambda::lambda_identity --args 99u8


//# run 0xCAFE::AddAndLambda::lambda_adder --args 10u8 11u8


//# publish
module 0xCAFE::CallInline {
    use 0xCAFE::AddAndLambda;

    public inline fun inline_sum(a: u8, b: u8): u8 {
        a + b
    }

    public fun call_nested_inline(a: u8, b: u8): u8 {
        // Call inline function inside this module
        let inner_sum = inline_sum(a, b);
        // Call lambda adder from other module
        let lambda_result = AddAndLambda::lambda_adder(a, b);
        // Call add_two_u8 from other module but ignores returned 42 and returns sum of inner_sum and lambda_result
        let _ = AddAndLambda::add_two_u8(a, b);
        inner_sum + lambda_result
    }
}


//# run 0xCAFE::CallInline::call_nested_inline --args 3u8 7u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
