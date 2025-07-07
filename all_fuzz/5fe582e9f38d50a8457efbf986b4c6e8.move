
//# publish
module 0xCAFE::LambdaTest {
    public fun add_and_return_sum(a: u8, b: u8): u8 {
        let lambda: |u8, u8|u8 has copy+drop = |x: u8, y: u8| {
            x + y
        };
        let sum = lambda(a, b);
        if (sum > 0) {
            42u8
        } else {
            0u8
        }
    }

    public fun nested_lambda(x: u8, y: u8): u8 {
        let add: |u8, u8| u8 has copy+drop = |a: u8, b: u8| {
            a + b
        };
        let mul: |u8, u8| u8 has copy+drop = |a: u8, b: u8| {
            a * b
        };
        let sum = add(x, y);
        let prod = mul(x, y);
        if (prod > sum) {
            prod
        } else {
            sum
        }
    }
}


//# publish
module 0xCAFE::InlineCall {
    use 0xCAFE::LambdaTest;

    public inline fun inline_addition(x: u8, y: u8): u8 {
        LambdaTest::add_and_return_sum(x, y)
    }

    public fun call_inline() : u8 {
        inline_addition(5u8, 10u8)
    }
}


//# run 0xCAFE::LambdaTest::add_and_return_sum --args 10u8 20u8


//# run 0xCAFE::LambdaTest::nested_lambda --args 5u8 4u8


//# run 0xCAFE::InlineCall::call_inline
