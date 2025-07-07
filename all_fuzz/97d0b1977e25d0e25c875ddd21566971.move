
//# publish
module 0xCAFE::InlineModule {
    // An inline function with tuple return
    public inline fun inline_add_two(a: u16): (u16, u16) {
        (a + 2, a + 3)
    }
}



//# publish
module 0xCAFE::LambdaTest {
    use 0xCAFE::InlineModule;

    // A simple function that takes two u8 and returns u8 after addition plus offset
    public fun add_and_offset(a: u8, b: u8): u8 {
        let sum = a + b;
        // Add fixed offset
        sum + 10u8
    }

    // A function demonstrating lambdas: doubles then increments the input
    public fun lambda_demo(x: u8): u8 {
        let double = |v: u8| v + v;
        let increment = |v: u8| v + 1;
        let doubled = double(x);
        increment(doubled)
    }

    // Calls InlineModule's inline function inside a lambda to test cross-module call
    public fun nested_lambda_call(x: u16): u16 {
        let lambda = |val: u16| {
            let (a, b) = InlineModule::inline_add_two(val);
            a + b
        };
        lambda(x)
    }
}




//# run 0xCAFE::LambdaTest::add_and_offset --args 5u8 6u8




//# run 0xCAFE::LambdaTest::lambda_demo --args 7u8




//# run 0xCAFE::LambdaTest::nested_lambda_call --args 10u16
