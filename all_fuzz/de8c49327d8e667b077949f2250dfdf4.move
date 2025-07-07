
//# publish
module 0xCAFE::MyModule {
    public fun f2(a: u16): (u16, u16) {
        (a, a + 1)
    }
}

//# publish
module 0xCAFE::LambdaTest {
    public fun add_then_return(a: u8, b: u8): u8 {
        let sum = a + b;
        42u8 + sum
    }

    public fun lambda_add(a: u8, b: u8): u8 {
        let add_lambda: |u8, u8| u8 has copy+drop = |x: u8, y: u8| {
            x + y
        };
        add_lambda(a, b)
    }

    public fun call_inline_from_other_module(a: u16): (u16, u16) {
        0xCAFE::MyModule::f2(a)
    }

    public fun while_loop_test(x: u8): u8 {
        let x = x;
        while (x < 5) {
            x = x + 1;
        };
        x
    }
}


//# run 0xCAFE::LambdaTest::add_then_return --args 2u8 3u8


//# run 0xCAFE::LambdaTest::lambda_add --args 7u8 8u8


//# run 0xCAFE::LambdaTest::call_inline_from_other_module --args 20u16


//# run 0xCAFE::LambdaTest::while_loop_test --args 0u8
