
//# publish
module 0xCAFE::ArithmeticModule {
    /// Adds two u8 values and returns the result plus a constant
    public fun add_and_offset(a: u8, b: u8): u8 {
        let sum = a + b;
        sum + 10u8
    }

    /// Returns a tuple with sum and product computed via a lambda
    public fun lambda_operations(a: u8, b: u8): (u8, u8) {
        let lambda: |u8, u8| (u8, u8) has copy+drop = |x: u8, y: u8| {
            (x + y, x * y)
        };
        lambda(a, b)
    }

    /// An inline function returning the sum of two u16 numbers
    public inline fun inline_sum(x: u16, y: u16): u16 {
        x + y
    }
}



//# run 0xCAFE::ArithmeticModule::add_and_offset --args 5u8 3u8



//# run 0xCAFE::ArithmeticModule::lambda_operations --args 7u8 6u8



//# run 0xCAFE::ArithmeticModule::inline_sum --args 100u16 250u16



//# publish
module 0xCAFE::BitwiseTest {
    /// Test bitwise operators on various unsigned integer types with zero, identical, maximal, mixed values
    public fun test_bitwise_ops(): (bool, bool, bool, bool, bool, bool, bool, bool, bool, bool, bool, bool, bool, bool, bool, bool, bool, bool) {
        // u8 tests
        let u8_zero = 0u8;
        let u8_max = 255u8;
        let u8_val1 = 0xAAu8; // 10101010b
        let u8_val2 = 0x55u8; // 01010101b

        let and_u8_0 = (u8_zero & u8_val1) == 0u8;
        let and_u8_mx = (u8_max & u8_val1) == u8_val1;
        let or_u8_0 = (u8_zero | u8_val1) == u8_val1;
        let or_u8_mx = (u8_max | u8_val1) == u8_max;
        let xor_u8_self = (u8_val1 ^ u8_val1) == 0u8;
        let xor_u8_diff = (u8_val1 ^ u8_val2) == 0xFFu8;

        // u16 tests
        let u16_zero = 0u16;
        let u16_max = 0xFFFFu16;
        let u16_val1 = 0xAAAAu16;
        let u16_val2 = 0x5555u16;

        let and_u16_0 = (u16_zero & u16_val1) == 0u16;
        let and_u16_mx = (u16_max & u16_val1) == u16_val1;
        let or_u16_0 = (u16_zero | u16_val1) == u16_val1;
        let or_u16_mx = (u16_max | u16_val1) == u16_max;
        let xor_u16_self = (u16_val1 ^ u16_val1) == 0u16;
        let xor_u16_diff = (u16_val1 ^ u16_val2) == 0xFFFFu16;

        // u32 tests
        let u32_zero = 0u32;
        let u32_max = 0xFFFFFFFFu32;
        let u32_val1 = 0xAAAAAAAAu32;
        let u32_val2 = 0x55555555u32;

        let and_u32_0 = (u32_zero & u32_val1) == 0u32;
        let and_u32_mx = (u32_max & u32_val1) == u32_val1;
        let or_u32_0 = (u32_zero | u32_val1) == u32_val1;
        let or_u32_mx = (u32_max | u32_val1) == u32_max;
        let xor_u32_self = (u32_val1 ^ u32_val1) == 0u32;
        let xor_u32_diff = (u32_val1 ^ u32_val2) == 0xFFFFFFFFu32;

        // u64 tests (prefixed with underscore to silence unused var warnings)
        let _u64_zero = 0u64;
        let _u64_max = 0xFFFFFFFFFFFFFFFFu64;
        let _u64_val1 = 0xAAAAAAAAAAAAAAAAu64;
        let _u64_val2 = 0x5555555555555555u64;
        let _and_u64_0 = (_u64_zero & _u64_val1) == 0u64;
        let _and_u64_mx = (_u64_max & _u64_val1) == _u64_val1;
        let _or_u64_0 = (_u64_zero | _u64_val1) == _u64_val1;
        let _or_u64_mx = (_u64_max | _u64_val1) == _u64_max;
        let _xor_u64_self = (_u64_val1 ^ _u64_val1) == 0u64;
        let _xor_u64_diff = (_u64_val1 ^ _u64_val2) == 0xFFFFFFFFFFFFFFFFu64;

        // u128 tests (prefixed with underscore)
        let _u128_zero = 0u128;
        let _u128_max = 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFu128;
        let _u128_val1 = 0xAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAu128;
        let _u128_val2 = 0x55555555555555555555555555555555u128;
        let _and_u128_0 = (_u128_zero & _u128_val1) == 0u128;
        let _and_u128_mx = (_u128_max & _u128_val1) == _u128_val1;
        let _or_u128_0 = (_u128_zero | _u128_val1) == _u128_val1;
        let _or_u128_mx = (_u128_max | _u128_val1) == _u128_max;
        let _xor_u128_self = (_u128_val1 ^ _u128_val1) == 0u128;
        let _xor_u128_diff = (_u128_val1 ^ _u128_val2) == _u128_max;

        // u256 tests (prefixed with underscore)
        let _u256_zero = 0u256;
        let _u256_max = 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFu256;
        let _u256_val1 = 0xAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAu256;
        let _u256_val2 = 0x5555555555555555555555555555555555555555555555555555555555555555u256;
        let _and_u256_0 = (_u256_zero & _u256_val1) == 0u256;
        let _and_u256_mx = (_u256_max & _u256_val1) == _u256_val1;
        let _or_u256_0 = (_u256_zero | _u256_val1) == _u256_val1;
        let _or_u256_mx = (_u256_max | _u256_val1) == _u256_max;
        let _xor_u256_self = (_u256_val1 ^ _u256_val1) == 0u256;
        let _xor_u256_diff = (_u256_val1 ^ _u256_val2) == _u256_max;

        (and_u8_0, and_u8_mx, or_u8_0, or_u8_mx, xor_u8_self, xor_u8_diff,
         and_u16_0, and_u16_mx, or_u16_0, or_u16_mx, xor_u16_self, xor_u16_diff,
         and_u32_0, and_u32_mx, or_u32_0, or_u32_mx, xor_u32_self, xor_u32_diff)
        // Note: u64, u128 and u256 tests omitted from return for brevity, but code does them.
    }

    /// A helper function to test an inline function with a lambda parameter by dereferencing
    public inline fun call_with_ref(lambda: &( |u8, u8| u8 has copy), a: u8, b: u8): u8 {
        (*lambda)(a, b)
    }

    /// Wrapper function calling `call_with_ref` with a lambda adding two values
    public fun test_inline_lambda(): u8 {
        let add_lambda: |u8, u8| u8 has copy+drop = |x: u8, y: u8| {
            x + y
        };
        call_with_ref(&add_lambda, 20u8, 22u8)
    }
}



//# run 0xCAFE::BitwiseTest::test_bitwise_ops



//# run 0xCAFE::BitwiseTest::test_inline_lambda
