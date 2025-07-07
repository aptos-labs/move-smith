
//# publish
module 0xCAFE::InlineAdd {
    public inline fun add_u8(a: u8, b: u8): u8 {
        a + b
    }

    public fun add_and_return(a: u8, b: u8, ret: u8): u8 {
        let sum = Self::add_u8(a, b);
        // ignoring sum and returning ret just to test return value
        ret
    }
}



//# run 0xCAFE::InlineAdd::add_and_return --args 10u8 20u8 77u8



//# publish
module 0xCAFE::LambdaTest {
    public fun call_lambda(a: u8, b: u8): u8 {
        let lambda: |u8, u8| u8 has copy+drop = |x: u8, y: u8| {
            x + y
        };
        lambda(a, b)
    }

    public fun nested_lambda_call(): u8 {
        // Compose a lambda that calls another lambda
        let inner_lambda: |u8, u8| u8 has copy+drop = |x: u8, y: u8| x + y;
        let outer_lambda: |u8| u8 has copy+drop = |z: u8| {
            inner_lambda(z, 5u8)
        };
        outer_lambda(10u8)
    }
}



//# run 0xCAFE::LambdaTest::call_lambda --args 3u8 4u8



//# run 0xCAFE::LambdaTest::nested_lambda_call



//# publish
module 0xCAFE::CallerModule {
    use 0xCAFE::InlineAdd;

    public fun call_inline_add(a: u8, b: u8): u8 {
        let sum = InlineAdd::add_u8(a, b);
        sum
    }

    public fun call_inline_and_nested(a: u8, b: u8): u8 {
        // Call InlineAdd::add_and_return but give ret value as sum of a+b
        let computed = Self::call_inline_add(a, b);
        InlineAdd::add_and_return(a, b, computed)
    }
}



//# run 0xCAFE::CallerModule::call_inline_add --args 12u8 8u8



//# run 0xCAFE::CallerModule::call_inline_and_nested --args 20u8 22u8
