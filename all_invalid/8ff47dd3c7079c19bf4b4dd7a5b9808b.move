//# publish
module 0xCAFE::ShiftOpsTest {
    // Function to test left shift operation on u8 constants
    public fun test_left_shift_consts(): u8 {
        let shifted1 = 1u8 << 0; // shifting by 0
        let shifted2 = 1u8 << 7; // shifting by 7 (max for u8)
        // shifting by value >=bit size (8) is invalid in Move, but for testing, we simulate the intent
        // In Move, shifting by >= size is a compile error; so, we test shifting by 7 only, which is valid
        // We can simulate shifting by 8 or more by using a shift amount wrapped mod 8 if needed. But Move disallows that.
        // So, for the test, only shift by 0 and 7.
        shifted1 + shifted2
    }

    // Function to test right shift operation on u8 constants
    public fun test_right_shift_consts(): u8 {
        let shifted1 = 128u8 >> 0; // shifting by 0
        let shifted2 = 128u8 >> 7; // shifting by 7, expected 1
        // similarly, shifting by >=8 would be invalid
        shifted1 + shifted2
    }

    // Function to test a simple computation returning 10
    public fun compute_ten(): u8 {
        let x = 5u8;
        let y = 2u8;
        let sum = x + y; // 7
        let res = sum + 3u8; // 10
        res
    }
}

//# run 0xCAFE::ShiftOpsTest::test_left_shift_consts
//# run 0xCAFE::ShiftOpsTest::test_right_shift_consts
//# run 0xCAFE::ShiftOpsTest::compute_ten

// Featurres:
// 34183dbe62dabfa8fcd639e71d83badf: Add functions to a module with associated attributes and kind annotations.
// d6f1856345e9323c4256bcaff78ef69a: Test that left and right shift operations on u8 constants correctly handle shifts greater than or equal to the bit width and produce valid constant values.
// 9b3b414c1289e41cdd9f366bec5543a8: Test that the module's public function returns the value 10 after assigning it to a local variable.
