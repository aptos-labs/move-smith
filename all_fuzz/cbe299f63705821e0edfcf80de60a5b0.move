
//# publish
module 0xCAFE::AddModule {
    /// Computes the sum of two u8 values and returns sum + 10.
    public fun add_and_offset(a: u8, b: u8): u8 {
        let sum = a + b;
        sum + 10u8
    }

    /// Returns a lambda that multiplies its input by 2.
    public fun make_double_lambda(): |u8|u8 {
        |x: u8| {
            x * 2u8
        }
    }
}


//# publish
module 0xCAFE::CallerModule {
    use 0xCAFE::AddModule;

    /// Calls AddModule::add_and_offset and returns the result plus 5.
    public fun call_add_and_offset(a: u8, b: u8): u8 {
        let partial = AddModule::add_and_offset(a, b);
        partial + 5u8
    }

    /// Calls the lambda returned from AddModule::make_double_lambda with input 7u8.
    public fun call_lambda(): u8 {
        let lambda = AddModule::make_double_lambda();
        lambda(7u8)
    }
}


//# run 0xCAFE::AddModule::add_and_offset --args 12u8 8u8


//# run 0xCAFE::AddModule::make_double_lambda


//# run 0xCAFE::CallerModule::call_add_and_offset --args 3u8 4u8


//# run 0xCAFE::CallerModule::call_lambda


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
