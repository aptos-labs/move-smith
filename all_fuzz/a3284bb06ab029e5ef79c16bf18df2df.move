
//# publish
module 0xCAFE::LambdaTest {
    use std::signer;

    // A simple function that adds two u8 values and returns the result plus a fixed offset
    public fun add_with_offset(a: u8, b: u8): u8 {
        let sum = a + b;
        sum + 10u8
    }

    // Function that defines a lambda to multiply two u8 numbers and returns the result
    public fun multiply_lambda(a: u8, b: u8): u8 {
        let multiply: |u8, u8|u8 has copy+drop = |x: u8, y: u8| {
            x * y
        };
        multiply(a, b)
    }

    // Function that uses an inline function internally
    public inline fun inline_add(x: u8, y: u8): u8 {
        x + y
    }

    // Calls the inline function add_with_offset in the same module
    public fun call_inline_add_in_module(a: u8, b: u8): u8 {
        let interim = inline_add(a, b);
        interim + 5u8
    }

    // A runner function for testing: calls add_with_offset and multiply_lambda and call_inline_add_in_module
    public fun runner(): u8 {
        let sum = add_with_offset(3u8, 4u8);
        let product = multiply_lambda(2u8, 5u8);
        let nested = call_inline_add_in_module(7u8, 8u8);
        sum + product + nested
    }
}


//# run 0xCAFE::LambdaTest::add_with_offset --args 10u8 20u8


//# run 0xCAFE::LambdaTest::multiply_lambda --args 6u8 7u8


//# run 0xCAFE::LambdaTest::call_inline_add_in_module --args 8u8 9u8


//# run 0xCAFE::LambdaTest::runner


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
