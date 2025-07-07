
//# publish
module 0xCAFE::MathWithLambdas {
    // Basic addition function to test addition of two u8 values and then return a fixed u8.
    public fun add_then_return_const(a: u8, b: u8): u8 {
        let sum = a + b;
        // Return a fixed value, ignoring sum result, to test function control flow.
        42u8
    }

    // Function containing a lambda that adds two u8 values and returns the result.
    public fun add_with_lambda(a: u8, b: u8): u8 {
        let adder: |u8, u8|u8 has copy + drop = |x: u8, y: u8| {
            x + y
        };
        adder(a, b)
    }

    // Function containing a lambda that captures an environment variable and doubles a u8 value.
    public fun double_with_captured_lambda(x: u8): u8 {
        let factor = 2u8;
        let doubler: |u8| u8 has copy + drop = |val: u8| {
            val * factor
        };
        doubler(x)
    }
}


//# publish
module 0xCAFE::NestedInlineCall {
    use 0xCAFE::MathWithLambdas;

    // Inline function returning tuple of u8
    public inline fun inline_tuple(a: u8): (u8, u8) {
        (a + 1, a + 2)
    }

    // Function calling an inline function (inline_tuple) and nested call to a lambda function from MathWithLambdas
    public fun call_inline_and_lambda(a: u8, b: u8): (u8, u8, u8) {
        let (x, y) = inline_tuple(a);
        let sum = MathWithLambdas::add_with_lambda(x, b);
        // Return tuple including results from inline and lambda call
        (x, y, sum)
    }
}


//# run 0xCAFE::MathWithLambdas::add_then_return_const --args 10u8 15u8


//# run 0xCAFE::MathWithLambdas::add_with_lambda --args 7u8 8u8


//# run 0xCAFE::MathWithLambdas::double_with_captured_lambda --args 21u8


//# run 0xCAFE::NestedInlineCall::call_inline_and_lambda --args 3u8 5u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
