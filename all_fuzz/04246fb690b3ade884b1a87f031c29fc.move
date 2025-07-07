//# publish
module 0xCAFE::AddModule {
    public inline fun add_and_return_sum(x: u8, y: u8): u8 {
        let sum = x + y;
        sum
    }

    public fun add_and_return_fixed_value(x: u8, y: u8): u8 {
        let _sum = x + y;
        42u8
    }

    public fun runner(): u8 {
        add_and_return_sum(10u8, 20u8)
    }
}

//# publish
module 0xCAFE::NestedCallModule {
    use 0xCAFE::AddModule;

    public inline fun call_add_and_return_sum_inline(x: u8, y: u8): u8 {
        AddModule::add_and_return_sum(x, y)
    }

    public fun call_add_and_return_sum(x: u8, y: u8): u8 {
        call_add_and_return_sum_inline(x, y)
    }

    public fun runner(): u8 {
        call_add_and_return_sum(15u8, 25u8)
    }
}
