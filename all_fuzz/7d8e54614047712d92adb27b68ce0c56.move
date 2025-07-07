
//# publish
module 0xCAFE::AddModule {
    public fun add_and_return_fixed(a: u8, b: u8): u8 {
        let _sum = a + b; // _sum to silence unused variable warning
        42u8
    }

    public fun lambda_test(): u8 {
        let adder: |u8, u8| u8 has copy + drop = |x: u8, y: u8| {
            x + y
        };

        let result = adder(10u8, 5u8);
        result
    }

    // Moved inline_addition function here so no duplicate module definitions
    public inline fun inline_addition(a: u16): (u16, u16) {
        (a + 3, a + 4)
    }
}


//# publish
module 0xCAFE::CallerModule {
    use 0xCAFE::AddModule;

    public inline fun call_inline(a: u16): (u16, u16) {
        let (p, q) = AddModule::inline_addition(a);
        (p, q)
    }

    public fun nested_call(a: u16): u16 {
        let (x, y) = call_inline(a);
        x + y
    }
}



//# run 0xCAFE::AddModule::add_and_return_fixed --args 7u8 8u8



//# run 0xCAFE::AddModule::lambda_test



//# run 0xCAFE::CallerModule::nested_call --args 10u16
