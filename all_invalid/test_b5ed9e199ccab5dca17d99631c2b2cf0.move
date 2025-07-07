//# publish
module 0xABCDEF::test_module {
    // This function is just to be called to ensure the module compiles
    public fun init() {}
}

//# run
script {
    // Integer comparisons
    const int_cmp1: bool = {
        10 == 10;
        20 != 15;
        100 >= 100;
        50 <= 60;
        5 < 10;
        15 > 5;
        true == true;
        false != true
    };

    // Boolean logical operations
    const bool_ops: bool = {
        true && false;
        true || false;
        !false;
        !(true && false);
        (true || false) && false
    };

    // Byte and hexadecimal equality and inequality
    const byte_eq: bool = {
        x"ff" == x"ff";
        x"0a" != x"0b";
        b"test" == b"test";
        b"abc" != b"def"
    };

    // Bitwise, shift, and arithmetic computations
    const bitwise_shift_arith: bool = {
        // bitwise and
        (0xF0 & 0x0F) == 0x00;
        // bitwise or
        (0xF0 | 0x0F) == 0xFF;
        // bitwise xor
        (0xAA ^ 0x55) == 0xFF;
        // left shift
        (1 << 4) == 16;
        // right shift
        (128 >> 3) == 16;
        // addition and subtraction
        (100 + 200) == 300;
        (500 - 200) == 300;
        // multiplication
        (7 * 6) == 42;
        // division
        (100 / 4) == 25;
        // modulus
        (10 % 3) == 1
    };

    // u128, u64, u8 casting and overflow behavior
    const cast_and_overflow: bool = {
        ((255: u8) as u128) == 255;
        ((18446744073709551615: u128) as u64) == 0xFFFFFFFFFFFFFFFF;
        ((1: u8) as u128) == 1;
        // Overflow test, wrap-around behavior
        let a: u8 = 255;
        let b: u8 = a + 1; // Should wrap to 0
        b == 0
    };

    // Large number arithmetic and mix of types
    const large_numbers: bool = {
        // Add two max u128
        let max_u128: u128 = 340282366920938463463374607431768211455;
        (max_u128 + 1) == max_u128 - 340282366920938463463374607431768211455 + 1; // should overflow to 0
        // Subtract to get zero
        max_u128 - max_u128 == 0
    };

    // Final assertion to ensure tests all pass
    fun main() {
        assert!(int_cmp1, 101);
        assert!(bool_ops, 102);
        assert!(byte_eq, 103);
        assert!(bitwise_shift_arith, 104);
        assert!(cast_and_overflow, 105);
        assert!(large_numbers, 106);
    }
}