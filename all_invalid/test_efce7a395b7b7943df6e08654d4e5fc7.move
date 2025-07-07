//# publish
module 0x1::TestModule {
    public fun run_once_and_update() {
        let mut count = 0;
        let mut i = 0;
        while (i < 5) {
            if (i == 0) {
                count = count + 1;
                break; // Should break after first iteration
            }
            i = i + 1;
        }
        // Mimic an assertion to verify count is 1
        // (In actual test, assertions would be added externally)
        assert!(count == 1, 42);
    }
}

 //# publish
module 0x2::LoopAndBreak {
    public fun test_break_in_loop() {
        let mut total = 10;
        let mut counter = 0;
        loop {
            if (total == 10) {
                total = total - 5;
                break;
            }
            total = total + 1;
            counter = counter + 1;
        }
        // Expected: total == 5, counter == 0
        assert!(total == 5, 43);
        assert!(counter == 0, 43);
    }
}

 //# run 0x1::TestModule::run_once_and_update --signers 0x1
 //# run 0x2::LoopAndBreak::test_break_in_loop --signers 0x2