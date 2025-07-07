//# publish
module 0x1::ForLoopTest {
    public fun run_for_loop_with_invalid_range() {
        // The loop should not execute because the start (5) is greater than the end (3)
        for (i in 5..3) {
            assert!(false, 1);
        };
    }

    public fun run_valid_range() {
        let mut sum = 0;
        // Loop from 2 to 4, should iterate 3 times: 2, 3, 4
        for (i in 2..=4) {
            sum = sum + i;
        };
        // sum should be 2 + 3 + 4 = 9
        assert!(sum == 9, 2);
    }
}
//# run 0x1::ForLoopTest::run_for_loop_with_invalid_range

//# run 0x1::ForLoopTest::run_valid_range