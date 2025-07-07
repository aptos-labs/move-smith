
//# publish
module 0xCAFE::AddAndLambda {
    /// Adds two u8 values and returns the sum plus one
    public fun add_plus_one(a: u8, b: u8): u8 {
        let sum = a + b;
        sum + 1
    }

    /// Returns a lambda that adds two u8 values
    public fun get_adder_lambda(): |u8, u8| u8 has copy+drop {
        |x: u8, y: u8| { x + y }
    }

    /// Uses a lambda to compute sum of two u8 and then adds one
    public fun add_with_lambda_and_increment(a: u8, b: u8): u8 {
        let add_lambda = get_adder_lambda();
        let sum = add_lambda(a, b);
        sum + 1
    }
}


//# run 0xCAFE::AddAndLambda::add_plus_one --args 5u8 10u8


//# run 0xCAFE::AddAndLambda::get_adder_lambda


//# run 0xCAFE::AddAndLambda::add_with_lambda_and_increment --args 7u8 8u8



//# publish
module 0xCAFE::NestedCalls {
    use 0xCAFE::AddAndLambda;

    /// Calls AddAndLambda::add_plus_one directly
    public fun direct_call(a: u8, b: u8): u8 {
        AddAndLambda::add_plus_one(a, b)
    }

    /// Calls AddAndLambda::get_adder_lambda and uses returned lambda
    public fun call_lambda(a: u8, b: u8): u8 {
        let f = AddAndLambda::get_adder_lambda();
        f(a, b)
    }

    /// Calls AddAndLambda::add_with_lambda_and_increment which itself uses a lambda
    public fun nested_lambda_increment(a: u8, b: u8): u8 {
        AddAndLambda::add_with_lambda_and_increment(a, b)
    }
}


//# run 0xCAFE::NestedCalls::direct_call --args 10u8 20u8


//# run 0xCAFE::NestedCalls::call_lambda --args 15u8 5u8


//# run 0xCAFE::NestedCalls::nested_lambda_increment --args 25u8 10u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
