
//# publish
module 0xCAFE::MyModule {
    public fun f2(a: u16): (u16, u16) {
        (a, a * 2)
    }
}


//# publish
module 0xCAFE::LambdaTest {
    public fun add_and_return_specific(x: u8, y: u8): u8 {
        let sum = x + y;
        if (sum > 10) {
            42u8
        } else {
            24u8
        }
    }

    public fun call_lambda(x: u8, y: u8): (u8, u8) {
        let lambda: |u8, u8| (u8, u8) has copy+drop = |a: u8, b: u8| {
            let c = a + b;
            let d = a * b;
            (c, d)
        };
        lambda(x, y)
    }

    public fun call_nested_inline_func(a: u16): (u16, u16) {
        0xCAFE::MyModule::f2(a)
    }
}





//# run 0xCAFE::LambdaTest::add_and_return_specific --args 3u8 4u8



//# run 0xCAFE::LambdaTest::add_and_return_specific --args 6u8 7u8



//# run 0xCAFE::LambdaTest::call_lambda --args 5u8 6u8



//# run 0xCAFE::LambdaTest::call_nested_inline_func --args 20u16
