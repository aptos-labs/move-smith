//# publish
module 0xabcde::abort_test {
    public fun multiple_aborts(x: u64): u64 {
        let mut total: u64 = 0;
        let mut counter: u64 = 0;

        // First abort in loop
        while (counter < 3) {
            if (counter == 0) {
                abort x + 10;
            }
            // This line should be skipped if an abort occurs
            total = total + 1;
            // Second abort, to test multiple aborts in sequence
            if (counter == 1) {
                abort x + 20;
            }
            // This line should be skipped if abort occurs
            total = total + 2;
            counter = counter + 1;
        }

        // Final addition if no abort
        total + x
    }

    // Runner function to test the aborts and ensure continuation
    public fun run_multiple_aborts() : u64 {
        // Call with a sample value; expect aborts to interrupt flow
        multiple_aborts(5)
    }
}

//# run 0xabcde::abort_test::run_multiple_aborts