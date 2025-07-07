
//# publish
module 0xCAFE::TestFeatures {
    use std::signer;

    /// Adds two u8 numbers and returns their sum plus a fixed offset 10u8.
    public fun add_and_offset(x: u8, y: u8): u8 {
        let sum = x + y;
        sum + 10
    }

    /// Function containing a lambda (anonymous function) that multiplies two numbers.
    public fun lambda_multiply(a: u8, b: u8): u8 {
        let mul_lambda: |u8, u8| u8 has copy+drop = |x: u8, y: u8| {
            x * y
        };
        mul_lambda(a, b)
    }

    /// Calls the inline function 'f2' from 0xCAFE::MyModule and returns first element doubled.
    public fun call_inline_and_double(a: u16): u16 {
        let (first, _second) = 0xCAFE::MyModule::f2(a);
        first * 2
    }

    /// Aborts with code 0x1234 if input is zero.
    public fun abort_if_zero(x: u8) acquires signer {
        if (x == 0) {
            abort 0x1234;
        };
    }

    /// Abort function with custom code 42 for testing.
    public fun abort_with_42() {
        abort 42;
    }

    public fun runner() {
        let _ = add_and_offset(5u8, 6u8);
        let _ = lambda_multiply(6u8, 7u8);
        let _ = call_inline_and_double(10u16);

        // Test abort_if_zero, will abort if zero but called with 1u8 here to avoid abort
        abort_if_zero(1u8);

        // We don't call abort_with_42 here to prevent abort in runner.
    }
}


//# run 0xCAFE::TestFeatures::add_and_offset --args 20u8 22u8


//# run 0xCAFE::TestFeatures::lambda_multiply --args 4u8 5u8


//# run 0xCAFE::TestFeatures::call_inline_and_double --args 15u16


//# run 0xCAFE::TestFeatures::abort_if_zero --args 1u8


//# run 0xCAFE::TestFeatures::runner


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
// 6dd19867681b908e60886e507644705a: Declare 'aborts_with' conditions for custom abort codes.
