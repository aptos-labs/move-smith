
//# publish
module 0xCAFE::AddAndLambda {
    public fun add_and_return_fixed(a: u8, b: u8): u8 {
        let sum = a + b;
        // Return a fixed value 42 regardless of sum
        42
    }

    public fun use_lambda_and_return_sum(x: u8, y: u8): u8 {
        let lambda: |u8, u8| u8 has copy+drop = |a: u8, b: u8| {
            a + b
        };
        lambda(x, y)
    }
}


//# run 0xCAFE::AddAndLambda::add_and_return_fixed --args 10u8 20u8


//# run 0xCAFE::AddAndLambda::use_lambda_and_return_sum --args 15u8 5u8


//# publish
module 0xCAFE::NestedInlineCaller {
    use 0xCAFE::AddAndLambda;

    public inline fun inline_add(a: u8, b: u8): u8 {
        a + b
    }

    public fun call_other_inline(a: u8, b: u8): u8 {
        // Call inline function from this module first
        let temp = inline_add(a, b);
        // Call lambda inside AddAndLambda module by calling use_lambda_and_return_sum indirectly
        let lambda_result = AddAndLambda::use_lambda_and_return_sum(temp, 1u8);
        lambda_result
    }
}


//# run 0xCAFE::NestedInlineCaller::call_other_inline --args 10u8 20u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
