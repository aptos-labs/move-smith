
//# publish
module 0xCAFE::MathTest {
    // A simple function that adds two u8 values and returns the sum plus one
    public fun add_and_increment(a: u8, b: u8): u8 {
        let sum = a + b;
        sum + 1
    }

    // A function that defines a lambda to multiply two u8 and adds 1 to the result
    public fun lambda_multiply_plus_one(a: u8, b: u8): u8 {
        let multiply = |x: u8, y: u8| { x * y };
        let result = multiply(a, b);
        result + 1
    }

    // A runner function to test lambda without arguments explicitly
    public fun runner_lambda(): u8 {
        lambda_multiply_plus_one(3u8, 4u8)
    }
}


//# publish
module 0xCAFE::NestedCallTest {
    use 0xCAFE::MathTest;

    // A function that calls an inline function from MathTest, performs nested call and modifies the result
    public fun call_inline_and_add(a: u8, b: u8): u8 {
        let base = MathTest::add_and_increment(a, b);
        // Nested inline call: adding the result of runner_lambda from MathTest
        let nested = MathTest::runner_lambda();
        base + nested
    }
}


//# run 0xCAFE::MathTest::add_and_increment --args 5u8 10u8


//# run 0xCAFE::MathTest::lambda_multiply_plus_one --args 2u8 3u8


//# run 0xCAFE::MathTest::runner_lambda


//# run 0xCAFE::NestedCallTest::call_inline_and_add --args 1u8 2u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
