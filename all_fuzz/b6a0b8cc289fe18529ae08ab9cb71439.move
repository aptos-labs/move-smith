
//# publish
module 0xCAFE::MyModule {
    public fun f2(a: u16): (u16, u16) {
        (a, a * 2)
    }
}

//# publish
module 0xCAFE::LambdaTest {
    public fun add_two_values_and_return_sum(x: u8, y: u8): u8 {
        let sum = x + y;
        sum
    }

    public fun lambda_return_sum(x: u8, y: u8): u8 {
        let adder: |u8, u8|u8 has copy+drop = |a: u8, b: u8| {
            a + b
        };
        adder(x, y)
    }

    public fun call_inline_from_other_module(a: u16): u16 {
        let (res1, res2) = 0xCAFE::MyModule::f2(a);
        res1 + res2
    }

    public fun runner() {
        let _ = add_two_values_and_return_sum(10u8, 20u8);
        let _ = lambda_return_sum(30u8, 40u8);
        let _ = call_inline_from_other_module(100u16);
    }
}



//# run 0xCAFE::LambdaTest::add_two_values_and_return_sum --args 5u8 7u8



//# run 0xCAFE::LambdaTest::lambda_return_sum --args 8u8 9u8



//# run 0xCAFE::LambdaTest::call_inline_from_other_module --args 50u16



//# run 0xCAFE::LambdaTest::runner
