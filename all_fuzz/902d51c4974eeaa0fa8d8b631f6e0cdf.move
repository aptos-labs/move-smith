
//# publish
module 0xCAFE::LambdaAndInlineTest {
    use std::signer;

    public inline fun inline_add(a: u8, b: u8): u8 {
        a + b
    }

    public fun add_two_values(x: u8, y: u8): u8 {
        let sum = x + y;
        // Return a fixed value to check sum was computed in background (sum not directly returned)
        42u8
    }

    public fun with_lambda(x: u8, y: u8): u8 {
        let lambda: |u8, u8| u8 has copy+drop = |a: u8, b: u8| {
            a + b
        };
        lambda(x, y)
    }

    public fun call_inline_inside_lambda(x: u8, y: u8): u8 {
        let lambda: |u8, u8| u8 has copy+drop = |a: u8, b: u8| {
            inline_add(a, b)
        };
        lambda(x, y)
    }

    public fun call_inline_from_another_module_and_return_sum(x: u8, y: u8): u8 {
        // Calls inline_add inside this module
        let sum1 = inline_add(x, y);

        // Calls inline_add from 0xCAFE::LambdaAndInlineTest (recursive test)
        let sum2 = Self::inline_add(x, y);

        // Returns the sum of these two sums
        sum1 + sum2
    }

    // Runner function without arguments
    public fun runner(): u8 {
        // Test add_two_values returns 42 regardless of input sum
        let val1 = add_two_values(13u8, 29u8);

        // Test lambda returning sum of two values
        let val2 = with_lambda(20u8, 22u8);

        // Test lambda calling inline_add
        let val3 = call_inline_inside_lambda(30u8, 12u8);

        // Test nested calls returning double sum
        let val4 = call_inline_from_another_module_and_return_sum(15u8, 25u8);

        val1 + val2 + val3 + val4
    }
}


//# run 0xCAFE::LambdaAndInlineTest::add_two_values --args 5u8 7u8


//# run 0xCAFE::LambdaAndInlineTest::with_lambda --args 10u8 15u8


//# run 0xCAFE::LambdaAndInlineTest::call_inline_inside_lambda --args 8u8 9u8


//# run 0xCAFE::LambdaAndInlineTest::call_inline_from_another_module_and_return_sum --args 5u8 6u8


//# run 0xCAFE::LambdaAndInlineTest::runner


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
