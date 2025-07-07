
//# publish
module 0xCAFE::LambdaTest {
    public fun add_and_return_sum(a: u8, b: u8): u8 {
        let sum = a + b;
        // Return sum + 1 just to have a specific value different from sum for sanity check
        sum + 1
    }

    public fun lambda_example(x: u8): u8 {
        let add_one: |u8|u8 has copy+drop = |a: u8| {
            a + 1
        };
        add_one(x)
    }

    public fun call_inline_from_other_module(x: u16): u16 {
        let (a, b) = 0xCAFE::LambdaTest::inline_increment_and_double(x);
        a + b
    }

    public inline fun inline_increment_and_double(a: u16): (u16, u16) {
        (a + 1, a * 2)
    }

    spec module {
        update add_and_return_sum.result = a + b + 1;
    }
}
