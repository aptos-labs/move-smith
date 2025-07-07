
//# publish
module 0xCAFE::MathModule {
    // A simple add function that returns the sum of two u8 values plus a constant 10u8
    public fun add_with_constant(x: u8, y: u8): u8 {
        let sum = x + y;
        sum + 10u8
    }

    // Function with lambda that multiplies two u8 numbers and adds 5
    public fun lambda_example(a: u8, b: u8): u8 {
        let multiply_and_add: |u8, u8| u8 has copy+drop = |x: u8, y: u8| {
            (x * y) + 5u8
        };
        multiply_and_add(a, b)
    }

    // Inline function returning a tuple of u16 values
    public inline fun inline_add(a: u16, b: u16): (u16, u16) {
        (a + b, a * b)
    }
}


//# publish
module 0xCAFE::UseMath {
    // Use MathModule functions including inline and lambdas

    use 0xCAFE::MathModule;

    // Call add_with_constant to test addition and constant addition
    public fun test_add(x: u8, y: u8): u8 {
        MathModule::add_with_constant(x, y)
    }

    // Call lambda_example function from MathModule which returns multiplication plus 5
    public fun test_lambda(a: u8, b: u8): u8 {
        MathModule::lambda_example(a, b)
    }

    // Call inline_add inline function from MathModule and then return sum + product from tuple
    public fun test_inline(x: u16, y: u16): u16 {
        let (sum, product) = MathModule::inline_add(x, y);
        sum + product
    }
}


//# run 0xCAFE::MathModule::add_with_constant --args 3u8 4u8


//# run 0xCAFE::MathModule::lambda_example --args 5u8 6u8


//# run 0xCAFE::UseMath::test_add --args 7u8 8u8


//# run 0xCAFE::UseMath::test_lambda --args 2u8 3u8


//# run 0xCAFE::UseMath::test_inline --args 10u16 20u16


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
// 8c0b011f40cced98514ac42974aa1159: Use module aliases in attribute values to refer to modules indirectly.
