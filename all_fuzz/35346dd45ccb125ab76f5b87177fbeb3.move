
//# publish
module 0xCAFE::LambdaTest {
    // Removed unused 'use std::signer;'

    public fun add_two_and_return_value(a: u8, b: u8): u8 {
        let sum = a + b;
        42u8 + sum
    }

    public fun lambda_return_sum(a: u8, b: u8): u8 {
        let lambda: |u8, u8| u8 has copy+drop = |x: u8, y: u8| {
            x + y
        };
        lambda(a, b)
    }

    public fun call_lambda_and_add(a: u8, b: u8): u8 {
        let add_lambda = |x: u8, y: u8| { x + y };
        let result = add_lambda(a, b);
        result + 1u8
    }

    public fun runner(): u8 {
        let result1 = add_two_and_return_value(10u8, 5u8);
        let result2 = lambda_return_sum(10u8, 15u8);
        let result3 = call_lambda_and_add(1u8, 2u8);
        result1 + result2 + result3
    }
}



//# run 0xCAFE::LambdaTest::runner




//# publish
module 0xCAFE::CallerModule {
    use 0xCAFE::LambdaTest;

    // Changed 'inline fun' to a regular private function since 'inline' keyword is not supported here,
    // and moved the function outside of 'call_inline_function' to top-level function in module.
    fun inline_f2(x: u16): (u16, u16) {
        (x + 3u16, x + 4u16)
    }

    public fun call_inline_function(a: u16): u32 {
        let (v1, v2) = Self::inline_f2(a);
        (v1 as u32) + (v2 as u32)
    }

    public fun call_lambda_test_runner(): u8 {
        LambdaTest::runner()
    }
}



//# run 0xCAFE::CallerModule::call_inline_function --args 10u16



//# run 0xCAFE::CallerModule::call_lambda_test_runner
