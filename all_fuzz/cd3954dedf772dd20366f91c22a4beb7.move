
//# publish
module 0xCAFE::AddAndLambda {
    // Module to test addition and lambda functions
    
    /// Adds two u8 values and returns u8 result + 1
    public fun add_and_increment(a: u8, b: u8): u8 {
        let sum = a + b;
        sum + 1
    }

    /// Returns a lambda that multiplies its input by 2
    public fun get_multiplier_lambda(): |u8|u8 {
        |x: u8| x * 2u8
    }

    /// Applies a lambda to a given u8 value
    public fun apply_lambda(lambda: |u8|u8, val: u8): u8 {
        lambda(val)
    }
}



//# publish
module 0xCAFE::CallerModule {
    use 0xCAFE::AddAndLambda;

    /// Calls AddAndLambda's add_and_increment function with given args
    public fun call_add_and_increment(a: u8, b: u8): u8 {
        AddAndLambda::add_and_increment(a, b)
    }

    /// Calls get_multiplier_lambda and applies it to val
    public fun lambda_call(val: u8): u8 {
        let lambda = AddAndLambda::get_multiplier_lambda();
        AddAndLambda::apply_lambda(lambda, val)
    }

    /// Calls add_and_increment internally by nesting the call
    public fun nested_add_calls(a: u8, b: u8, c: u8): u8 {
        let first_sum = AddAndLambda::add_and_increment(a, b); // (a + b) + 1
        let final_sum = AddAndLambda::add_and_increment(first_sum, c); // previous + c + 1
        final_sum
    }
}



//# run 0xCAFE::AddAndLambda::add_and_increment --args 3u8 5u8


//# run 0xCAFE::AddAndLambda::get_multiplier_lambda


//# run 0xCAFE::CallerModule::lambda_call --args 4u8


//# run 0xCAFE::CallerModule::call_add_and_increment --args 2u8 7u8


//# run 0xCAFE::CallerModule::lambda_call --args 8u8


//# run 0xCAFE::CallerModule::nested_add_calls --args 1u8 2u8 3u8
