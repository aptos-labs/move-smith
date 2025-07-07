
//# publish
module 0xCAFE::ArithmeticTests {
    // Removed unused 'use std::signer;'

    /// Adds two u8 values and returns the sum incremented by 1
    public fun add_and_increment(x: u8, y: u8): u8 {
        let sum = x + y;
        sum + 1
    }

    /// Defines and uses a lambda that multiplies two u8 values
    public fun lambda_multiply(a: u8, b: u8): u8 {
        let multiply: |u8, u8| u8 has copy+drop = |x: u8, y: u8| {
            x * y
        };
        multiply(a, b)
    }

    /// Inline function that doubles a u16
    public inline fun double_value(value: u16): u16 {
        value * 2
    }

    /// Calls inline function double_value within this module and returns its result plus 5
    public fun double_and_add_five(input: u16): u16 {
        let doubled = double_value(input);
        doubled + 5
    }

    /// Tests arithmetic, bitwise ops, shifts, and casts on all unsigned integer types
    public fun arithmetic_and_bitwise_ops() {
        let max_u8: u8 = 0xFF;
        let max_u16: u16 = 0xFFFF;
        let max_u32: u32 = 0xFFFF_FFFF;
        let max_u64: u64 = 0xFFFF_FFFF_FFFF_FFFF;
        let max_u128: u128 = 0xFFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF;
        let max_u256: u256 = 0xFFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF;

        // Addition with overflow wrapping - for Move, overflow aborts, so we must avoid overflow here
        let add_u8 = max_u8 - 1 + 1;
        let add_u16 = max_u16 - 1 + 1;
        let add_u32 = max_u32 - 1 + 1;
        let add_u64 = max_u64 - 1 + 1;
        let add_u128 = max_u128 - 1 + 1;
        let add_u256 = max_u256 - 1 + 1;

        // Bitwise operations
        let and_u8 = max_u8 & 0x0F;
        let or_u16 = max_u16 | 0x000F;
        let xor_u32 = max_u32 ^ 0xFFFF_0000;

        // Fixed the error here: bitwise NOT on a u64 is done via ! operator, but in Move '!' is logical NOT (boolean negation).
        // Use bitwise NOT function from std::bitwise for u64 or cast to u64 and invert bits with `max - value`.
        // However, Move supports `!` for integer types as of recent specs as bitwise NOT, but in error they say it expects bool.
        // The error is that the compiler sees a boolean context for ! operator.
        // So fix is to rewrite bitwise NOT for u64 as `max_u64 ^ 0xFFFF_FFFF_FFFF_FFFF` (XOR with all 1s).

        let not_u64 = max_u64 ^ 0xFFFF_FFFF_FFFF_FFFF;

        // Shifts - shift left and right by 1
        let shl_u8 = (1u8 << 1);
        let shr_u16 = (2u16 >> 1);

        // Cast between u8 and u16
        let cast_u16_to_u8 = (max_u16 & 0xFF) as u8;
        let cast_u8_to_u16 = max_u8 as u16;

        // Cast between u32 and u64
        let cast_u64_to_u32 = (max_u64 & 0xFFFF_FFFF) as u32;
        let cast_u32_to_u64 = max_u32 as u64;

        // Cast between u128 and u256
        let cast_u128_to_u256 = max_u128 as u256;
        // For cast u256 to u128, we only keep lower 128 bits. Use bitwise and
        // Construct a 128-bit mask instead of a 256-bit literal
        let mask_u256_for_u128: u256 = 0x00000000000000000000000000000000_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF;
        let cast_u256_to_u128 = (max_u256 & mask_u256_for_u128) as u128;

        // Void usage of these variables with let _ = ... to avoid compiler optimization removal
        let _ = add_u8;
        let _ = add_u16;
        let _ = add_u32;
        let _ = add_u64;
        let _ = add_u128;
        let _ = add_u256;

        let _ = and_u8;
        let _ = or_u16;
        let _ = xor_u32;
        let _ = not_u64;

        let _ = shl_u8;
        let _ = shr_u16;

        let _ = cast_u16_to_u8;
        let _ = cast_u8_to_u16;

        let _ = cast_u64_to_u32;
        let _ = cast_u32_to_u64;

        let _ = cast_u128_to_u256;
        let _ = cast_u256_to_u128;
    }

    // affects = "storage"]
    public fun pragma_test() {}

    // priority = "high"]
    public fun pragma_test2() {}

}



//# run 0xCAFE::ArithmeticTests::add_and_increment --args 5u8 10u8



//# run 0xCAFE::ArithmeticTests::lambda_multiply --args 7u8 6u8



//# run 0xCAFE::ArithmeticTests::double_and_add_five --args 3u16



//# run 0xCAFE::ArithmeticTests::arithmetic_and_bitwise_ops



//# run 0xCAFE::ArithmeticTests::pragma_test



//# run 0xCAFE::ArithmeticTests::pragma_test2



//# publish
module 0xCAFE::UseInline {
    use 0xCAFE::ArithmeticTests;

    /// Calls ArithmeticTests::double_value inline function and adds 10, returns the result
    public fun call_inline_double(value: u16): u16 {
        let doubled = ArithmeticTests::double_value(value);
        doubled + 10
    }
}



//# run 0xCAFE::UseInline::call_inline_double --args 15u16
