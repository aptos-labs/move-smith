
//# publish
module 0xCAFE::CalcModule {
    /// Adds two `u8` numbers and returns their sum plus a constant offset 42u8
    public fun add_and_offset(a: u8, b: u8): u8 {
        let sum = a + b;
        sum + 42u8
    }

    /// Accepts a lambda function that takes two `u8` and returns a `u8`, and two `u8` arguments.
    /// Calls the lambda with the arguments and returns the result.
    public fun use_lambda(f: |u8, u8|u8, x: u8, y: u8): u8 {
        f(x, y)
    }

    /// Returns a lambda that multiplies two u8 numbers
    public fun multiplier_lambda(): (|u8, u8|u8) {
        let lambda: |u8, u8|u8 has copy + drop = |x: u8, y: u8| x * y;
        lambda
    }
}



//# publish
module 0xCAFE::UserModule {
    use 0xCAFE::CalcModule;

    /// Calls CalcModule::add_and_offset internally and returns the result
    public fun nested_call_add_and_offset(x: u8, y: u8): u8 {
        CalcModule::add_and_offset(x, y)
    }

    /// Calls CalcModule::use_lambda with a lambda that adds two numbers
    public fun call_use_lambda_with_add(): u8 {
        let add_lambda: |u8, u8|u8 has copy + drop = |a: u8, b: u8| a + b;
        CalcModule::use_lambda(add_lambda, 7u8, 8u8)
    }

    /// Calls CalcModule::use_lambda with multiplier_lambda obtained from CalcModule
    public fun call_use_lambda_with_multiplier(): u8 {
        let mul_lambda = CalcModule::multiplier_lambda();
        CalcModule::use_lambda(mul_lambda, 6u8, 7u8)
    }
}



//# run 0xCAFE::CalcModule::add_and_offset --args 15u8 10u8



//# run 0xCAFE::UserModule::nested_call_add_and_offset --args 20u8 22u8



//# run 0xCAFE::UserModule::call_use_lambda_with_add



//# run 0xCAFE::UserModule::call_use_lambda_with_multiplier
