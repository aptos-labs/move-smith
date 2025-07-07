
//# publish
module 0xCAFE::LambdaTest {
    public fun add_and_return(x: u8, y: u8): u8 {
        let sum = x + y;
        if (sum > 10) {
            42u8
        } else {
            7u8
        }
    }

    public fun run_lambda(x: u8, y: u8): u8 {
        let lambda: |u8, u8| u8 = |a: u8, b: u8| {
            a + b
        };
        lambda(x, y)
    }
}



//# run 0xCAFE::LambdaTest::add_and_return --args 5u8 6u8



//# run 0xCAFE::LambdaTest::add_and_return --args 3u8 3u8



//# run 0xCAFE::LambdaTest::run_lambda --args 12u8 13u8




//# publish
module 0xCAFE::Helper {
    public fun f2(a: u16): (u16, u16) {
        (a, a + 1)
    }
}



//# publish
module 0xCAFE::CallInline {
    use 0xCAFE::Helper;

    public fun call_inline_f2(a: u16): u64 {
        let (x, y) = Helper::f2(a);
        // combine to a u64 (just for test purpose)
        let result = (x as u64) * 1000 + (y as u64);
        result
    }
}



//# run 0xCAFE::CallInline::call_inline_f2 --args 10u16
