
//# publish
module 0xCAFE::LogicalShiftPatternTest {
    use std::assert;

    // Struct with multiple fields for pattern matching
    struct DataStruct has copy, drop {
        a: bool,
        b: u8,
        c: u16,
        d: u32,
        e: u64,
    }

    // Function to test logical NOT (!) on various boolean expressions
    public fun test_logical_not() {
        let b1 = true;
        let b2 = false;
        let b3 = (b1 && b2);
        let b4 = (!b1);
        let b5 = (!b2);
        let b6 = (!(b1 || b2));
        let b7 = (!((b1 && b2) || b2));

        assert!(b4 == false, 1);
        assert!(b5 == true, 2);
        assert!(b6 == true, 3);
        assert!(b7 == false, 4);
    }

    // Function to test shift operations on u8 constants
    public fun test_shifts() {
        // Shift by 8 should produce 0 or maximum value, but in Move, the shift is modulo the bits (8 bits)
        let shift_amount1: u8 = 8;
        let shift_amount2: u8 = 9; // same as 1 in Move shift semantics
        let val1 = 0xFFu8 << shift_amount1; // shifted by 8 -> 0
        let val2 = 0x80u8 >> shift_amount2; // shifted by 1 -> 0x40

        assert!(val1 == 0, 5);
        assert!(val2 == 0x40, 6);
    }

    // Function to test pattern matching and field ignoring with '..'
    public fun test_pattern_matching() {
        let data = DataStruct {
            a: true,
            b: 255,
            c: 65535,
            d: 4294967295,
            e: 18446744073709551615,
        };

        // Pattern match, ignore some fields with '..'
        let DataStruct { a: a_val, b: b_val, .. } = data;

        assert!(a_val == true, 7);
        assert!(b_val == 255, 8);
    }

    // Function to combine logical NOT and shift operations
    public fun test_logical_not_and_shifts() {
        let shifted = (0x1u8 << 8); // shift by 8 -> 0
        let not_shifted = !(0x80u8 >> 8); // shift by 8 -> 0, then !0 -> true

        // Assertions
        assert!(shifted == 0, 9);
        assert!(!not_shifted, 10);
    }

    // Function to pattern match with shifts and logicals
    public fun test_pattern_with_shifts() {
        let data = DataStruct {
            a: false,
            b: 128,
            c: 1024,
            d: 2048,
            e: 4096,
        };

        let DataStruct { a: a_field, b: b_field, .. } = data;

        // shift b, ignore others
        let shifted_b = b_field >> 7; // 128 >> 7 == 1
        let pattern_check = !(a_field) && (shifted_b == 1);

        assert!(pattern_check, 11);
    }
}


//# run 0xCAFE::LogicalShiftPatternTest::test_logical_not --args

//# run 0xCAFE::LogicalShiftPatternTest::test_shifts --args

//# run 0xCAFE::LogicalShiftPatternTest::test_pattern_matching --args

//# run 0xCAFE::LogicalShiftPatternTest::test_logical_not_and_shifts --args

//# run 0xCAFE::LogicalShiftPatternTest::test_pattern_with_shifts --args


// Featurres:
// d803bc5e7b4f24c63c81f771f009e5ab: Apply the logical NOT operator (!) to expressions.
// d6f1856345e9323c4256bcaff78ef69a: Test that left and right shift operations on u8 constants correctly handle shifts greater than or equal to the bit width and produce valid constant values.
// dfd056b59dd5b954472c6db4a6f22b0b: Use the '..' syntax at the end of a named struct deconstruction pattern to ignore unlisted fields during pattern matching or let bindings.
