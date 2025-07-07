
//# publish
module 0xCAFE::LambdaTest {
    public fun add_and_return_special_value(a: u8, b: u8): u8 {
        let sum = a + b;

        // Return special value 42 if sum is 10, else return sum
        if (sum == 10) {
            42
        } else {
            sum
        }
    }

    public fun call_lambda_example(x: u8, y: u8): (u8, u8) {
        let lambda: |u8, u8| (u8, u8) has copy+drop = |a: u8, b: u8| {
            let c = a + b;
            let d = a * b;
            (c, d)
        };
        lambda(x, y)
    }
}



//# publish
module 0xCAFE::InlineCallTest {
    use 0xCAFE::LambdaTest;

    public inline fun inline_adder(x: u8, y: u8): u8 {
        x + y
    }

    public fun call_inline_adder_indirectly(a: u8, b: u8): u8 {
        let sum = inline_adder(a, b);
        let result = LambdaTest::add_and_return_special_value(sum, 0u8);
        result
    }
}



//# run 0xCAFE::LambdaTest::add_and_return_special_value --args 3u8 7u8



//# run 0xCAFE::LambdaTest::add_and_return_special_value --args 5u8 4u8



//# run 0xCAFE::LambdaTest::call_lambda_example --args 6u8 7u8



//# run 0xCAFE::InlineCallTest::call_inline_adder_indirectly --args 2u8 8u8



//# run 0xCAFE::InlineCallTest::call_inline_adder_indirectly --args 1u8 4u8
