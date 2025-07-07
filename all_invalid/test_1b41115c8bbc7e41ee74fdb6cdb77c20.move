//# publish
module 0x1::ComparisonBitwiseShiftArithmeticTest {

    //# run
    public fun run_tests() {
        // Comparison tests
        assert!(10 == 10, 201);
        assert!(20 != 30, 202);
        assert!(15 < 20, 203);
        assert!(25 > 20, 204);
        assert!(35 <= 35, 205);
        assert!(40 >= 39, 206);

        // Logical operations
        assert!((true && false) == false, 207);
        assert!((false || true) == true, 208);
        assert!(!(false) == true, 209);

        // Bitwise operations
        assert!((0b1010 ^ 0b1100) == 0b0110, 210);
        assert!((0b0110 | 0b1001) == 0b1111, 211);
        assert!((0b1100 & 0b1010) == 0b1000, 212);

        // Shift operations
        assert!((1 << 4) == 16, 213);
        assert!((32 >> 3) == 4, 214);
        assert!((0b101010 >> 2) == 0b1010, 215);
        assert!((0b1010 << 3) == 0b1010000, 216);

        // Arithmetic operations with interactions
        let sum = 5 + 3;
        let diff = 10 - 4;
        let prod = 7 * 6;
        let quot = 20 / 4;
        let rem = 22 % 5;

        assert!(sum == 8, 217);
        assert!(diff == 6, 218);
        assert!(prod == 42, 219);
        assert!(quot == 5, 220);
        assert!(rem == 2, 221);

        // Combine operations
        let combined = ((2 + 3) * (4 - 1)) as u64;
        assert!(combined == 15, 222);

        // Test mixing logical and comparison
        assert!((5 > 2) && (3 < 4), 223);
        assert!(!((5 < 2) || (3 > 4)), 224);

        // Bitwise shift and comparison
        assert!(((1 << 3) == 8) && ((8 >> 3) == 1), 225);
    }
}