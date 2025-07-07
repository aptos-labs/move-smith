
//# publish
module 0xCAFE::AddModule {
    /// Returns the sum of two u8 numbers plus a base value 10.
    public fun add_with_base(a: u8, b: u8): u8 {
        let sum = a + b;
        sum + 10
    }

    /// Returns a lambda that adds two u8 numbers and returns the result.
    public fun get_adder_lambda(): |u8, u8| u8 {
        let add_lambda: |u8, u8| u8 has copy + drop = |x: u8, y: u8| {
            x + y
        };
        add_lambda
    }

    /// Uses a lambda directly within the function to multiply two u8 numbers.
    public fun multiply_with_lambda(x: u8, y: u8): u8 {
        let multiply_lambda: |u8, u8| u8 has copy + drop = |a: u8, b: u8| {
            a * b
        };
        multiply_lambda(x, y)
    }
}


//# run 0xCAFE::AddModule::add_with_base --args 3u8 4u8


//# run 0xCAFE::AddModule::multiply_with_lambda --args 5u8 6u8


//# run 0xCAFE::AddModule::get_adder_lambda



//# publish
module 0xCAFE::CallerModule {
    use 0xCAFE::AddModule;

    /// Calls AddModule::add_with_base with given arguments and returns the result.
    public fun call_add_with_base(a: u8, b: u8): u8 {
        AddModule::add_with_base(a, b)
    }

    /// Calls the adder lambda from AddModule with given arguments.
    public fun call_adder_lambda(a: u8, b: u8): u8 {
        let adder = AddModule::get_adder_lambda();
        adder(a, b)
    }

    /// Calls AddModule::multiply_with_lambda passing given arguments and returns the result.
    public fun call_multiply_with_lambda(a: u8, b: u8): u8 {
        AddModule::multiply_with_lambda(a, b)
    }
}


//# run 0xCAFE::CallerModule::call_add_with_base --args 7u8 8u8


//# run 0xCAFE::CallerModule::call_adder_lambda --args 9u8 1u8


//# run 0xCAFE::CallerModule::call_multiply_with_lambda --args 4u8 3u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
