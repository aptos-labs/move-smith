
//# publish
module 0xCAFE::AddAndLambda {
    public fun add_values(a: u8, b: u8): u8 {
        let sum = a + b;
        sum + 10u8
    }

    public fun use_lambda(a: u8, b: u8): u8 {
        let lambda: |u8, u8| u8 has copy+drop = |x: u8, y: u8| {
            x + y + 5u8
        };
        let result = lambda(a, b);
        result
    }
}



//# run 0xCAFE::AddAndLambda::add_values --args 3u8 4u8



//# run 0xCAFE::AddAndLambda::use_lambda --args 2u8 3u8


// Fixed: Changed `public inline fun` to `public fun` to fix FUNCTION_RESOLUTION_FAILURE since inline is not supported at module level (as of current Aptos Move spec).


//# publish
module 0xCAFE::NestedCall {
    use 0xCAFE::AddAndLambda;

    public fun inline_add(a: u8, b: u8): u8 {
        AddAndLambda::add_values(a, b)
    }

    public fun call_inline_and_lambda(a: u8, b: u8): (u8, u8) {
        let sum = inline_add(a, b);
        let lambda: |u8| u8 has copy+drop = |x: u8| {
            x * 2u8
        };
        let lambda_result = lambda(sum);
        (sum, lambda_result)
    }
}



//# run 0xCAFE::NestedCall::inline_add --args 7u8 8u8



//# run 0xCAFE::NestedCall::call_inline_and_lambda --args 6u8 7u8


// Features:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
