
//# publish
module 0xCAFE::LambdaTest {
    // Test lambda expressions and function computations

    public fun add_u8_values(a: u8, b: u8): u8 {
        // add two u8 values and add 5 before returning
        let sum = a + b;
        sum + 5
    }

    public fun with_lambda(a: u8, b: u8): u8 {
        let adder: |u8, u8|u8 has copy+drop = |x: u8, y: u8| { x + y };
        let result = adder(a, b);
        result + 10
    }
}


//# run 0xCAFE::LambdaTest::add_u8_values --args 10u8 20u8


//# run 0xCAFE::LambdaTest::with_lambda --args 3u8 4u8


//# publish
module 0xCAFE::CallerModule {
    use 0xCAFE::LambdaTest;

    public fun call_inline_add(a: u8, b: u8): u8 {
        let partial_result = LambdaTest::add_u8_values(a, b);
        partial_result + 100
    }
}


//# run 0xCAFE::CallerModule::call_inline_add --args 1u8 2u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
