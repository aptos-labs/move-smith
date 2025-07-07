
//# publish
module 0xCAFE::MyModule {
    public inline fun f2(x: u16): (u16, u16) {
        (x, x + 1)
    }
}

//# publish
module 0xCAFE::LambdaTest {
    public fun add_and_return(a: u8, b: u8, ret_val: u8): u8 {
        let _sum = a + b;
        // ignore sum but just compute it
        ret_val
    }

    public fun lambda_example(x: u8): u8 {
        let lambda: |u8|u8 has copy+drop = |a: u8| {
            a + 10u8
        };
        lambda(x)
    }

    public fun call_inline_f3(x: u16): u32 {
        // Call inline function f2 in MyModule
        let (a, b) = 0xCAFE::MyModule::f2(x);
        (a as u32) + (b as u32)
    }
}



//# run 0xCAFE::LambdaTest::add_and_return --args 3u8 7u8 42u8


//# run 0xCAFE::LambdaTest::lambda_example --args 5u8


//# run 0xCAFE::LambdaTest::call_inline_f3 --args 100u16
