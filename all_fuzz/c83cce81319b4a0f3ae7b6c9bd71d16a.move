
//# publish
module 0xCAFE::AddAndLambda {
    // Test addition of two u8 values and return specific value
    public fun add_then_return(a: u8, b: u8): u8 {
        let sum = a + b;
        if (sum > 10) {
            42u8
        } else {
            0u8
        }
    }

    // Function containing a lambda that multiplies and adds two u8 numbers
    public fun lambda_example(x: u8, y: u8): u8 {
        let f: |u8, u8|u8 has copy+drop = |a: u8, b: u8| {
            a * b + 1u8
        };
        f(x, y)
    }
}


//# run 0xCAFE::AddAndLambda::add_then_return --args 4u8 9u8


//# run 0xCAFE::AddAndLambda::lambda_example --args 3u8 5u8


//# publish
module 0xCAFE::InlineNestedCall {
    use 0xCAFE::AddAndLambda;

    // Inline function returning a u8 result from nested call to AddAndLambda::add_then_return
    public inline fun nested_inline_call(a: u8, b: u8): u8 {
        AddAndLambda::add_then_return(a, b)
    }

    // Public function that calls the inline function
    public fun call_nested_inline(a: u8, b: u8): u8 {
        nested_inline_call(a, b)
    }
}


//# run 0xCAFE::InlineNestedCall::call_nested_inline --args 6u8 5u8 


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
