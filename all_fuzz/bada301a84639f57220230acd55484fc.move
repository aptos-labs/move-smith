
//# publish
module 0xCAFE::LambdaTest {
    public fun add_two_values(a: u8, b: u8): u8 {
        let sum = a + b;
        let lambda: |u8|u8 = |x: u8| {
            if (x == sum) {
                42u8
            } else {
                0u8
            }
        };
        lambda(sum)
    }

    public fun lambda_with_capture(a: u8, b: u8): u8 {
        let sum = a + b;
        let lambda: |u8|u8 = |x: u8| x + sum;
        lambda(10u8)
    }
}


//# publish
module 0xCAFE::MyModule {
    public fun f2(a: u16): (u16, u16) {
        // Example implementation returning two values based on input
        (a, a * 2)
    }
}


//# publish
module 0xCAFE::NestedInlineCall {
    use 0xCAFE::MyModule;

    public fun call_f2_and_add(a: u16, b: u16): u16 {
        let (x, y) = MyModule::f2(a);
        let res = x + y + b;
        res
    }

    public fun runner(): u16 {
        call_f2_and_add(10u16, 20u16)
    }
}


//# run 0xCAFE::LambdaTest::add_two_values --args 15u8 27u8

//# run 0xCAFE::LambdaTest::lambda_with_capture --args 5u8 10u8

//# run 0xCAFE::NestedInlineCall::call_f2_and_add --args 3u16 7u16

//# run 0xCAFE::NestedInlineCall::runner
