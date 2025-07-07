
//# publish
module 0xCAFE::LambdaTest {
    use std::signer;

    public fun add_and_return_sum(a: u8, b: u8): u8 {
        let sum = a + b;
        sum + 10u8
    }

    public fun lambda_adder(x: u8, y: u8): u8 {
        let adder: |u8, u8| u8 has copy+drop = |a: u8, b: u8| {
            a + b
        };
        adder(x, y)
    }

    public fun lambda_with_capture(z: u8): u8 {
        let capture = 5u8;
        let add_capture: |u8| u8 has copy+drop = |x: u8| {
            x + capture
        };
        add_capture(z)
    }
}


//# run 0xCAFE::LambdaTest::add_and_return_sum --args 7u8 8u8


//# run 0xCAFE::LambdaTest::lambda_adder --args 4u8 6u8


//# run 0xCAFE::LambdaTest::lambda_with_capture --args 3u8



//# publish
module 0xCAFE::InlineCaller {
    use 0xCAFE::LambdaTest;

    public inline fun call_add_and_return_sum(a: u8, b: u8): u8 {
        LambdaTest::add_and_return_sum(a, b) + 1u8
    }

    public fun runner(): u8 {
        call_add_and_return_sum(10u8, 20u8)
    }
}


//# run 0xCAFE::InlineCaller::runner


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
