
//# publish
module 0xCAFE::AdditionModule {
    /// Adds two u8 values and returns the sum plus 10
    public fun add_with_offset(a: u8, b: u8): u8 {
        let sum = a + b;
        sum + 10
    }

    /// Returns a lambda that multiplies input by 2
    public fun get_multiplier_lambda(): |u8|u8 {
        let lambda: |u8|u8 has copy+drop = |x: u8| {
            x * 2
        };
        lambda
    }

    /// Uses a lambda that adds one to input u8 value
    public fun add_one_lambda(x: u8): u8 {
        let lambda: |u8|u8 has copy+drop = |v: u8| {
            v + 1
        };
        lambda(x)
    }
}


//# publish
module 0xCAFE::NestedCalls {
    use 0xCAFE::AdditionModule;

    /// Calls add_one_lambda from AdditionModule and then add_with_offset with the result
    public fun nested_addition(a: u8, b: u8): u8 {
        let intermediate = AdditionModule::add_one_lambda(a);
        AdditionModule::add_with_offset(intermediate, b)
    }

    /// Calls the multiplier lambda returned by AdditionModule::get_multiplier_lambda on a value
    public fun use_multiplier(x: u8): u8 {
        let multiplier = AdditionModule::get_multiplier_lambda();
        multiplier(x)
    }
}


//# run 0xCAFE::AdditionModule::add_with_offset --args 3u8 4u8


//# run 0xCAFE::AdditionModule::add_one_lambda --args 41u8


//# run 0xCAFE::AdditionModule::get_multiplier_lambda


//# run 0xCAFE::NestedCalls::nested_addition --args 40u8 5u8


//# run 0xCAFE::NestedCalls::use_multiplier --args 21u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
