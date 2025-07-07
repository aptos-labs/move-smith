
//# publish
module 0xCAFE::MyModule {
    public fun f2(val: u16): (u16, u16) {
        (val, val + 1)
    }
}

//# publish
module 0xCAFE::Adder {
    public fun add_two_u8(a: u8, b: u8): u8 {
        let sum = a + b;
        if (sum > 10) {
            42u8
        } else {
            sum
        }
    }

    public fun add_with_lambda(a: u8, b: u8): u8 {
        let lambda: |u8, u8|u8 has copy+drop = |x: u8, y: u8| {
            x + y
        };
        lambda(a, b)
    }

    public fun call_inline_add_and_double(x: u16, y: u16): (u16, u16) {
        let (a, b) = 0xCAFE::MyModule::f2(x + y);
        (a * 2, b * 2)
    }
}



//# run 0xCAFE::Adder::add_two_u8 --args 4u8 7u8



//# run 0xCAFE::Adder::add_two_u8 --args 5u8 3u8



//# run 0xCAFE::Adder::add_with_lambda --args 10u8 15u8



//# run 0xCAFE::Adder::call_inline_add_and_double --args 10u16 5u16
