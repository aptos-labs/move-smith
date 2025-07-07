
//# publish
module 0xCAFE::LambdaTest {
    // Test function for addition of two u8 values and returns a fixed value
    public fun add_then_return_fixed(a: u8, b: u8): u8 {
        let sum = a + b;
        // Just returning 42 regardless of sum to test correct addition before return
        42u8
    }

    // Test with lambda to add and multiply inputs and return sum
    public fun lambda_add_mult(a: u8, b: u8): u8 {
        let add_mult_lambda: |u8, u8|u8 has copy+drop = |x: u8, y: u8| {
            let sum = x + y;
            let product = x * y;
            sum
        };
        add_mult_lambda(a, b)
    }

    // Runner function for lambda_add_mult to call without args via hardcoded values
    public fun runner() {
        let _ = lambda_add_mult(3u8, 5u8);
    }
}


//# run 0xCAFE::LambdaTest::add_then_return_fixed --args 10u8 15u8


//# run 0xCAFE::LambdaTest::lambda_add_mult --args 7u8 8u8


//# run 0xCAFE::LambdaTest::runner



//# publish
module 0xCAFE::InlineCallTest {
    use 0xCAFE::LambdaTest;

    // Public inline function to add two u8
    public inline fun add_inline(a: u8, b: u8): u8 {
        a + b
    }

    // Calls LambdaTest's lambda_add_mult and the inline add_inline and returns their sum
    public fun nested_calls(a: u8, b: u8): u8 {
        let from_lambda = LambdaTest::lambda_add_mult(a, b);
        let from_inline = add_inline(a, b);
        from_lambda + from_inline
    }
}


//# run 0xCAFE::InlineCallTest::nested_calls --args 4u8 6u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
