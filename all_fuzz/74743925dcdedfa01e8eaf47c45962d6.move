
//# publish
module 0xCAFE::LambdaTest {
    // Module to test lambdas and u8 addition logic
    public fun add_and_return_expected(a: u8, b: u8): u8 {
        // Return a + b + 10 for testing addition correctness
        let sum = a + b;
        sum + 10
    }

    public fun use_lambda(a: u8, b: u8): u8 {
        let adder: |u8, u8| u8 has copy+drop = |x: u8, y: u8| {
            x + y
        };
        adder(a, b)
    }

    public inline fun inline_adder(a: u8, b: u8): u8 {
        a + b
    }
}


//# publish
module 0xCAFE::CallerModule {
    use 0xCAFE::LambdaTest;

    public fun call_inline_and_compute(a: u8, b: u8): u8 {
        let sum = LambdaTest::inline_adder(a, b);
        // Add 20 to sum to prove nested call works
        sum + 20
    }
}


//# run 0xCAFE::LambdaTest::add_and_return_expected --args 5u8 7u8


//# run 0xCAFE::LambdaTest::use_lambda --args 8u8 2u8


//# run 0xCAFE::CallerModule::call_inline_and_compute --args 3u8 4u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
