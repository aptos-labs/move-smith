
//# publish
module 0xCAFE::TestLambdaAndInline {
    // Note: Removed `use 0xCAFE::MyModule` because it does not exist and is disallowed.

    // Function to add two u8 and return if the sum is above threshold or not
    public fun add_and_check(a: u8, b: u8): u8 {
        let sum = a + b;
        if (sum > 10) {
            1u8
        } else {
            0u8
        }
    }

    public fun test_lambda(a: u8, b: u8): u8 {
        let lambda: |u8, u8| u8 has copy + drop = |x: u8, y: u8| {
            x + y
        };
        lambda(a, b)
    }

    // Since MyModule::f2 is not available, implement a dummy inline function here directly.
    public fun f2(x: u16): (u16, u16) {
        // Return (x, x), dummy implementation to replace MyModule::f2
        (x, x)
    }

    public fun call_inline_and_sum(a: u16, b: u16): u16 {
        let (x1, _) = Self::f2(a);
        let (x2, _) = Self::f2(b);
        x1 + x2
    }

    public fun use_constant_plus(a: u64): u64 {
        let const_plus: u64 = 123456789u64;
        a + const_plus
    }

    public fun example_nested_lambda(x: u8): u8 {
        let lambda_outer: |u8| u8 has copy + drop = |y: u8| {
            let lambda_inner: |u8| u8 has copy + drop = |z: u8| {
                z + 1
            };
            lambda_inner(y)
        };
        lambda_outer(x)
    }

    // Dummy function to get current token span.
    // In practical Move this isn't possible, but we simulate a call that would use span.
    public fun get_token_span() {
        // No actual implementation, just to trigger compiler span related code.
        // Usually this might be an intrinsic or compiler feature.
    }
}



//# run 0xCAFE::TestLambdaAndInline::add_and_check --args 5u8 7u8



//# run 0xCAFE::TestLambdaAndInline::test_lambda --args 6u8 4u8



//# run 0xCAFE::TestLambdaAndInline::call_inline_and_sum --args 5u16 10u16



//# run 0xCAFE::TestLambdaAndInline::use_constant_plus --args 100u64



//# run 0xCAFE::TestLambdaAndInline::example_nested_lambda --args 41u8



//# run 0xCAFE::TestLambdaAndInline::get_token_span
