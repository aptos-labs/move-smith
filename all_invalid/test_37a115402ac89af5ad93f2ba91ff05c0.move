//# publish
module 0xABC::comparison_bitwise_shift_arithmetic {
    /// Function to test various operations with assertions
    public fun test_operations(): bool {
        // Comparison operations
        assert!(10 == 10, 201);
        assert!(20 != 25, 202);
        assert!((-5) < 0, 203);
        assert!((-10) > -20, 204);
        assert!(100 <= 100, 205);
        assert!(-50 >= -100, 206);

        // Logical operations
        assert!((true && false) == false, 207);
        assert!((true || false) == true, 208);
        assert!(!false == true, 209);
        assert!((false || false) == false, 210);

        // Bitwise operations
        assert!((0b1010 ^ 0b1100) == 0b0110, 211);
        assert!((0b1010 | 0b0101) == 0b1111, 212);
        assert!((0b1111 & 0b0101) == 0b0101, 213);

        // Shift operations
        assert!((1 << 4) == 16, 214);
        assert!((32 >> 3) == 4, 215);

        // Arithmetic operations
        assert!((15 + 10) == 25, 216);
        assert!((50 - 20) == 30, 217);
        assert!((6 * 7) == 42, 218);
        assert!((100 / 4) == 25, 219);
        assert!((10 % 3) == 1, 220);

        true
    }
}

//# run 0xABC::comparison_bitwise_shift_arithmetic::test_operations

//# publish
module 0xDEF::tuple_destructuring_and_modification {
    /// Function to test tuple destructuring and sequential modifications
    public fun modify_and_return(): u64 {
        let a = 2;
        let b;
        let c;
        // Destructuring tuples
        (b, c, a) = (a + 3, { a = a * 2; a }, { a = a - 1; a });
        // b=5, c=4, a=1 after modifications
        b * c + a
    }
}

//# run 0xDEF::tuple_destructuring_and_modification::modify_and_return

//# publish
module 0x123::runner {
    // Entry point to run all tests
    public fun run_all_tests() {
        // Run comparison, logical, bitwise, shift, arithmetic operations tests
        ComparisonBitwiseShiftArithmetic::test_operations();

        // Run tuple destructuring and modification test
        let result = TupleDestructuringAndModification::modify_and_return();
        assert!(result == 5, 301);
    }
}

//# run 0x123::runner::run_all_tests