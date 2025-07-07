
//# publish
module 0xCAFE::MathUtils {
    /// Simple function adding two u8 values and returning the sum plus one
    public fun add_and_increment(a: u8, b: u8): u8 {
        let sum = a + b;
        sum + 1
    }

    /// A function that defines and uses a lambda to add two u8 values and multiply the result by 2
    public fun double_sum_with_lambda(a: u8, b: u8): u8 {
        let add: |u8, u8| u8 has copy+drop = |x: u8, y: u8| {
            x + y
        };
        let result = add(a, b);
        result * 2
    }

    /// Inline function returning a tuple of two values
    public inline fun inline_operations(a: u16): (u16, u16) {
        (a * 2, a + 3)
    }

    /// Function to call inline_operations to test inline call correctness
    public fun test_inline_call(x: u16): u16 {
        let (x2, x3) = inline_operations(x);
        x2 + x3
    }

    /// A constant with specified kind (const u32) without deprecation
    const MAGIC_NUMBER: u32 = 0xBEEF;

    /// Uses access and inlining checks through calling an internal function before returning a value
    fun internal_multiply(a: u8, b: u8): u8 {
        a * b
    }

    public fun access_and_inline_test(x: u8, y: u8): u8 {
        let product = internal_multiply(x, y);
        product + 5
    }
}


//# run 0xCAFE::MathUtils::add_and_increment --args 10u8 20u8


//# run 0xCAFE::MathUtils::double_sum_with_lambda --args 6u8 4u8


//# run 0xCAFE::MathUtils::test_inline_call --args 5u16


//# run 0xCAFE::MathUtils::access_and_inline_test --args 3u8 7u8



//# publish
module 0xCAFE::CallerModule {
    use 0xCAFE::MathUtils;

    /// Calls MathUtils' inline function nested calls through a wrapper
    public fun call_mathutils_inline(x: u16): u16 {
        MathUtils::test_inline_call(x)
    }

    /// Calls MathUtils' lambda function usage indirectly
    public fun call_lambda(a: u8, b: u8): u8 {
        MathUtils::double_sum_with_lambda(a, b)
    }
}


//# run 0xCAFE::CallerModule::call_mathutils_inline --args 7u16


//# run 0xCAFE::CallerModule::call_lambda --args 8u8 2u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
// afeb4b6ebb07bba12c83e2588f9fd362: Define module members with specified kinds without deprecation info
// ed5d77428056c6b1791d052d844e01f1: Perform access and use checks before inlining functions.
