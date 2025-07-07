
//# publish
module 0xCAFE::AddModule {
    public fun add_and_return_specific_value(a: u8, b: u8): u8 {
        let sum = a + b;
        if (sum == 100) {
            42u8
        } else {
            sum
        }
    }

    public fun lambda_example(): u8 {
        let add_lambda: |u8, u8| u8 has copy+drop = |x: u8, y: u8| {
            x + y
        };
        let result = add_lambda(10u8, 20u8);
        result
    }

    public inline fun inline_add(x: u8, y: u8): u8 {
        x + y
    }
}



//# run 0xCAFE::AddModule::add_and_return_specific_value --args 60u8 40u8



//# run 0xCAFE::AddModule::add_and_return_specific_value --args 10u8 15u8



//# run 0xCAFE::AddModule::lambda_example




//# publish
module 0xCAFE::CallInline {
    use 0xCAFE::AddModule;

    public fun call_inline_add(x: u8, y: u8): u8 {
        AddModule::inline_add(x, y)
    }
}



//# run 0xCAFE::CallInline::call_inline_add --args 10u8 20u8



//# publish
module 0xCAFE::TransformModule {
    // mock of extract_spec_module usage to simulate a transformation by address
    // since the function is hypothetical, we simulate with a function that can be called
    // no actual Move code for extract_spec_module as it's not part of Move standard libs

    public fun transform_by_address_module(addr: address) {
        // no actual implementation since extract_spec_module is external
        // just a placeholder function to represent this test requirement
        let _ = addr;
    }
}



//# run 0xCAFE::TransformModule::transform_by_address_module --args 0xCAFE000000000000000000000000000000000000
