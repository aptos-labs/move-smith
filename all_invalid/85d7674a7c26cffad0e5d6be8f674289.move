
//# publish
module 0xCAFE::VisibilityAndIntegerOps {
    // Test explicit function visibility and various integer operations

    public fun add_u8(a: u8, b: u8): u8 {
        a + b
    }

    public fun sub_u16(a: u16, b: u16): u16 {
        a - b
    }

    public fun div_u32(a: u32, b: u32): u32 {
        a / b
    }

    public fun mod_u64(a: u64, b: u64): u64 {
        a % b
    }

    public public(script) fun shl_u8(a: u8, bits: u8): u8 {
        a << bits
    }

    public public(script) fun shr_u16(a: u16, bits: u16): u16 {
        a >> bits
    }

    public native fun native_add_u128(a: u128, b: u128): u128;

    public fun bitwise_and_u8(a: u8, b: u8): u8 {
        a & b
    }

    public fun bitwise_or_u16(a: u16, b: u16): u16 {
        a | b
    }

    public fun bitwise_xor_u32(a: u32, b: u32): u32 {
        a ^ b
    }

    public fun cast_u8_to_u64(a: u8): u64 {
        a as u64
    }

    public fun cast_u64_to_u8(a: u64): u8 {
        a as u8
    }

    public fun complex_expression<T > (a: u8, b: u8): u8 {
        // Disambiguating generic < with less than operator by space before <
        let sum = add_u8(a, b);
        let shifted = shl_u8(sum, 1);
        shifted ^ a
    }

    // Runner function without arguments for calling all above functions
    public fun runner() {
        let _ = add_u8(10u8, 20u8);
        let _ = sub_u16(100u16, 22u16);
        let _ = div_u32(1000u32, 10u32);
        let _ = mod_u64(123u64, 10u64);
        let _ = shl_u8(2u8, 3u8);
        let _ = shr_u16(128u16, 2u16);
        let _ = bitwise_and_u8(0b1010u8, 0b1100u8);
        let _ = bitwise_or_u16(0b1010_0000u16, 0b0111_1111u16);
        let _ = bitwise_xor_u32(0xF0F0u32, 0x0F0Fu32);
        let _ = cast_u8_to_u64(200u8);
        let _ = cast_u64_to_u8(2000u64);
        let _ = complex_expression<u8>(5u8, 3u8);
    }
}


//# run 0xCAFE::VisibilityAndIntegerOps::runner


//# run 0xCAFE::VisibilityAndIntegerOps::add_u8 --args 7u8 8u8


//# run 0xCAFE::VisibilityAndIntegerOps::sub_u16 --args 300u16 123u16


//# run 0xCAFE::VisibilityAndIntegerOps::div_u32 --args 100u32 7u32


//# run 0xCAFE::VisibilityAndIntegerOps::mod_u64 --args 123u64 10u64


//# run 0xCAFE::VisibilityAndIntegerOps::shl_u8 --args 3u8 4u8


//# run 0xCAFE::VisibilityAndIntegerOps::shr_u16 --args 256u16 4u16


//# run 0xCAFE::VisibilityAndIntegerOps::bitwise_and_u8 --args 12u8 10u8


//# run 0xCAFE::VisibilityAndIntegerOps::bitwise_or_u16 --args 0u16 65535u16


//# run 0xCAFE::VisibilityAndIntegerOps::bitwise_xor_u32 --args 123456u32 654321u32


//# run 0xCAFE::VisibilityAndIntegerOps::cast_u8_to_u64 --args 250u8


//# run 0xCAFE::VisibilityAndIntegerOps::cast_u64_to_u8 --args 1234u64


//# run 0xCAFE::VisibilityAndIntegerOps::complex_expression --args 6u8 9u8


// Featurres:
// edb1695b8feadf4925d9092931cfd9d7: Specify function visibility explicitly in your code.
// 3bc88f08da8c1fc1b775406d9d65238d: Test that various integer operations—shifts, division, modulo, addition, subtraction, type casting, bitwise AND, OR, XOR—produce the expected results for different unsigned integer types in Move.
// 75fff8fc3ba40c50396bcf7caeae5564: Write type arguments with a space before the '<' when necessary to disambiguate the '<' operator from a generic type parameter.
