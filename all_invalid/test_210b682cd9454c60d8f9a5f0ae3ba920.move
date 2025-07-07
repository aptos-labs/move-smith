//# publish
module 0xA12123::LoopTestModule {
    /// Runner function to test the loop with internal conditional and return
    public fun run_loop_test() {
        main();
    }

    /// Main function that contains the loop with internal conditional involving return
    public fun main() {
        let mut counter = 0;
        if (counter == 0) {
            loop {
                if (counter >= 3) {
                    return;
                } else {
                    if (counter == 1) {
                        // Simulate some operation
                        counter = counter + 1;
                        continue;
                    } else {
                        // When counter == 2
                        counter = counter + 1;
                        // Exit the loop early
                        return;
                    }
                }
            }
        } else {
            assert!(false, 0);
        }
        return;
    }
}

    
//# run 0xA12123::LoopTestModule::run_loop_test --signers 0xA12123