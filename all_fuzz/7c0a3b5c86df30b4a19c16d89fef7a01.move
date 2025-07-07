
//# publish
module 0xCAFE::MyModule {
    public fun f1(a: u8, b: bool): u8 {
        // For example, return 'a' + (if b then 1 else 0)
        a + (if (b) { 1 } else { 0 })
    }

    public fun f2(x: u16): (u8, u8) {
        // For example, returns (x + 1) as u8 and (x + 2) as u8
        ((x + 1) as u8, (x + 2) as u8)
    }
}


//# publish
module 0xCAFE::Adder {
    public fun add_then_f1(a: u8, b: u8): u8 {
        let sum = a + b;
        0xCAFE::MyModule::f1(sum, false)
    }

    public fun test_lambda() {
        let lambda: |u8, u8| u8 has copy + drop = |x: u8, y: u8| {
            x + y
        };
        let _res = lambda(10u8, 15u8);
    }

    public fun use_inline_add_and_call_f1(x: u16, y: u16): u8 {
        let (x_plus_1, y_plus_2) = 0xCAFE::MyModule::f2(x);
        // Compose sum and pass boolean false to f1
        let sum: u8 = (x_plus_1 + y_plus_2 + (y as u8));
        0xCAFE::MyModule::f1(sum, false)
    }
}




//# run 0xCAFE::Adder::add_then_f1 --args 3u8 4u8




//# run 0xCAFE::Adder::test_lambda




//# run 0xCAFE::Adder::use_inline_add_and_call_f1 --args 10u16 20u16
