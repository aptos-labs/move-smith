
//# publish
module 0xCAFE::AddModule {
    public fun add_and_return_specific_value(a: u8, b: u8): u8 {
        let sum = a + b;
        let specific_value = 42u8;
        sum + specific_value
    }

    public fun use_lambda_add(a: u8, b: u8): u8 {
        let add_lambda: |u8, u8| u8 has copy + drop = |x: u8, y: u8| {
            x + y
        };
        add_lambda(a, b)
    }
}



//# publish
module 0xCAFE::CallerModule {
    use 0xCAFE::AddModule;

    public fun call_inline_and_lambda(a: u8, b: u8): u8 {
        // Call a function from AddModule that calls a lambda inside itself
        let lambda_result = AddModule::use_lambda_add(a, b);

        // Call a function from AddModule that adds and then adds a specific value
        let total = AddModule::add_and_return_specific_value(a, b);

        lambda_result + total
    }

    public fun lvalue_assignment_example(): (u8, u8, u8) {
        let (x, y, z) = (1u8, 2u8, 3u8);
        (x, y, z)
    }
}



//# run 0xCAFE::AddModule::add_and_return_specific_value --args 3u8 4u8


//# run 0xCAFE::AddModule::use_lambda_add --args 7u8 2u8


//# run 0xCAFE::CallerModule::call_inline_and_lambda --args 5u8 6u8


//# run 0xCAFE::CallerModule::lvalue_assignment_example
