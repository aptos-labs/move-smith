
//# publish
module 0xCAFE::BitwiseAndLoopTest {
    // Test loop with immediate break and variable update
    public fun loop_with_immediate_break(x: u8): u8 {
        let x_mut = x;
        loop {
            x_mut = x_mut + 1;
            break;
        };
        x_mut
    }

    // Test bitwise operations on various unsigned integer types
    // Returns a tuple with results for each operation and type to verify correctness
    public fun test_bitwise_ops(): (u8, u8, u8, u16, u16, u16, u32, u32, u32, u64, u64, u64, u128, u128, u128, u256, u256, u256) {
        let zero_u8: u8 = 0u8;
        let max_u8: u8 = 0xFFu8;
        let val1_u8: u8 = 0x55u8; // 01010101
        let val2_u8: u8 = 0xAAu8; // 10101010

        let and_u8 = val1_u8 & val2_u8;
        let or_u8 = val1_u8 | val2_u8;
        let xor_u8 = val1_u8 ^ val2_u8;

        let zero_u16: u16 = 0u16;
        let max_u16: u16 = 0xFFFFu16;
        let val1_u16: u16 = 0x5555u16;
        let val2_u16: u16 = 0xAAABu16;

        let and_u16 = val1_u16 & val2_u16;
        let or_u16 = val1_u16 | val2_u16;
        let xor_u16 = val1_u16 ^ val2_u16;

        let zero_u32: u32 = 0u32;
        let max_u32: u32 = 0xFFFFFFFFu32;
        let val1_u32: u32 = 0x55555555u32;
        let val2_u32: u32 = 0xAAAAAAAAu32;

        let and_u32 = val1_u32 & val2_u32;
        let or_u32 = val1_u32 | val2_u32;
        let xor_u32 = val1_u32 ^ val2_u32;

        let zero_u64: u64 = 0u64;
        let max_u64: u64 = 0xFFFFFFFFFFFFFFFFu64;
        let val1_u64: u64 = 0x5555555555555555u64;
        let val2_u64: u64 = 0xAAAAAAAAAAAAAAAau64;

        let and_u64 = val1_u64 & val2_u64;
        let or_u64 = val1_u64 | val2_u64;
        let xor_u64 = val1_u64 ^ val2_u64;

        let zero_u128: u128 = 0u128;
        let max_u128: u128 = 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFu128;
        let val1_u128: u128 = 0x55555555555555555555555555555555u128;
        let val2_u128: u128 = 0xAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAu128;

        let and_u128 = val1_u128 & val2_u128;
        let or_u128 = val1_u128 | val2_u128;
        let xor_u128 = val1_u128 ^ val2_u128;

        let zero_u256: u256 = 0u256;
        let max_u256: u256 = u256::MAX;
        let val1_u256: u256 = 0x5555555555555555555555555555555555555555555555555555555555555555u256;
        let val2_u256: u256 = 0xAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAau256;

        let and_u256 = val1_u256 & val2_u256;
        let or_u256 = val1_u256 | val2_u256;
        let xor_u256 = val1_u256 ^ val2_u256;

        (and_u8, or_u8, xor_u8,
         and_u16, or_u16, xor_u16,
         and_u32, or_u32, xor_u32,
         and_u64, or_u64, xor_u64,
         and_u128, or_u128, xor_u128,
         and_u256, or_u256, xor_u256)
    }

    // Declare native functions - without bodies
    native public fun native_func_no_body_0(): u8;
    native public fun native_func_no_body_1(x: u64): u64;

    // Declare native functions - with bodies (empty bodies for demonstration)
    public fun native_func_with_body_0(): u8 {
        42u8
    }

    public fun native_func_with_body_1(x: u64): u64 {
        x + 1u64
    }
}



//# run 0xCAFE::BitwiseAndLoopTest::loop_with_immediate_break --args 5u8



//# run 0xCAFE::BitwiseAndLoopTest::test_bitwise_ops



//# run 0xCAFE::BitwiseAndLoopTest::native_func_with_body_0



//# run 0xCAFE::BitwiseAndLoopTest::native_func_with_body_1 --args 100u64


// Features:
// 9d6fa7bbdf4ee46cd979039566ac14fa: Test that a loop with an immediate break correctly executes once and updates the variable accordingly.
// 6b2f6f761ce31c6627fbc6c3f231cd53: Test that the bitwise AND (&), OR (|), and XOR (^) operators produce correct results for all unsigned integer types (u8, u16, u32, u64, u128, and u256) on zero, identical, maximal, and mixed-value operands.
// 035dcc6afc2143ad24f0438dd6123c77: Declare native functions with or without a body in Move code.
