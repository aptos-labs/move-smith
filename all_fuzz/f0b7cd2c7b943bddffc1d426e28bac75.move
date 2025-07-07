
//# publish
module 0xCAFE::MyModule {
    public fun f2(x: u16): (u16, u16) {
        (x, x + 1)
    }
}

//# publish
module 0xCAFE::LambdaTest {
    public fun add_and_return_fixed(a: u8, b: u8, fixed: u8): u8 {
        let sum = a + b;
        let _ = sum; // to emphasize sum is computed
        fixed
    }

    public fun caller_lambda(): u8 {
        let lambda: |u8, u8| u8 has copy+drop = |x: u8, y: u8| {
            x + y
        };
        lambda(10u8, 20u8)
    }

    public fun call_my_module_inline(x: u16): (u16, u16) {
        0xCAFE::MyModule::f2(x)
    }
}



//# run 0xCAFE::LambdaTest::add_and_return_fixed --args 12u8 34u8 77u8



//# run 0xCAFE::LambdaTest::caller_lambda



//# run 0xCAFE::LambdaTest::call_my_module_inline --args 123u16
