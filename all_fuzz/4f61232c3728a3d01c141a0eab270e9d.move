
//# publish
module 0xCAFE::MyModule {
    public fun f2(x: u16): (u16, u16) {
        (x, x + 1)
    }
}

//# publish
module 0xCAFE::LambdaTest {
    public fun add_and_return_fixed_value(a: u8, b: u8): u8 {
        let sum = a + b;
        let _ignore = sum;
        42u8
    }

    public fun run_lambda_example(x: u8, y: u8): u8 {
        let lambda: |u8, u8| u8 has copy+drop = |a: u8, b: u8| {
            a * b
        };
        let product = lambda(x, y);

        product
    }

    public fun call_inline_from_other_module(x: u16): u16 {
        let (a, b) = 0xCAFE::MyModule::f2(x);
        a + b
    }

    public fun runner() {
        let _ = add_and_return_fixed_value(10u8, 32u8);
        let _ = run_lambda_example(6u8, 7u8);
        let _ = call_inline_from_other_module(5u16);
    }
}



//# run 0xCAFE::LambdaTest::add_and_return_fixed_value --args 10u8 32u8



//# run 0xCAFE::LambdaTest::run_lambda_example --args 6u8 7u8



//# run 0xCAFE::LambdaTest::call_inline_from_other_module --args 5u16



//# run 0xCAFE::LambdaTest::runner
