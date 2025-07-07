//# publish
module 0xABC::loop_continue_break_test {
    public fun run_loop_with_condition() {
        let x = 0;
        let y = 0;
        loop {
            if (x >= 15) {
                break;
            }
            if (x % 3 == 0) {
                // Skip multiples of 3
                x = x + 1;
                continue;
            }
            if (x % 2 == 0) {
                // Skip even numbers
                x = x + 1;
                continue;
            }
            // Add odd numbers not divisible by 3
            y = y + x;
            x = x + 1;
        }
        // Expect y to be the sum of all odd numbers less than 15 that are not divisible by 3:
        // These are 1, 5, 7, 11, 13, sum = 1+5+7+11+13 = 37
        assert!(y == 37, 42);
    }

    public fun run_until_limit() {
        let x = 0;
        let y = 0;
        loop {
            if (x >= 10) {
                break;
            }
            x = x + 2; // Increment by 2
            if (x == 4 || x == 8) {
                continue;
            }
            y = y + x;
        }
        // x values that contribute: 2, 6, 10
        // Sum: 2+6+10=18
        assert!(y == 18, 42);
    }
}

//# run 0xABC::loop_continue_break_test::run_loop_with_condition
//# run 0xABC::loop_continue_break_test::run_until_limit --signers 0x1 --args