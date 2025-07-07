
//# publish
module 0xCAFE::MyModule {
    public inline fun f2(a: u16): (u16, u16) {
        (a, a + 1)
    }
}

//# publish
module 0xCAFE::LambdaTest {
    public fun add_and_return_special(a: u8, b: u8): u8 {
        let sum = a + b;
        if (sum == 10) {
            42u8
        } else {
            0u8
        }
    }

    public fun call_lambda_and_return(input: u8): u8 {
        let lambda: |u8|u8 has copy+drop = |x: u8| {
            x * 2
        };
        lambda(input)
    }

    public fun call_inline_from_other_module_and_add(a: u16, b: u16): u32 {
        let (x, y) = 0xCAFE::MyModule::f2(a);
        let sum = x + y + b;
        sum as u32
    }
}



//# run 0xCAFE::LambdaTest::add_and_return_special --args 7u8 3u8

//# run 0xCAFE::LambdaTest::add_and_return_special --args 2u8 3u8

//# run 0xCAFE::LambdaTest::call_lambda_and_return --args 5u8

//# run 0xCAFE::LambdaTest::call_inline_from_other_module_and_add --args 2u16 3u16
