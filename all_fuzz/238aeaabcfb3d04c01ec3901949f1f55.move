
//# publish
module 0xCAFE::MyModule {
    public fun f2(a: u16): (u16, u16) {
        // For example purpose, just return (a, a)
        (a, a)
    }
}

//# publish
module 0xCAFE::AdditionTest {
    public fun add_then_return_fixed(a: u8, b: u8): u8 {
        let sum = a + b;
        let fixed_return = 42u8;
        fixed_return
    }

    public fun lambda_sum(a: u8, b: u8): u8 {
        let sum_lambda: |u8, u8| u8 has copy+drop = |x: u8, y: u8| {
            x + y
        };
        sum_lambda(a, b)
    }

    public fun call_nested_inline(a: u16): u32 {
        let (p, q) = 0xCAFE::MyModule::f2(a);
        (p + q) as u32
    }
}



//# run 0xCAFE::AdditionTest::add_then_return_fixed --args 10u8 32u8



//# run 0xCAFE::AdditionTest::lambda_sum --args 11u8 22u8



//# run 0xCAFE::AdditionTest::call_nested_inline --args 100u16
