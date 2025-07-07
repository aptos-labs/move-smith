
//# publish
module 0xCAFE::MathOperations {
    public fun add_and_return(a: u8, b: u8): u8 {
        let sum = a + b;
        // Return the sum plus 10
        sum + 10
    }

    public fun lambda_example(x: u8, y: u8): u8 {
        let add = |a: u8, b: u8| { a + b };
        add(x, y)
    }

    public inline fun inline_add(a: u8, b: u8): u8 {
        a + b
    }
}


//# run 0xCAFE::MathOperations::add_and_return --args 5u8 7u8


//# run 0xCAFE::MathOperations::lambda_example --args 8u8 2u8


//# publish
module 0xCAFE::NestedCalls {
    use 0xCAFE::MathOperations;

    public fun call_inline_add(a: u8, b: u8): u8 {
        let result = MathOperations::inline_add(a, b);
        // Add 5 to the result
        result + 5
    }
}


//# run 0xCAFE::NestedCalls::call_inline_add --args 3u8 4u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
