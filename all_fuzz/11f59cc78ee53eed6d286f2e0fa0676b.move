
//# publish
module 0xCAFE::LambdaAndInlineTest {

    /// Inline function f1: takes a u8 and a bool, returns u8
    public fun f1(x: u8, flag: bool): u8 {
        if (flag) {
            x + 1
        } else {
            x
        }
    }

    /// Inline function f2: takes a u16, returns (u8, u8)
    public fun f2(x: u16): (u8, u8) {
        let a = (x % 256) as u8;
        let b = ((x / 256) % 256) as u8;
        (a, b)
    }

    public fun add_and_return_sum(a: u8, b: u8): u8 {
        let sum = a + b;

        let result = (if (sum > 10) {
            sum
        } else {
            10u8
        });

        result
    }

    public fun run_lambda_example(x: u8): u8 {
        let lambda: |u8|u8 has copy+drop = |a: u8| {
            let b = a * 2;
            b + 3
        };
        lambda(x)
    }

    public fun call_inline_and_lambda(x: u16, y: u8): u8 {
        // call inline function f2 from this module
        let (a, b) = f2(x);

        // call lambda that adds two u8 numbers
        let lambda: |u8, u8| u8 has copy+drop = |p: u8, q: u8| {
            p + q
        };
        let res_u8 = lambda(a, y);

        // use f1 from this module on the result of lambda to get a u8 output
        let final_result = f1(res_u8, true);

        final_result
    }

    public fun call_inline_no_args(): (u16, u16) {
        (5u16, 5u16)
    }
}




//# run 0xCAFE::LambdaAndInlineTest::add_and_return_sum --args 4u8 7u8




//# run 0xCAFE::LambdaAndInlineTest::run_lambda_example --args 4u8




//# run 0xCAFE::LambdaAndInlineTest::call_inline_and_lambda --args 10u16 5u8




//# run 0xCAFE::LambdaAndInlineTest::call_inline_no_args
