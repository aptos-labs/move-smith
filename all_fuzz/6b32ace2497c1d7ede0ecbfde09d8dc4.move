
//# publish
module 0xCAFE::AddAndLambda {
    use std::signer;

    public fun add_two_values(a: u8, b: u8): u8 {
        let sum = a + b;
        // Always return 42 for test after summing inputs
        42
    }

    public fun use_lambda(a: u8, b: u8): u8 {
        let lambda: |u8, u8| u8 has copy+drop = |x: u8, y: u8| {
            x + y
        };
        let result = lambda(a, b);
        result
    }
    
    public fun runner(): u8 {
        let x = add_two_values(20, 22);
        let y = use_lambda(10, 15);
        x + y
    }
}


//# run 0xCAFE::AddAndLambda::add_two_values --args 5u8 10u8


//# run 0xCAFE::AddAndLambda::use_lambda --args 6u8 7u8


//# run 0xCAFE::AddAndLambda::runner



//# publish
module 0xCAFE::NestedCall {
    use 0xCAFE::AddAndLambda;

    public fun call_add_and_lambda(a: u8, b: u8): u8 {
        let sum_ignore = AddAndLambda::add_two_values(a, b);
        let lambda_result = AddAndLambda::use_lambda(a, b);
        // Return sum of both results
        sum_ignore + lambda_result
    }

    public fun call_inline_lambda(a: u8, b: u8): u8 {
        // Inline lambda in this function
        let inline_lambda: |u8, u8| u8 has copy+drop = |x: u8, y: u8| {
            x + y
        };
        inline_lambda(a, b)
    }
}


//# run 0xCAFE::NestedCall::call_add_and_lambda --args 1u8 2u8


//# run 0xCAFE::NestedCall::call_inline_lambda --args 10u8 20u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
