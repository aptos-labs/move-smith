
//# publish
module 0xCAFE::LambdaTest {
    public fun add_u8_with_condition(a: u8, b: u8): u8 {
        let sum = a + b;
        if (sum > 10) {
            10
        } else {
            sum
        }
        // Return the last expression value explicitly (semicolon removed)
    }

    public fun run_lambda_example(x: u8): u8 {
        let lambda: |u8| u8 has copy+drop = |n: u8| {
            n * 2
        };
        lambda(x)
    }

    public fun run_double_lambda(x: u8, y: u8): (u8, u8) {
        let lambda1: |u8| u8 has copy+drop = |n: u8| {
            n + 1
        };
        let lambda2: |u8| u8 has copy+drop = |n: u8| {
            n * 3
        };
        let r1 = lambda1(x);
        let r2 = lambda2(y);
        (r1, r2)
    }
}



//# publish
module 0xCAFE::InlineCaller {
    use 0xCAFE::LambdaTest;

    public inline fun double_increment(x: u8): u8 {
        // Calls an inline function from LambdaTest module
        let intermediate = LambdaTest::run_lambda_example(x);
        intermediate + 1
    }

    public fun nested_inline_call(x: u8): u8 {
        let result = double_increment(x);
        result * 2
    }
}



//# run 0xCAFE::LambdaTest::add_u8_with_condition --args 3u8 4u8



//# run 0xCAFE::LambdaTest::add_u8_with_condition --args 7u8 8u8



//# run 0xCAFE::LambdaTest::run_lambda_example --args 5u8



//# run 0xCAFE::LambdaTest::run_double_lambda --args 2u8 3u8



//# run 0xCAFE::InlineCaller::nested_inline_call --args 4u8
