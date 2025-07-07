
//# publish
module 0xCAFE::AdditionModule {
    /// Adds two u8 values and returns the sum plus one.
    public fun add_and_increment(a: u8, b: u8): u8 {
        let sum = a + b;
        sum + 1
    }

    /// Returns a lambda function that multiplies a u8 value by two.
    public fun get_double_lambda(): |u8|u8 has copy+drop {
        |x: u8| { x * 2 }
    }

    /// Uses a lambda that adds three to the input value.
    public fun add_three_lambda(x: u8): u8 {
        let lambda: |u8|u8 has copy+drop = |n: u8| { n + 3 };
        lambda(x)
    }

    /// Runner function calling the above lambdas.
    public fun runner_lambda_functions() {
        let double = get_double_lambda();
        let _ = double(4u8);

        let _ = add_three_lambda(5u8);
    }
}


//# run 0xCAFE::AdditionModule::add_and_increment --args 10u8 20u8


//# run 0xCAFE::AdditionModule::runner_lambda_functions


//# publish
module 0xCAFE::NestedCallModule {
    use 0xCAFE::AdditionModule;

    /// Calls AdditionModule::add_and_increment and returns its result.
    public fun call_add_and_increment(a: u8, b: u8): u8 {
        AdditionModule::add_and_increment(a, b)
    }

    /// Nested call: Calls call_add_and_increment passing the sum returned from add_and_increment.
    public fun nested_calls(a: u8, b: u8): u8 {
        let first = AdditionModule::add_and_increment(a, b);
        call_add_and_increment(first, b)
    }
}


//# run 0xCAFE::NestedCallModule::call_add_and_increment --args 7u8 8u8


//# run 0xCAFE::NestedCallModule::nested_calls --args 2u8 3u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
