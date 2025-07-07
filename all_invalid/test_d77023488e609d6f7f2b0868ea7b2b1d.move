//# publish
module 0xA100::LoopTestModule {
    public fun run_no_execution() {
        let x = 0;
        // Loop condition is false; the loop body should not execute
        while (false) {
            x = 999;
        };
        // Assert that x remains unchanged
        assert!(x == 0, 42);
    }

    public fun run_true_once() {
        let x = 0;
        let count = 0;
        // Loop will run exactly once because condition is true initially,
        // then condition becomes false after first iteration
        while (count == 0) {
            x = 123;
            count = count + 1;
        };
        assert!(x == 123, 43);
        assert!(count == 1, 44);
    }
}

 //# run 0xA100::LoopTestModule::run_no_execution
 //# run 0xA100::LoopTestModule::run_true_once