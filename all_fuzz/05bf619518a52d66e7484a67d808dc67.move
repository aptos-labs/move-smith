
//# publish
module 0xCAFE::AddModule {
    public fun add_two_values(a: u8, b: u8): u8 {
        let sum = a + b;
        sum + 1u8
    }

    // Move currently does not support returning function types or closures.
    // Instead, we can define a function and call it directly.
    public fun create_lambda_call(x: u8, y: u8): u8 {
        x + y
    }

    public fun apply_lambda(x: u8, y: u8): u8 {
        // call the "lambda" function
        create_lambda_call(x, y)
    }
}




//# run 0xCAFE::AddModule::add_two_values --args 5u8 10u8




//# run 0xCAFE::AddModule::apply_lambda --args 7u8 8u8




//# publish
module 0xCAFE::NestedCalls {
    use 0xCAFE::AddModule;

    public inline fun double_add(x: u8, y: u8): u8 {
        let sum = AddModule::add_two_values(x, y);
        AddModule::add_two_values(sum, 1u8)
    }

    public fun runner(): u8 {
        double_add(3u8, 4u8)
    }
}




//# run 0xCAFE::NestedCalls::runner




//# publish
module 0xCAFE::NamedAddressExample {
    const NAMED_ADDR_1: address = @0xCAFE;
    const NAMED_ADDR_2: address = @0xBEEF;

    public fun check_addresses(): (address, address) {
        (NAMED_ADDR_1, NAMED_ADDR_2)
    }
}




//# run 0xCAFE::NamedAddressExample::check_addresses
