
//# publish
module 0xCAFE::AdditionTest {
    public fun add_and_return_sum(x: u8, y: u8): u8 {
        let sum = x + y;
        sum
    }

    public fun lambda_double_then_add(x: u8, y: u8): u8 {
        // Instead of a lambda closure (which is unsupported), use a local variable and logic for doubling
        let dx = x + x;
        let dy = y + y;

        let result = dx + dy;
        result
    }

    public inline fun inline_increment(x: u8): u8 {
        x + 1
    }
}



//# publish
module 0xCAFE::NestedInlineCall {
    use 0xCAFE::AdditionTest;

    public fun nested_calls(x: u8, y: u8): u8 {
        let sum = AdditionTest::add_and_return_sum(x, y);
        let incremented = AdditionTest::inline_increment(sum);
        incremented
    }
}



//# run 0xCAFE::AdditionTest::add_and_return_sum --args 10u8 15u8



//# run 0xCAFE::AdditionTest::lambda_double_then_add --args 5u8 6u8



//# run 0xCAFE::NestedInlineCall::nested_calls --args 20u8 22u8
