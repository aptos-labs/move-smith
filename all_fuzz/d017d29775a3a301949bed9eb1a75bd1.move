
//# publish
module 0xCAFE::AddModule {
    public fun add_and_return_sum(x: u8, y: u8): u8 {
        x + y
    }
}

//# publish
module 0xCAFE::NestedCallModule {
    use 0xCAFE::AddModule;

    public fun nested_calls(x: u8, y: u8): u8 {
        let sum = AddModule::add_and_return_sum(x, y);
        if (sum > 15) {
            sum - 5
        } else {
            sum + 5
        }
    }
}
