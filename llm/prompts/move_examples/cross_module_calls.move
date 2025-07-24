//# publish
module 0xCAFE::Helper {
    public fun helper_function(x: u8, y: bool): u8 {
        if (y) { x + 1 } else { x }
    }

    struct Data has copy, drop, store {
        value: u16
    }

    public fun create_data(x: u16): Data {
        Data { value: x }
    }
}

//# publish
module 0xCAFE::CrossModuleCalls {
    use 0xCAFE::Helper;

    public fun cross_module_call() {
        let _ = 0xCAFE::Helper::helper_function(1u8, true);
        let _ = Helper::create_data(10u16);
    }
}

//# run 0xCAFE::CrossModuleCalls::cross_module_call
