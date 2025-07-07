
//# publish
module 0xCAFE::InlineModule {
    public inline fun increment_pair(x: u16): (u16, u16) {
        (x + 1, x + 2)
    }
}


//# publish
module 0xCAFE::LambdaTest {
    use 0xCAFE::InlineModule;

    public fun add_and_return(x: u8, y: u8): u8 {
        let sum = x + y;
        if (sum < 10) {
            42u8
        } else {
            99u8
        }
    }

    public fun apply_lambda(x: u8, y: u8): (u8, u8) {
        let lam: |u8, u8| (u8, u8) has copy+drop = |a: u8, b: u8| {
            let _sum = a + b;
            let product = a * b;
            (_sum, product)
        };
        lam(x, y)
    }

    public fun call_inline_and_add(a: u16, b: u16): u32 {
        let (x, y) = InlineModule::increment_pair(a);
        (x as u32) + (y as u32) + (b as u32)
    }
}



//# run 0xCAFE::LambdaTest::add_and_return --args 3u8 4u8



//# run 0xCAFE::LambdaTest::add_and_return --args 7u8 8u8



//# run 0xCAFE::LambdaTest::apply_lambda --args 5u8 7u8



//# run 0xCAFE::LambdaTest::call_inline_and_add --args 10u16 20u16
