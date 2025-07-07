
//# publish
module 0xCAFE::AddModule {
    public fun add_then_return_fixed(_a: u8, _b: u8): u8 {
        let _sum = _a + _b;
        let fixed = 42u8;
        fixed
    }

    public fun lambda_example(): (u8, u8) {
        let lambda: |u8, u8| (u8, u8) has copy + drop = |x: u8, y: u8| {
            let add = x + y;
            let mul = x * y;
            (add, mul)
        };
        lambda(10u8, 20u8)
    }
}



//# run 0xCAFE::AddModule::add_then_return_fixed --args 5u8 7u8



//# run 0xCAFE::AddModule::lambda_example



//# publish
module 0xCAFE::NestedCallModule {
    use 0xCAFE::AddModule;

    // Removed `inline` from this function
    public fun call_add_then_return_fixed(a: u8, b: u8): u8 {
        AddModule::add_then_return_fixed(a, b)
    }

    public fun call_lambda_from_add_module(): (u8, u8) {
        AddModule::lambda_example()
    }

    public fun runner(): u8 {
        let result = call_add_then_return_fixed(3u8, 4u8);
        result
    }
}



//# run 0xCAFE::NestedCallModule::call_add_then_return_fixed --args 2u8 3u8



//# run 0xCAFE::NestedCallModule::call_lambda_from_add_module



//# run 0xCAFE::NestedCallModule::runner
