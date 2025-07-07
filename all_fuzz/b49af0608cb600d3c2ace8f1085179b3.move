
//# publish
module 0xCAFE::InlineModule {
    public inline fun inline_func(x: u16): (u16, u16) {
        (x + 5, x + 10)
    }
}


//# publish
module 0xCAFE::AddModule {
    public fun add_and_return_sum(a: u8, b: u8): u8 {
        let sum = a + b;
        if (sum > 200) {
            255u8
        } else {
            sum
        }
    }

    public fun use_lambda(a: u8, b: u8): u8 {
        let adder: |u8, u8| u8 has copy+drop = |x: u8, y: u8| {
            x + y
        };
        adder(a, b)
    }

    public fun call_inline_from_other_module(a: u16): u32 {
        let (p, q) = 0xCAFE::InlineModule::inline_func(a);
        (p as u32) * (q as u32)
    }
}



//# run 0xCAFE::AddModule::add_and_return_sum --args 100u8 101u8



//# run 0xCAFE::AddModule::add_and_return_sum --args 50u8 70u8



//# run 0xCAFE::AddModule::use_lambda --args 20u8 22u8



//# run 0xCAFE::AddModule::call_inline_from_other_module --args 3u16
