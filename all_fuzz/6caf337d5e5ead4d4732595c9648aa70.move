
//# publish
module 0xCAFE::AddAndLambda {
    /// Add two u8 values and return sum plus a constant offset 10u8
    public fun add_and_offset(a: u8, b: u8): u8 {
        let sum = a + b;
        sum + 10u8
    }

    /// Function with lambda to multiply and add two u8 values
    public fun lambda_mul_add(a: u8, b: u8): u8 {
        let multiplier = |x: u8, y: u8| x * y;
        let adder = |x: u8, y: u8| x + y;

        let prod = multiplier(a, b);
        let sum = adder(a, b);

        prod + sum
    }
}


//# run 0xCAFE::AddAndLambda::add_and_offset --args 5u8 7u8


//# run 0xCAFE::AddAndLambda::lambda_mul_add --args 3u8 4u8


//# publish
module 0xCAFE::NestedCalls {
    use 0xCAFE::AddAndLambda;

    /// Inline function returning tuple of two u8 values, adding offsets
    public inline fun inline_tuple(a: u8): (u8, u8) {
        (a + 1u8, a + 2u8)
    }

    /// Call AddAndLambda::add_and_offset and AddAndLambda::lambda_mul_add inside nested calls
    public fun nested_call_combined(a: u8, b: u8): u8 {
        let (x, y) = inline_tuple(a);
        let sum_offset = AddAndLambda::add_and_offset(x, y);
        let lambda_result = AddAndLambda::lambda_mul_add(sum_offset, b);
        lambda_result
    }
}


//# run 0xCAFE::NestedCalls::nested_call_combined --args 2u8 5u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
