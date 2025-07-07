
//# publish
module 0xCAFE::AddModule {
    const CONST_VAL: u8 = 10;

    public fun add_two(a: u8, b: u8): u8 {
        let sum = a + b;
        if (sum > CONST_VAL) {
            CONST_VAL
        } else {
            sum
        }
    }

    public fun with_lambda(x: u8, y: u8): u8 {
        let lambda: |u8, u8| u8 has copy+drop = |a: u8, b: u8| {
            a + b
        };
        lambda(x, y)
    }

    public inline fun inline_add(a: u8, b: u8): u8 {
        a + b
    }
}



//# publish
module 0xCAFE::CallerModule {
    use 0xCAFE::AddModule;

    public fun call_inline_add(x: u8, y: u8): u8 {
        AddModule::inline_add(x, y)
    }

    public fun call_add_two(x: u8, y: u8): u8 {
        AddModule::add_two(x, y)
    }

    public fun call_lambda(x: u8, y: u8): u8 {
        AddModule::with_lambda(x, y)
    }
}



//# run 0xCAFE::AddModule::add_two --args 5u8 3u8



//# run 0xCAFE::AddModule::add_two --args 8u8 5u8



//# run 0xCAFE::AddModule::with_lambda --args 6u8 4u8



//# run 0xCAFE::CallerModule::call_inline_add --args 7u8 8u8



//# run 0xCAFE::CallerModule::call_add_two --args 2u8 3u8



//# run 0xCAFE::CallerModule::call_lambda --args 20u8 22u8
