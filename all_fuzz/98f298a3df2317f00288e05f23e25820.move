
//# publish
module 0xCAFE::LambdaAndInlineTest {
    // Test 1: Function computes addition u8 + u8 then returns a constant (42u8)
    public fun add_and_return_constant(a: u8, b: u8): u8 {
        let sum = a + b;
        let _ = sum;
        42u8
    }

    // Test 2: Functions containing lambdas
    public fun lambda_sum_and_product(a: u8, b: u8): (u8, u8) {
        let lambda: |u8, u8| (u8, u8) has copy+drop = |x: u8, y: u8| {
            (x + y, x * y)
        };
        lambda(a, b)
    }

    public fun lambda_capture_example(a: u8): u8 {
        let base = 7u8;
        let lambda: |u8| u8 has copy+drop = |x: u8| {
            base + x
        };
        lambda(a)
    }

    // Test 3 & 4: Calling inline function and passing lambda
    public inline fun inline_add_one(x: u16): u16 {
        x + 1
    }

    public fun call_inline_and_lambda(x: u16, y: u8): u16 {
        let incremented = Self::inline_add_one(x);
        let lambda: |u8| u16 has copy+drop = |param: u8| {
            Self::inline_add_one(param as u16)
        };
        let res_from_lambda = lambda(y);
        incremented + res_from_lambda
    }
}



//# publish
module 0xCAFE::InlineCaller {
    use 0xCAFE::LambdaAndInlineTest;

    // Call the inline_add_one function from another module
    public fun call_inline_add_one(x: u16): u16 {
        LambdaAndInlineTest::inline_add_one(x)
    }

    // Call the call_inline_and_lambda function from another module
    public fun call_inline_and_lambda(x: u16, y: u8): u16 {
        LambdaAndInlineTest::call_inline_and_lambda(x, y)
    }
}



//# run 0xCAFE::LambdaAndInlineTest::add_and_return_constant --args 10u8 32u8



//# run 0xCAFE::LambdaAndInlineTest::lambda_sum_and_product --args 5u8 4u8



//# run 0xCAFE::LambdaAndInlineTest::lambda_capture_example --args 8u8



//# run 0xCAFE::LambdaAndInlineTest::call_inline_and_lambda --args 10u16 5u8



//# run 0xCAFE::InlineCaller::call_inline_add_one --args 20u16



//# run 0xCAFE::InlineCaller::call_inline_and_lambda --args 15u16 6u8
