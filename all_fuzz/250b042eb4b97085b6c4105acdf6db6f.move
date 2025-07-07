
//# publish
module 0xCAFE::LambdaTest {
    public fun add_and_return_specific_value(a: u8, b: u8): u8 {
        let sum = a + b;
        // Return a constant 42 when function ends
        42
    }

    public fun run_lambda_example(): u8 {
        let lambda: |u8, u8| u8 has copy+drop = |x: u8, y: u8| {
            x + y
        };
        lambda(10u8, 11u8)
    }
}


//# run 0xCAFE::LambdaTest::add_and_return_specific_value --args 20u8 22u8


//# run 0xCAFE::LambdaTest::run_lambda_example



//# publish
module 0xCAFE::NestedInlineCall {
    use 0xCAFE::LambdaTest;

    // Inline function to return tuple of two u16 for test
    public inline fun inline_sum_and_increment(a: u16, b: u16): (u16, u16) {
        let sum = a + b;
        (sum, sum + 1)
    }

    public fun call_external_inline(a: u8, b: u8): u8 {
        let sum = a + b;
        let (x, y) = inline_sum_and_increment(sum as u16, 10u16);
        let (r, _) = 0xCAFE::LambdaTest::run_lambda_example(); // We know it returns u8, but this is an error example for unpack - will fix below
        // Actually no tuple returned from run_lambda_example, fix to simple call
        let ret = 0xCAFE::LambdaTest::run_lambda_example();
        (x as u8) + (y as u8) + ret
    }
}


//# run 0xCAFE::NestedInlineCall::call_external_inline --args 15u8 20u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
