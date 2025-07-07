//# publish
module 0xabcde::assignment_loop_tests {

    // Test that a move function performs sequential assignments and uses the updated value in an arithmetic operation
    public fun sequential_assignments(): u64 {
        let x = 5;
        let y = {
            // update x
            let x = x + 2;
            // use updated x in computation
            x * 2
        };
        y + { 
            // further update after y is computed
            let y = y + 3;
            y
        }
    }
    
    // Test that a for loop iterates correctly over the range 0..=10 and sum the values
    public fun sum_range(): u64 {
        let mut total = 0;
        for (i in 0..=10) {
            total = total + i;
        }
        total
    }

    // Optional: a runner function that calls both tests
    public fun run_all(): () {
        let sum_result = sequential_assignments();
        let range_sum = sum_range();
        // Could publish or log results if needed
    }
}

//# run 0xabcde::assignment_loop_tests::run_all