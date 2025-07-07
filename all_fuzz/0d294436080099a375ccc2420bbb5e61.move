
//# publish
module 0xCAFE::AdditionModule {
    public fun add_two_u8(x: u8, y: u8): u8 {
        x + y
    }

    struct InnerStruct has copy, drop, store {
        val: u8,
    }

    struct OuterStruct has copy, drop, store {
        inner: InnerStruct,
        flag: bool,
    }

    public fun make_outer_struct(x: u8, y: u8): OuterStruct {
        let sum = add_two_u8(x, y);
        let inner = InnerStruct { val: sum };
        OuterStruct { inner, flag: true }
    }
}



//# publish
module 0xCAFE::CallerModule {
    use 0xCAFE::AdditionModule;

    // Make these functions not inline, to ensure proper function resolution and calls at runtime.
    public fun call_addition_inline(x: u8, y: u8): u8 {
        AdditionModule::add_two_u8(x, y)
    }

    public fun call_make_outer_struct(x: u8, y: u8): AdditionModule::OuterStruct {
        AdditionModule::make_outer_struct(x, y)
    }
}



//# run 0xCAFE::AdditionModule::add_two_u8 --args 10u8 20u8



//# run 0xCAFE::AdditionModule::make_outer_struct --args 5u8 15u8



//# run 0xCAFE::CallerModule::call_addition_inline --args 7u8 8u8



//# run 0xCAFE::CallerModule::call_make_outer_struct --args 2u8 3u8
