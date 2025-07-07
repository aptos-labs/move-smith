//# publish
module 0x1::test_module {
    // No specific functions needed for this test
}

//# run
script {
    fun main(): () {
        // Loop with start > end, should not execute
        for (i in 5..3) {
            assert!(false, 99);
        };
        // Loop with start == end, should execute once
        for (j in 7..7) {
            // do nothing
        };
        // Loop with start < end, should execute
        let mut sum = 0;
        for (k in 0..2) {
            sum = sum + k;
        };
        // verify sum is 1 (0 + 1)
        assert!(sum == 1, 100);
    }
}