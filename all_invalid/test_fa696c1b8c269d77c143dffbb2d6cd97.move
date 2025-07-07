//# publish
module 0xabcde::multi_abort_test {
    public fun abort_in_loop(limit: u64): u64 {
        let mut sum = 0;
        let mut i = 0;
        while (i < limit) {
            // Attempt to abort with a value based on i
            abort i;
            i = i + 1;
        }
        sum
    }

    public fun continue_after_abort(offset: u64): u64 {
        let mut total = 10;
        let mut counter = 0;
        while (counter < 5) {
            // Abort with a value that depends on offset
            abort offset + counter;
            // This line should be unreachable if aborting works as intended
            total = total + 1;
            counter = counter + 1;
        }
        total
    }

    public fun final_result(x: u64, y: u64): u64 {
        // Perform some computation after multiple aborts
        x + y
    }

    // Runner to test multiple aborts and continued execution
    public fun run_test(): u64 {
        let res1 = abort_in_loop(3);
        let res2 = continue_after_abort(20);
        final_result(res1, res2)
    }
}

//# run 0xabcde::multi_abort_test::run_test