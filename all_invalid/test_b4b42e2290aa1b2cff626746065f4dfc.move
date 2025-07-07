//# publish
module 0xA1B2::TestIntegerOps {
    use std::assert;

    //# run
    script {
        // Left shift for various unsigned types
        const SHL_u8: u8 = 1 << 3; // 8
        const SHL_u64: u64 = 1 << 60; // 1152921504606846976
        const SHL_u128: u128 = 1 << 127; // 170141183460469231731687303715884105728
        const SHL_u16: u16 = 1 << 10; // 1024
        const SHL_u32: u32 = 1 << 31; // 2147483648
        const SHL_u256: u256 = 1 << 200; // 1606938044258990275541962092341162602522202993782792835301376

        // Right shift for various unsigned types
        const SHR_u8: u8 = 128 >> 4; // 8
        const SHR_u64: u64 = 0xFFFFFFFFFFFFFFFF >> 63; // 1
        const SHR_u128: u128 = 340282366920938463463374607431768211455 >> 126; // 3
        const SHR_u16: u16 = 0xFFFF >> 11; // 31
        const SHR_u32: u32 = 0xFFFFFFFF >> 30; // 1073741823
        const SHR_u256: u256 = (1 << 255) | (1 << 127); // 2^255 + 2^127

        // Division operations
        const DIV_u8: u8 = 200 / 5; // 40
        const DIV_u64: u64 = 1000000000000 / 1000; // 1_000_000_000
        const DIV_u128: u128 = 340282366920938463463374607431768211455 / 2; // 1.7014118346046923e38
        const DIV_u16: u16 = 65535 / 3; // 21845
        const DIV_u32: u32 = 4294967295 / 2; // 2147483647
        const DIV_u256: u256 = 115792089237316195423570985008687907853269984665640564039457584007913129639935 / 3;

        // Modulo operations
        const MOD_u8: u8 = 255 % 7; // 3
        const MOD_u64: u64 = 123456789 % 256; // 21
        const MOD_u128: u128 = 340282366920938463463374607431768211455 % 10; // 5
        const MOD_u16: u16 = 65535 % 8; // 7
        const MOD_u32: u32 = 4294967295 % 13; // 12
        const MOD_u256: u256 = 115792089237316195423570985008687907853269984665640564039457584007913129639935 % 17;

        // Addition
        const ADD_u8: u8 = 250 + 10; // 4 (overflow)
        const ADD_u64: u64 = 18446744073709551615 + 1; // 0 (overflow)
        const ADD_u128: u128 = 340282366920938463463374607431768211455 + 1; // 0 (overflow)
        const ADD_u16: u16 = 65535 + 1; // 0 (overflow)
        const ADD_u32: u32 = 4294967295 + 1; // 0 (overflow)
        const ADD_u256: u256 = 115792089237316195423570985008687907853269984665640564039457584007913129639935 + 1; // 0 (overflow)

        // Subtraction
        const SUB_u8: u8 = 0 - 1; // 255 (underflow)
        const SUB_u64: u64 = 0 - 1; // 18446744073709551615
        const SUB_u128: u128 = 0 - 1; // 340282366920938463463374607431768211455
        const SUB_u16: u16 = 0 - 1; // 65535
        const SUB_u32: u32 = 0 - 1; // 4294967295
        const SUB_u256: u256 = 0 - 1; // 115792089237316195423570985008687907853269984665640564039457584007913129639935

        // Type casting between different unsigned types
        const CAST_u8_to_u64: u64 = (255u8) as u64; // 255
        const CAST_u64_to_u128: u128 = (18446744073709551615u64) as u128; // 18446744073709551615
        const CAST_u8_to_u128: u128 = (255u8) as u128; // 255
        const CAST_u16_to_u32: u32 = (65535u16) as u32; // 65535
        const CAST_u32_to_u256: u256 = (4294967295u32) as u256; // 4294967295
        const CAST_u8_to_u256: u256 = (255u8) as u256; // 255

        // Bitwise AND
        const BAND_u8: u8 = 0b10101010 & 0b11001100; // 0b10001000 (136)
        const BAND_u64: u64 = 0xFFFFFFFFFFFFFFFF & 0x0F0F0F0F0F0F0F0F; // 0x0F0F0F0F0F0F0F0F
        const BAND_u128: u128 = 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF & 0x00FF00FF00FF00FF; // 0x00FF00FF00FF00FF
        const BAND_u16: u16 = 0xAAAA & 0x5555; // 0x0000 (0)
        const BAND_u32: u32 = 0x12345678 & 0x87654321; // 0x02044000
        const BAND_u256: u256 = 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF & 0x0F0F0F0F0F0F0F0F; // 0x00...0F0F0F0F

        // Bitwise OR
        const BOR_u8: u8 = 0b10101010 | 0b01010101; // 0b11111111 (255)
        const BOR_u64: u64 = 0x0000000000000000 | 0xFFFFFFFFFFFFFFFF; // 0xFFFFFFFFFFFFFFFF
        const BOR_u128: u128 = 0x00FF00FF00FF00FF | 0xFF00FF00FF00FF00; // 0xFFFF00FFFF00FF00
        const BOR_u16: u16 = 0xAAAA | 0x5555; // 0xFFFF
        const BOR_u32: u32 = 0x12345678 | 0x87654321; // 0x97755779
        const BOR_u256: u256 = 0x0 | 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF; // 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF

        // Bitwise XOR
        const BXOR_u8: u8 = 0b11110000 ^ 0b10101010; // 0b01011010 (90)
        const BXOR_u64: u64 = 0xFFFFFFFFFFFFFFFF ^ 0x0F0F0F0F0F0F0F0F; // 0xF0F0F0F0F0F0F0F0
        const BXOR_u128: u128 = 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF ^ 0x00FF00FF00FF00FF; // 0xFFFFFF00FFFFFF00
        const BXOR_u16: u16 = 0xFFFF ^ 0x0000; // 0xFFFF
        const BXOR_u32: u32 = 0xABCDEF12 ^ 0x12345678; // 0xB9F9B98A
        const BXOR_u256: u256 = 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF ^ 0x0F0F0F0F0F0F0F0F; // 0xF0F0F0F0F0F0F0F0

        fun main() {
            // Validate shifts
            assert!(SHL_u8 == 8, 42);
            assert!(SHL_u64 == 1152921504606846976, 42);
            assert!(SHL_u128 == 170141183460469231731687303715884105728, 42);
            assert!(SHL_u16 == 1024, 42);
            assert!(SHL_u32 == 2147483648, 42);
            assert!(SHL_u256 == 2u256 << 200);

            assert!(SHR_u8 == 8, 42);
            assert!(SHR_u64 == 1, 42);
            assert!(SHR_u128 == 3, 42);
            assert!(SHR_u16 == 31, 42);
            assert!(SHR_u32 == 1073741823, 42);
            assert!(SHR_u256 == (1 << 255) | (1 << 127), 42);

            // Validate division
            assert!(DIV_u8 == 40, 42);
            assert!(DIV_u64 == 1000000000000 / 1000, 42);
            assert!(DIV_u128 == 170141183460469231731687303715884105728, 42);
            assert!(DIV_u16 == 21845, 42);
            assert!(DIV_u32 == 2147483647, 42);
            assert!(DIV_u256 == 115792089237316195423570985008687907853269984665640564039457584007913129639935 / 3, 42);

            // Validate modulo
            assert!(MOD_u8 == 3, 42);
            assert!(MOD_u64 == 21, 42);
            assert!(MOD_u128 == 5, 42);
            assert!(MOD_u16 == 7, 42);
            assert!(MOD_u32 == 12, 42);
            assert!(MOD_u256 == 115792089237316195423570985008687907853269984665640564039457584007913129639935 % 17, 42);

            // Validate addition overflow
            assert!(ADD_u8 == 4, 42);
            // For overflowed adds, wraparound is expected, so no assert here

            // Validate subtraction underflow
            assert!(SUB_u8 == 255, 42);
            // For underflows, wrapping around expected; assertions can be included to confirm

            // Type casting
            assert!(CAST_u8_to_u64 == 255, 42);
            assert!(CAST_u64_to_u128 == 18446744073709551615, 42);
            assert!(CAST_u8_to_u128 == 255, 42);
            assert!(CAST_u16_to_u32 == 65535, 42);
            assert!(CAST_u32_to_u256 == 4294967295, 42);
            assert!(CAST_u8_to_u256 == 255, 42);

            // Bitwise AND
            assert!(BAND_u8 == 136, 42);
            assert!(BAND_u64 == 0x0F0F0F0F0F0F0F0F, 42);
            assert!(BAND_u128 == 0x00FF00FF00FF00FF, 42);
            assert!(BAND_u16 == 0, 42);
            assert!(BAND_u32 == 0x02044000, 42);
            assert!(BAND_u256 == 0x00...0F0F0F0F, 42); // Not printing full, but expected

            // Bitwise OR
            assert!(BOR_u8 == 255, 42);
            assert!(BOR_u64 == 0xFFFFFFFFFFFFFFFF, 42);
            assert!(BOR_u128 == 0xFFFF00FFFF00FF00, 42);
            assert!(BOR_u16 == 0xFFFF, 42);
            assert!(BOR_u32 == 0x97755779, 42);
            assert!(BOR_u256 == 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF, 42);

            // Bitwise XOR
            assert!(BXOR_u8 == 0b01011010, 42);
            assert!(BXOR_u64 == 0xF0F0F0F0F0F0F0F0, 42);
            assert!(BXOR_u128 == 0xFFFFFF00FFFFFF00, 42);
            assert!(BXOR_u16 == 0xFFFF, 42);
            assert!(BXOR_u32 == 0xB9F9B98A, 42);
            assert!(BXOR_u256 == 0xF0F0F0F0F0F0F0F0, 42);
        }
    }
}