//# publish
module 0x1::LoopTestModule {
    public fun run_loop_test(): () {
        // The purpose of this function is to test that a for loop with start > end does not execute.
        let mut counter = 0;

        // Loop with start > end, should not run
        for (i in 10..5) {
            counter = counter + 1;
        }

        // The counter should remain 0 since the loop should not run
        assert!(counter == 0, 100);
    }
}

 //# run 0x1::LoopTestModule::run_loop_test