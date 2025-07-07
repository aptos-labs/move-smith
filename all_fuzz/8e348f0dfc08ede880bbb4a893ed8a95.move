
//# publish
module 0xCAFE::LambdaTest {
    public fun add_and_return_expected(a: u8, b: u8, expected: u8): u8 {
        let sum = a + b;

        let lambda: |u8| u8 has copy+drop = |x: u8| {
            x + 1
        };

        // Use lambda to transform sum to test lambda usage
        let result = lambda(sum);
        // If the result equals expected, return expected, else return result
        if (result == expected) {
            expected
        } else {
            result
        }
    }

    public inline fun inline_add(a: u8, b: u8): u8 {
        a + b
    }
}



//# publish
module 0xCAFE::NestedCalls {
    use 0xCAFE::LambdaTest;

    public fun call_inline_add(a: u8, b: u8): u8 {
        LambdaTest::inline_add(a, b)
    }

    public fun call_lambda_test_add_and_return_expected(a: u8, b: u8, expected: u8): u8 {
        LambdaTest::add_and_return_expected(a, b, expected)
    }
}



//# run 0xCAFE::LambdaTest::add_and_return_expected --args 10u8 20u8 31u8



//# run 0xCAFE::LambdaTest::add_and_return_expected --args 5u8 5u8 11u8



//# run 0xCAFE::NestedCalls::call_inline_add --args 7u8 8u8



//# run 0xCAFE::NestedCalls::call_lambda_test_add_and_return_expected --args 15u8 10u8 26u8
