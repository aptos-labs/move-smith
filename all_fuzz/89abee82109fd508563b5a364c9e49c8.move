
//# publish
module 0xCAFE::LambdaAddition {
    /// A simple function that adds two u8 values and returns the sum.
    public fun add_two_u8(a: u8, b: u8): u8 {
        a + b
    }

    /// A function that defines a lambda (anonymous function) which adds two u8 values and returns the result.
    public fun lambda_add(a: u8, b: u8): u8 {
        let add_lambda: |u8, u8|u8 has copy+drop = |x: u8, y: u8| {
            x + y
        };
        add_lambda(a, b)
    }
}


//# run 0xCAFE::LambdaAddition::add_two_u8 --args 10u8 32u8


//# run 0xCAFE::LambdaAddition::lambda_add --args 15u8 17u8


//# publish
module 0xCAFE::CrossModuleCall {
    use 0xCAFE::LambdaAddition;

    /// Calls the inline function defined in LambdaAddition indirectly by
    /// calling add_two_u8 within another function.
    public fun call_addition(a: u8, b: u8): u8 {
        LambdaAddition::add_two_u8(a, b)
    }

    /// Calls the lambda_add function from LambdaAddition.
    public fun call_lambda_add(a: u8, b: u8): u8 {
        LambdaAddition::lambda_add(a, b)
    }
}


//# run 0xCAFE::CrossModuleCall::call_addition --args 50u8 25u8


//# run 0xCAFE::CrossModuleCall::call_lambda_add --args 60u8 1u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
