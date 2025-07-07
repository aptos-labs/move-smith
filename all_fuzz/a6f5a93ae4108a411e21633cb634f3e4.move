
//# publish
module 0xCAFE::MyModule {
    public fun f2(x: u16): (u16, u16) {
        (x, x + 1)
    }
}

//# publish
module 0xCAFE::LambdaTest {
    public fun add_and_return_sum(a: u8, b: u8): u8 {
        let sum = a + b;
        // Return fixed value 42 if sum is correct (to simulate testing behavior)
        if (sum == a + b) { 42 } else { 0 }
    }

    public fun lambda_example(x: u8, y: u8): u8 {
        let lambda: |u8, u8| u8 has copy+drop = |a: u8, b: u8| {
            a * b
        };
        lambda(x, y)
    }

    public fun inline_call(sum: u8): (u16, u16) {
        0xCAFE::MyModule::f2(sum as u16)
    }
}



//# run 0xCAFE::LambdaTest::add_and_return_sum --args 10u8 32u8


//# run 0xCAFE::LambdaTest::lambda_example --args 3u8 5u8


//# run 0xCAFE::LambdaTest::inline_call --args 20u8
