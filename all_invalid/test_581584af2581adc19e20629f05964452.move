//# publish
module 0x1::int_operations_test {
    public fun run_tests(): bool {
        // Declare constants for various unsigned integer types
        let a_u8: u8 = 15;
        let a_u16: u16 = 300;
        let a_u32: u32 = 70000;
        let a_u64: u64 = 123456789;
        let a_u128: u128 = 340282366920938463463374607431768211455; // max u128
        let a_u256: u256 = u256::max();

        // Shifts
        let shl_u8 = a_u8 << 3; // 15 << 3 = 120
        let shl_u16 = a_u16 << 2; // 300 << 2 = 1200
        let shl_u32 = a_u32 << 1; // 70000 << 1 = 140000
        let shl_u64 = a_u64 << 4; // 123456789 << 4
        let shl_u128 = a_u128 << 10; // large shift
        let shl_u256 = u256::shift_left(a_u256, 8); // shift 256

        // Shifts right
        let shr_u8 = a_u8 >> 2; // 15 >> 2 = 3
        let shr_u16 = a_u16 >> 3; // 300 >> 3 = 37
        let shr_u32 = a_u32 >> 4; // 70000 >> 4 = 4375
        let shr_u64 = a_u64 >> 8; // 123456789 >> 8
        let shr_u128 = a_u128 >> 20; // large shift
        let shr_u256 = u256::shift_right(a_u256, 16); // shift 256

        // Division
        let div_u8 = a_u8 / 3; // 15/3=5
        let div_u16 = a_u16 / 25; // 300/25=12
        let div_u32 = a_u32 / 70; // 70000/70=1000
        let div_u64 = a_u64 / 1000; // 123456789/1000
        let div_u128 = a_u128 / 100000; // large number
        let div_u256 = u256::div(a_u256, u256::from(2)); // max / 2

        // Remainder
        let rem_u8 = a_u8 % 6; // 15%6=3
        let rem_u16 = a_u16 % 7; // 300%7=6
        let rem_u32 = a_u32 % 23; // 70000%23
        let rem_u64 = a_u64 % 100; // remainder
        let rem_u128 = a_u128 % 12345; // large mod
        let rem_u256 = u256::rem(a_u256, u256::from(3)); // max %3

        // Addition and Subtraction
        let add_u8 = a_u8 + 250; // 15+250=265 mod 256=9
        let add_u16 = a_u16 + 700; // 300+700=1000
        let add_u32 = a_u32 + 300000; // 70000+300000=370000
        let add_u64 = a_u64 + 987654321; // 123456789+987654321
        let add_u128 = u128::max() - u128::from(1000); // max - 1000
        let add_u256 = u256::add(a_u256, u256::from(1)); // max +1 wraps

        let sub_u8 = a_u8 - 10; // 15-10=5
        let sub_u16 = a_u16 - 200; // 300-200=100
        let sub_u32 = a_u32 - 35000; // 70000-35000=35000
        let sub_u64 = a_u64 - 1234567; // subtract small
        let sub_u128 = u128::max() - u128::from(5000);
        let sub_u256 = u256::sub(a_u256, u256::from(1)); // max -1

        // Type casting
        let cast_u8_from_u16 = a_u16 as u8; // 300 as u8 = 44 (since 300 mod 256)
        let cast_u16_from_u8 = a_u8 as u16; // 15
        let cast_u32_from_u64 = a_u64 as u32; // lower 32 bits
        let cast_u128_from_u32 = a_u32 as u128; // promote
        let cast_u256_from_u128 = u256::from(a_u128); // promote from u128

        // Bitwise AND, OR, XOR
        let band = a_u8 & 0b1010; // 15 & 0b1010=10
        let bor = a_u16 | 0b100000001; // 300 | 257
        let bxor = a_u32 ^ 0xFFFF; // 70000 ^ 65535
        let band_u64 = a_u64 & 0xFFFFFFFF; // mask lower 32 bits
        let bor_u128 = a_u128 | u128::from(0xFFFFFFFF); // set lower bits
        let bxor_u256 = u256::xor(a_u256, u256::from(0xFFFFFFFF));

        // Final assertion functions for demonstration
        // Here, only perform checks to ensure expressions evaluate without error.
        // For brevity, assertions are omitted as per instructions.

        true
    }
}

//# run 0x1::int_operations_test::run_tests
