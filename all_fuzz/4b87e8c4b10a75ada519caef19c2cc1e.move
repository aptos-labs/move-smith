
//# publish
module 0xCAFE::MyModule {
    public fun f2(x: u16): (u16, u16) {
        // Just return (x, x + 1) as example
        (x, x + 1)
    }
}

//# publish
module 0xCAFE::LambdaModule {
    public fun add_u8_values(a: u8, b: u8): u8 {
        let sum = a + b;
        sum + 10u8
    }

    public fun use_lambda(a: u8, b: u8): u8 {
        let lambda: |u8, u8| u8 has copy+drop = |x: u8, y: u8| {
            x + y
        };
        lambda(a, b)
    }

    public fun call_inline_of_other_module(x: u16): u32 {
        let (a, b) = 0xCAFE::MyModule::f2(x);
        let sum = (a as u32) + (b as u32);
        sum
    }
}



//# run 0xCAFE::LambdaModule::add_u8_values --args 5u8 7u8



//# run 0xCAFE::LambdaModule::use_lambda --args 8u8 4u8



//# run 0xCAFE::LambdaModule::call_inline_of_other_module --args 20u16
