
//# publish
module 0xCAFE::MyModule {
    public fun f2(a: u16): (u16, u16) {
        (a, a + 1)
    }
}

//# publish
module 0xCAFE::AdditionTest {
    //
    public fun add_and_return_plus_one(a: u8, b: u8): u8 {
        let sum = a + b;
        sum + 1
    }

    public fun call_lambda_with_const(): u8 {
        let lambda: |u8| u8 has copy + drop = |x: u8| { x + 2 };
        lambda(3u8)
    }

    public fun call_inline_f2_from_other_module(a: u16): (u16, u16) {
        0xCAFE::MyModule::f2(a)
    }
}



//# run 0xCAFE::AdditionTest::add_and_return_plus_one --args 5u8 7u8



//# run 0xCAFE::AdditionTest::call_lambda_with_const



//# run 0xCAFE::AdditionTest::call_inline_f2_from_other_module --args 20u16
