
//# publish
module 0xCAFE::AddModule {
    public fun add_and_return_fixed(x: u8, y: u8): u8 {
        let sum = x + y;
        // Return fixed value 42 if sum is greater than 10, else return sum
        if (sum > 10) {
            42
        } else {
            sum
        }
    }

    public fun lambda_example(x: u8, y: u8): u8 {
        // Define a lambda that multiplies two u8 numbers
        let multiply: |u8, u8| u8 has copy+drop = |a: u8, b: u8| {
            a * b
        };
        multiply(x, y)
    }
}



//# run 0xCAFE::AddModule::add_and_return_fixed --args 5u8 6u8



//# run 0xCAFE::AddModule::add_and_return_fixed --args 3u8 4u8



//# run 0xCAFE::AddModule::lambda_example --args 7u8 8u8




//# publish
module 0xCAFE::NestedCaller {
    // Fix: Add explicit 'use' statement referring to the module address and name
    use 0xCAFE::AddModule;

    public fun call_inline_and_lambda(x: u8, y: u8): (u8, u8) {
        // Call AddModule::add_and_return_fixed to get first result
        let fixed_result = AddModule::add_and_return_fixed(x, y);

        // Call AddModule::lambda_example to multiply values
        let lambda_result = AddModule::lambda_example(x, y);

        (fixed_result, lambda_result)
    }
}



//# run 0xCAFE::NestedCaller::call_inline_and_lambda --args 4u8 9u8



//# run 0xCAFE::NestedCaller::call_inline_and_lambda --args 2u8 3u8
