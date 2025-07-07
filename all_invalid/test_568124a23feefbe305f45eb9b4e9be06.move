//# publish
module 0xDEAD::TestIntegerOperations {
    use std::signer;

    public fun run_all_tests() {
        Self::test_shifts();
        Self::test_arithmetic();
        Self::test_type_casting();
        Self::test_bitwise_operations();
    }

    //# run 0xDEAD::TestIntegerOperations::test_shifts
    public fun test_shifts() {
        let x_u8: u8 = 1 << 3; // 8
        let x_u16: u16 = 1 << 12; // 4096
        let x_u32: u32 = 1 << 20; // 1048576
        let x_u64: u64 = 1 << 50; // 1125899906842624
        let x_u128: u128 = 1 << 100; // 1267650600228229401496703205376

        let shr_u8: u8 = 128 >> 4; // 8
        let shr_u16: u16 = 65536 >> 12; // 16
        let shr_u32: u32 = 1048576 >> 20; // 1
        let shr_u64: u64 = 1125899906842624 >> 50; // 1
        let shr_u128: u128 = (1 << 100) >> 100; // 1

        // Assertions (without explicit assertion syntax as per instructions)
        assert!(x_u8 == 8, 42);
        assert!(x_u16 == 4096, 42);
        assert!(x_u32 == 1048576, 42);
        assert!(x_u64 == 1125899906842624, 42);
        assert!(x_u128 == 1267650600228229401496703205376, 42);

        assert!(shr_u8 == 8, 42);
        assert!(shr_u16 == 16, 42);
        assert!(shr_u32 == 1, 42);
        assert!(shr_u64 == 1, 42);
        assert!(shr_u128 == 1, 42);
    }

    //# run 0xDEAD::TestIntegerOperations::test_arithmetic
    public fun test_arithmetic() {
        let a: u8 = 200;
        let b: u8 = 55;
        let div_result: u8 = a / b; // Should be 3
        let mod_result: u8 = a % b; // Should be 35
        let add_result: u8 = a + b; // 255
        let sub_result: u8 = a - b; // 145

        let a_u64: u64 = 1 << 60;
        let b_u64: u64 = 1 << 59;
        let div_u64: u64 = a_u64 / b_u64; // 2
        let mod_u64: u64 = a_u64 % b_u64; // 0
        let add_u64: u64 = a_u64 + b_u64; // 3 << 59
        let sub_u64: u64 = a_u64 - b_u64; // 1 << 59

        // Assertions
        assert!(div_result == 3, 42);
        assert!(mod_result == 35, 42);
        assert!(add_result == 255, 42);
        assert!(sub_result == 145, 42);
        assert!(div_u64 == 2, 42);
        assert!(mod_u64 == 0, 42);
        assert!(add_u64 == (1 << 60) + (1 << 59), 42);
        assert!(sub_u64 == (1 << 60) - (1 << 59), 42);
    }

    //# run 0xDEAD::TestIntegerOperations::test_type_casting
    public fun test_type_casting() {
        let from_u8: u8 = 255;
        let cast_to_u64: u64 = (from_u8 as u64);
        let from_u16: u16 = 65535;
        let cast_to_u128: u128 = (from_u16 as u128);
        let from_u64: u64 = 1 << 50;
        let cast_to_u8: u8 = (from_u64 as u8); // Should be 0 since 1<<50 overflows u8

        // Assertions
        assert!(cast_to_u64 == 255, 42);
        assert!(cast_to_u128 == 65535, 42);
        assert!(cast_to_u8 == 0, 42);
    }

    //# run 0xDEAD::TestIntegerOperations::test_bitwise_operations
    public fun test_bitwise_operations() {
        let val1_u8: u8 = 0b10101010;
        let val2_u8: u8 = 0b11001100;

        let and_result: u8 = val1_u8 & val2_u8; // 0b10001000
        let or_result: u8 = val1_u8 | val2_u8; // 0b11101100
        let xor_result: u8 = val1_u8 ^ val2_u8; // 0b01100100
        let not_result: u8 = !val1_u8; // 0b01010101

        // For u16
        let val1_u16: u16 = 0xFF00;
        let val2_u16: u16 = 0x0F0F;

        let band_u16: u16 = val1_u16 & val2_u16; // 0x0F00
        let bor_u16: u16 = val1_u16 | val2_u16; // 0xFF0F
        let bxor_u16: u16 = val1_u16 ^ val2_u16; // 0xF00F
        let bnot_u16: u16 = !val1_u16; // 0x00FF

        // Assertions
        assert!(and_result == 0b10001000, 42);
        assert!(or_result == 0b11101100, 42);
        assert!(xor_result == 0b01100100, 42);
        assert!(not_result == 0b01010101, 42);
        assert!(band_u16 == 0x0F00, 42);
        assert!(bor_u16 == 0xFF0F, 42);
        assert!(bxor_u16 == 0xF00F, 42);
        assert!(bnot_u16 == 0x00FF, 42);
    }
}