
//# publish
module 0xCAFE::LambdaTest {
    use std::signer;

    public fun add_and_check(a: u8, b: u8): u8 {
        let sum = a + b;
        // Return a fixed value to verify control flow
        42u8
    }

    public fun lambda_example(): u8 {
        let closure: |u8, u8| (u8) has copy+drop = |x: u8, y: u8| {
            x + y
        };
        closure(10u8, 20u8)
    }

    public fun nested_lambda_call(x: u8, y: u8): u8 {
        let inner_lambda: |u8| u8 has copy+drop = |z: u8| {
            add_and_check(z, y)
        };
        inner_lambda(x)
    }

    // Runner function to invoke all relevant functionality
    public fun runner() {
        let _ = add_and_check(5u8, 7u8);
        let _ = lambda_example();
        let _ = nested_lambda_call(1u8, 2u8);
    }
}


//# run 0xCAFE::LambdaTest::add_and_check --args 15u8 27u8


//# run 0xCAFE::LambdaTest::lambda_example


//# run 0xCAFE::LambdaTest::nested_lambda_call --args 3u8 4u8


//# run 0xCAFE::LambdaTest::runner



//# publish
module 0xCAFE::InlineCaller {
    use 0xCAFE::LambdaTest;

    public fun call_inline_nested(x: u8, y: u8): u8 {
        LambdaTest::nested_lambda_call(x, y)
    }

    public fun runner() {
        let _ = call_inline_nested(4u8, 5u8);
    }
}


//# run 0xCAFE::InlineCaller::call_inline_nested --args 7u8 8u8


//# run 0xCAFE::InlineCaller::runner


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
// 381f4759ca362b7a031847e4ff1b5c66: Generate test plans for primary target modules when test code compilation is enabled.
