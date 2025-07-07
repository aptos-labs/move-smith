
//# publish
module 0xCAFE::LoopTest {
    use std::vector;

    // This function tests for-loops with break and continue
    public fun test_loop_control(): u64 {
        let sum: u64 = 0;
        let i: u64 = 0;
        while (i < 10) {
            if (i == 5) {
                break;
            }
            if (i % 2 == 0) {
                i = i + 1;
                continue;
            }
            sum = sum + i;
            i = i + 1;
        };
        // Return sum (should be sum of odd numbers 1,3,7,9)
        sum
    }
}