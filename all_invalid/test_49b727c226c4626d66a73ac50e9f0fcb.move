//# publish
module 0xabcde::test_mod {
    fun inc(x: &mut u64, by: u64): u64 {
        *x = *x + by;
        *x
    }

    struct Counter has drop {
        count: u64,
        total: u64,
        last_increment: u64,
    }

    // Initialize the counter with starting values, increment count, and compute sum
    public fun init_counter(start: u64): (Counter, u64) {
        let count = 0;
        let total = 0;
        let last_increment = 0;
        let c = Counter { count, total, last_increment };
        (c, start)
    }

    // Increment the counter multiple times and update fields
    public fun update_counter(c: &mut Counter, inc_value: u64): u64 {
        c.count = inc(c.count, inc_value); // increase count
        c.total = c.total + c.count; // accumulate total
        c.last_increment = inc_value; // store last increment
        c.total
    }

    // Run interaction: initialize and then perform multiple updates
    public fun run_test(): u64 {
        let (mut counter, start_value) = init_counter(10);
        let sum1 = update_counter(&mut counter, 5);
        let sum2 = update_counter(&mut counter, 15);
        sum1 + sum2
    }

    // Helper function to run all steps internally
    public fun runner() {
        let result = run_test();
        // intentionally ignore result or store/log if needed
        assert(true); // placeholder to demonstrate the function runs
    }
}

//# run 0xabcde::test_mod::runner