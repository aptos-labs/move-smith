
//# publish
module 0xCAFE::AddLambda {
    // This module will test addition, lambdas, and inline function calls.

    public inline fun add_inline(a: u8, b: u8): u8 {
        a + b
    }

    public fun add_lambda(a: u8, b: u8): u8 {
        let sum_func: |u8, u8|u8 has copy+drop = |x: u8, y: u8| {
            x + y
        };
        sum_func(a, b)
    }

    public fun compute_and_return_fixed(a: u8, b: u8): u8 {
        let sum = add_lambda(a, b);
        if (sum > 10) {
            100u8
        } else {
            50u8
        }
    }
}


//# run 0xCAFE::AddLambda::compute_and_return_fixed --args 3u8 4u8


//# run 0xCAFE::AddLambda::compute_and_return_fixed --args 7u8 5u8


//# publish
module 0xCAFE::NestedCall {
    use 0xCAFE::AddLambda;

    public fun call_add_inline_nested(a: u8, b: u8): u8 {
        let intermediate = AddLambda::add_inline(a, b);
        // Compose nested call using inline function again
        AddLambda::add_inline(intermediate, 1u8)
    }

    public fun use_lambda_from_addlambda(a: u8, b: u8): u8 {
        // Call add_lambda from AddLambda module, which uses a lambda
        AddLambda::add_lambda(a, b)
    }

    public fun call_compute_and_return(a: u8, b: u8): u8 {
        // Call compute_and_return_fixed from AddLambda
        AddLambda::compute_and_return_fixed(a, b)
    }
}


//# run 0xCAFE::NestedCall::call_add_inline_nested --args 2u8 3u8


//# run 0xCAFE::NestedCall::use_lambda_from_addlambda --args 4u8 6u8


//# run 0xCAFE::NestedCall::call_compute_and_return --args 5u8 6u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
