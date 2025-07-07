
//# publish
module 0xCAFE::LambdaTest {
    public fun add_and_return_sum(a: u8, b: u8): u8 {
        let sum = a + b;
        let result = if (sum > 10) { 10u8 } else { sum };
        result
    }

    public fun use_lambda(x: u8, y: u8): u8 {
        let adder: |u8, u8|u8 = |p: u8, q: u8| {
            p + q
        };
        adder(x, y)
    }
}


//# publish
module 0xCAFE::InlineCaller {
    use 0xCAFE::LambdaTest;

    public inline fun inline_add_three_times(x: u8, y: u8): u8 {
        let (a) = LambdaTest::add_and_return_sum(x, y);
        let (b) = LambdaTest::add_and_return_sum(a, y);
        let (c) = LambdaTest::add_and_return_sum(b, y);
        c
    }

    public fun runner(): u8 {
        inline_add_three_times(2u8, 3u8)
    }
}


//# run 0xCAFE::LambdaTest::add_and_return_sum --args 6u8 4u8


//# run 0xCAFE::LambdaTest::use_lambda --args 2u8 5u8


//# run 0xCAFE::InlineCaller::runner


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
