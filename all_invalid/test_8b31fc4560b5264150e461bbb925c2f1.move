//# publish
module 0x1234::TestModule {
    fun compute_sum(decreasing_start: u64): (u64, u64) {
        let sum = decreasing_start; // Initialize sum with starting value
        let total_accum = 0; // Accumulator for sum of decrements
        let mut current = decreasing_start;
        while (current > 1) {
            current = current - 1;
            total_accum = total_accum + current;
            sum = sum + current;
        }
        (sum, total_accum)
    }

    public fun run_test(input_value: u64): (u64, u64) {
        compute_sum(input_value)
    }
}

//# run 0x1234::TestModule::run_test --args 15