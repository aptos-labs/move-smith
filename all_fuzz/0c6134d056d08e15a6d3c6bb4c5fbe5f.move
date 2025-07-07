
//# publish
module 0xCAFE::LambdaAndInlineTest {
    use std::vector;

    public inline fun inline_add(a: u8, b: u8): u8 {
        a + b
    }

    public fun caller_of_inline_add(a: u8, b: u8): u8 {
        inline_add(a, b)
    }

    public fun lambda_adder(x: u8, y: u8): u8 {
        let add: |u8, u8| u8 has copy+drop = |a: u8, b: u8| a + b;
        add(x, y)
    }

    public fun lambda_with_capture(x: u8): u8 {
        let base = 5u8;
        let add_base: |u8| u8 has copy+drop = |v: u8| {
            base + v
        };
        add_base(x)
    }

    public fun runner(): u8 {
        let s1 = lambda_adder(20u8, 22u8);
        let s2 = lambda_with_capture(3u8);
        s1 + s2
    }
}


//# run 0xCAFE::LambdaAndInlineTest::lambda_adder --args 10u8 15u8


//# run 0xCAFE::LambdaAndInlineTest::lambda_with_capture --args 7u8


//# run 0xCAFE::LambdaAndInlineTest::caller_of_inline_add --args 12u8 34u8


//# run 0xCAFE::LambdaAndInlineTest::runner


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
