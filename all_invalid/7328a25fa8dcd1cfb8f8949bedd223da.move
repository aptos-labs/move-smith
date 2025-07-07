
//# publish
module 0xCAFE::TestIncrement {
    public fun test_increment_bound(): u64 {
        let bound = 5u64;
        let sum = 0u64;
        for (i in 0..bound) {
            sum = sum + i;
            // Increment bound inside loop body, should affect range upper bound
            bound = bound + 1;
        };
        sum
    }

    /// Dummy function to simulate inspection of live intervals at specific offsets
    /// Returns sum of dummy offsets and their variable ids for demonstration
    public fun inspect_live_intervals(): u64 {
        // These offsets represent instruction offsets hypothetically
        let offset0 = 0u64;
        let offset1 = 5u64;
        let offset2 = 10u64;

        // Dummy variables count per offset (pretend live intervals info)
        let live_vars_at_offset0 = 3u64;
        let live_vars_at_offset1 = 5u64;
        let live_vars_at_offset2 = 1u64;

        offset0 + live_vars_at_offset0 + offset1 + live_vars_at_offset1 + offset2 + live_vars_at_offset2
    }

    public fun fib(n: u8): u64 {
        if (n == 0u8) {
            0u64
        } else if (n == 1u8) {
            1u64
        } else {
            let a = fib(n - 1u8);
            let b = fib(n - 2u8);
            a + b
        }
    }

    public fun run_fib_tests(): vector<u64> {
        let results = vector::empty<u64>();
        for (i in 0..11u8) {
            let val = fib(i);
            vector::push_back(&mut results, val);
        };
        results
    }
}


//# run 0xCAFE::TestIncrement::test_increment_bound


//# run 0xCAFE::TestIncrement::inspect_live_intervals


//# run 0xCAFE::TestIncrement::run_fib_tests


// Featurres:
// 1dec5c66511277dc1fea4fb4dcc37299: Test that the increment of a mutable reference inside a for loop range expression correctly affects the loop bound and subsequent variable values.
// f67ace54097c00c4d91e1a438cc44ced: Inspect the live intervals of variables at specific code offsets in a function for debugging or analysis purposes.
// 2e0f7505fb6bdec39ceb8f8817fa5519: Verify that the recursive function fib correctly computes the nth Fibonacci number for values from 0 to 10.
