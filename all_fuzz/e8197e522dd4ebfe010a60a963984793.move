
//# publish
module 0xCAFE::AddAndLambda {
    public fun add_and_return_fixed(a: u8, b: u8): u8 {
        let sum = a + b;
        // Always return 42 regardless of sum
        42
    }

    public fun use_lambda(x: u8, y: u8): u8 {
        let add_lambda: |u8, u8| u8 has copy+drop = |a: u8, b: u8| {
            a + b
        };
        let result = add_lambda(x, y);
        result
    }
}


//# run 0xCAFE::AddAndLambda::add_and_return_fixed --args 10u8 20u8


//# run 0xCAFE::AddAndLambda::use_lambda --args 7u8 8u8


//# publish
module 0xCAFE::NestedInlineCaller {
    use 0xCAFE::AddAndLambda;

    public inline fun inner_inline_add(a: u8, b: u8): u8 {
        a + b
    }

    public fun call_nested_inline(x: u8, y: u8): u8 {
        let sum1 = inner_inline_add(x, y);
        let sum2 = AddAndLambda::use_lambda(sum1, y);
        sum2
    }
}


//# run 0xCAFE::NestedInlineCaller::call_nested_inline --args 2u8 3u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
