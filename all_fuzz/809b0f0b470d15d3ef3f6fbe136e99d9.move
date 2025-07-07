
//# publish
module 0xCAFE::LambdaTest {
    // Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
    public fun add_then_return_specific(a: u8, b: u8): u8 {
        let sum = a + b;
        if (sum > 10) {
            42u8
        } else {
            24u8
        }
    }

    // Write a function using lambda (anonymous function) expressions that multiplies two u8 values.
    public fun multiply_lambda(a: u8, b: u8): u8 {
        let multiply: |u8, u8| u8 has copy+drop = |x: u8, y: u8| {
            x * y
        };
        multiply(a, b)
    }

    // Write a function accepting a lambda taking one u8 and returning u8 and apply it to 5.
    public fun apply_lambda_to_five(f: |u8| u8): u8 {
        f(5u8)
    }
}



//# publish
module 0xCAFE::InlineCallTest {
    use 0xCAFE::LambdaTest;

    // Test that calling an inline function from one module within another module correctly performs nested function calls and returns expected result.
    // We reuse the add_then_return_specific function
    public fun call_add_then_return_specific(a: u8, b: u8): u8 {
        LambdaTest::add_then_return_specific(a, b)
    }

    // Call multiply_lambda internally and add 1 to the result
    public fun call_multiply_lambda_plus_one(a: u8, b: u8): u8 {
        let product = LambdaTest::multiply_lambda(a, b);
        product + 1u8
    }

    // Call apply_lambda_to_five with a lambda that adds 3 to input
    public fun call_apply_lambda_to_five(): u8 {
        let lambda: |u8| u8 has copy+drop = |x: u8| {
            x + 3u8
        };
        LambdaTest::apply_lambda_to_five(lambda)
    }
}



//# run 0xCAFE::LambdaTest::add_then_return_specific --args 4u8 3u8


//# run 0xCAFE::LambdaTest::add_then_return_specific --args 6u8 5u8


//# run 0xCAFE::LambdaTest::multiply_lambda --args 4u8 3u8

// Removed the invalid direct complex lambda argument call to apply_lambda_to_five, as it's unsupported:
// 
// #run 0xCAFE::LambdaTest::apply_lambda_to_five --args |u8|u8: |a: u8| { a + 7u8 }

// Instead, test apply_lambda_to_five indirectly via InlineCallTest::call_apply_lambda_to_five


//# run 0xCAFE::InlineCallTest::call_add_then_return_specific --args 7u8 5u8


//# run 0xCAFE::InlineCallTest::call_multiply_lambda_plus_one --args 6u8 7u8


//# run 0xCAFE::InlineCallTest::call_apply_lambda_to_five
