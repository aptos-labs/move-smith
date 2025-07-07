//# publish
module 0xabc123::SumLoop {
    fun compute_sum(initial_value: u64): u64 {
        let total = initial_value; // Initialize total with the provided initial value
        let counter = 10; // Set starting point for sum decrementing from 10
        let sum = 0; // Sum accumulator
        while (counter > 0) {
            sum = sum + counter; // Add current counter to sum
            counter = counter - 1; // Decrement counter
        };
        total + sum // Combine initial value with sum of 10 down to 1
    }

    public fun run_test(): u64 {
        compute_sum(0) // Expected: 55
    }

    public fun run_test_with_initial(): u64 {
        compute_sum(10) // Expected: 65
    }
}

//# run 0xabc123::SumLoop::run_test
//# run 0xabc123::SumLoop::run_test_with_initial