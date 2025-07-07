
//# publish
module 0xCAFE::AddAndLambda {
    use std::signer;

    public fun add_two_values(a: u8, b: u8): u8 {
        let sum = a + b;
        // Return sum + 10 to test computation
        sum + 10
    }

    public fun apply_lambda(x: u8): u8 {
        let lambda: |u8|u8 has copy+drop = |v: u8| { v * v };
        lambda(x)
    }

    public fun nested_calls_then_lambda(a: u8, b: u8): u8 {
        let sum = add_two_values(a, b);
        let lambda: |u8|u8 has copy+drop = |v: u8| { v + 5 };
        lambda(sum)
    }
}


//# run 0xCAFE::AddAndLambda::add_two_values --args 3u8 7u8


//# run 0xCAFE::AddAndLambda::apply_lambda --args 5u8


//# run 0xCAFE::AddAndLambda::nested_calls_then_lambda --args 2u8 8u8


//# publish
module 0xCAFE::NestedCallModule {
    use 0xCAFE::AddAndLambda;

    public fun call_add_two_values(a: u8, b: u8): u8 {
        AddAndLambda::add_two_values(a, b)
    }

    public fun call_nested_calls_then_lambda_with_args(a: u8, b: u8): u8 {
        AddAndLambda::nested_calls_then_lambda(a, b)
    }
}


//# run 0xCAFE::NestedCallModule::call_add_two_values --args 4u8 6u8


//# run 0xCAFE::NestedCallModule::call_nested_calls_then_lambda_with_args --args 1u8 9u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
