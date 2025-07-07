//# publish
module 0xabcde::bitwise_shift_and_apply {
    // Re-define the apply_repeatedly function for testing purposeful variation
    fun apply_repeatedly(f: |u64|u64, times: u64): |u64|u64 {
        |x| {
            let mut result = x;
            let mut i = 0;
            while (i < times) {
                result = f(result);
                i = i + 1;
            };
            result
        }
    }

    // Test function to verify repeated application of increment function
    public fun test_apply_increment(): u64 {
        let initial = 0;
        apply_repeatedly(|x| x + 2, 5)(initial)
        // Expected result: initial + 2 * 5 = 10
    }

    // Test that bitwise shifting and conditional check works as expected
    public fun test_shift_and_compare(): bool {
        let x = 2;
        let shifted_x = x << 3; // 2 << 3 = 16
        // Comparison: shifted_x == 16 && shifted_x > 10
        shifted_x == 16 && shifted_x > 10
    }

    // Define constants with complex bit shifts and sum their values
    const SHIFTED1: u16 = 1 << 10; // 1024
    const SHIFTED2: u16 = 1 >> 2;  // 0 (since 1>>2 = 0)
    const COMBINED: u16 = SHIFTED1 + SHIFTED2; // 1024 + 0 = 1024

    // Function to verify the sum of constants equals expected value
    public fun test_constants_sum(): u16 {
        COMBINED
    }
}

//# run 0xabcde::bitwise_shift_and_apply::test_apply_increment
//# run 0xabcde::bitwise_shift_and_apply::test_shift_and_compare
//# run 0xabcde::bitwise_shift_and_apply::test_constants_sum