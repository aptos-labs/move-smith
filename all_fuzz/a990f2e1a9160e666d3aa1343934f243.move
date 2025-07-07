
//# publish
module 0xCAFE::AdditionLambdaInline {
    use std::signer;

    // Simple function that adds two u8 and returns x + y + 1
    public fun add_then_increment(x: u8, y: u8): u8 {
        let sum = x + y;
        sum + 1
    }

    // Function that uses a lambda to multiply and add
    public fun lambda_multiply_add(x: u8, y: u8): u8 {
        let multiply: |u8, u8| u8 has copy+drop = |a: u8, b: u8| {
            a * b
        };
        let add: |u8, u8| u8 has copy+drop = |a: u8, b: u8| {
            a + b
        };
        let prod = multiply(x, y);
        add(prod, 3u8)
    }

    // Inline function that returns a tuple of (u8, u8)
    public inline fun inline_tuple(a: u8): (u8, u8) {
        (a, a + 1)
    }
}


//# run 0xCAFE::AdditionLambdaInline::add_then_increment --args 5u8 6u8


//# run 0xCAFE::AdditionLambdaInline::lambda_multiply_add --args 4u8 7u8


//# publish
module 0xCAFE::NestedInline {
    use 0xCAFE::AdditionLambdaInline;

    // Function to call the inline function in AdditionLambdaInline and return sum of tuple elements
    public fun call_inline_and_sum(x: u8): u8 {
        let (a, b) = AdditionLambdaInline::inline_tuple(x);
        a + b
    }

    // Runner to call call_inline_and_sum for test
    public fun runner() {
        let _ = call_inline_and_sum(10u8);
    }
}


//# run 0xCAFE::NestedInline::call_inline_and_sum --args 100u8


//# run 0xCAFE::NestedInline::runner


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
