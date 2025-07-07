
//# publish
module 0xCAFE::TestAddLambdaInline {
    use std::vector;

    // A simple addition function, returns sum plus 10u8
    public fun add_with_offset(a: u8, b: u8): u8 {
        let sum = a + b;
        sum + 10u8
    }

    // A function holding a lambda that multiplies two u8s and adds an offset 5u8
    public fun multiply_and_add(a: u8, b: u8): u8 {
        let lambda: |u8, u8| u8 has copy+drop = |x: u8, y: u8| {
            (x * y) + 5u8
        };
        lambda(a, b)
    }

    // Inline function that returns a tuple (a+3, b+7)
    public inline fun increment_tuple(a: u8, b: u8): (u8, u8) {
        (a + 3, b + 7)
    }

    // Nested call that calls increment_tuple and uses the results to add to a third value
    public fun nested_calls(a: u8, b: u8, c: u8): u8 {
        let (x, y) = increment_tuple(a, b);
        add_with_offset(x, y) + c
    }
}


//# run 0xCAFE::TestAddLambdaInline::add_with_offset --args 5u8 7u8


//# run 0xCAFE::TestAddLambdaInline::multiply_and_add --args 3u8 4u8


//# run 0xCAFE::TestAddLambdaInline::nested_calls --args 1u8 2u8 3u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
