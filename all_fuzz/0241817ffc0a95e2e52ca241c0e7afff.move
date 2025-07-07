
//# publish
module 0xCAFE::NestedCall {
    public inline fun double(x: u16): u16 {
        2 * x
    }

    public inline fun inline_adder(a: u16): u16 {
        let b = a + 1;
        let c = double(a);
        b + c
    }
}



//# publish
module 0xCAFE::LambdaTest {
    use 0xCAFE::NestedCall;

    // This module tests lambda expressions and simple addition function

    public fun add_and_return_sum(a: u8, b: u8): u8 {
        let sum = a + b;
        let lambda_add: |u8, u8|u8 has copy+drop = |x: u8, y: u8| { x + y };
        let lambda_result = lambda_add(a, b);
        // The function returns the sum plus lambda_result, which should be sum + sum
        sum + lambda_result
    }

    public fun lambda_test_with_capture(x: u8): u8 {
        let captured = 5u8;
        let lambda: |u8|u8 has copy+drop = |y: u8| { captured + y + x };
        lambda(10u8)
    }

    public fun call_inline_function(): u16 {
        NestedCall::inline_adder(100u16)
    }
}




//# run 0xCAFE::LambdaTest::add_and_return_sum --args 4u8 6u8



//# run 0xCAFE::LambdaTest::lambda_test_with_capture --args 7u8



//# run 0xCAFE::LambdaTest::call_inline_function
