
//# publish
module 0xCAFE::AddAndLambdaTest {
    use std::vector;

    // Simple function: add two 8-bit unsigned integers, then return fixed u8 value 42
    public fun add_then_fixed(x: u8, y: u8): u8 {
        let sum = x + y;
        let _ = sum; // just test addition
        42u8
    }

    // Function defining and invoking a lambda that adds two u8 numbers and returns sum
    public fun lambda_add(x: u8, y: u8): u8 {
        let add_lambda: |u8, u8| u8 has copy+drop = |a: u8, b: u8| {
            a + b
        };
        add_lambda(x, y)
    }

    // Inline function that adds u16 and returns u16
    public inline fun inline_add(a: u16, b: u16): u16 {
        a + b
    }

    // Function that calls the inline function within this module and returns the result
    public fun call_inline_internally(x: u16, y: u16): u16 {
        inline_add(x, y)
    }
}


//# publish
module 0xCAFE::NestedInlineCaller {
    use 0xCAFE::AddAndLambdaTest;

    // Calls the inline_add defined in 0xCAFE::AddAndLambdaTest and add 10 to the result
    public fun call_nested_inline(a: u16, b: u16): u16 {
        let base_sum = AddAndLambdaTest::inline_add(a, b);
        base_sum + 10u16
    }
}


//# run 0xCAFE::AddAndLambdaTest::add_then_fixed --args 10u8 20u8


//# run 0xCAFE::AddAndLambdaTest::lambda_add --args 12u8 30u8


//# run 0xCAFE::AddAndLambdaTest::call_inline_internally --args 100u16 200u16


//# run 0xCAFE::NestedInlineCaller::call_nested_inline --args 100u16 20u16


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
