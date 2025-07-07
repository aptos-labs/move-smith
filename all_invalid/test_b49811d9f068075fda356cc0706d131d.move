//# publish
module 0x1234::Counter {
    fun initialize_counter() {
        // Initialize the counter resource for the address
        move_to(&signer, Counter { count: 0 })
    }

    fun increment() {
        let counter_ref = borrow_global_mut<Counter>(@0x1234);
        counter_ref.count = counter_ref.count + 1;
    }

    fun get_count(): u64 {
        let counter_ref = borrow_global<Counter>(@0x1234);
        counter_ref.count
    }

    // Utility function for tests
    public fun run_test_sequence() {
        Self::initialize_counter();
        let mut total = 0;
        let mut i = 0;
        // Increment counter 5 times and sum the total
        while (i < 5) {
            Self::increment();
            total = total + Self::get_count();
            i = i + 1;
        };
        total
    }

    resource struct Counter {
        count: u64,
    }
}

//# run 0x1234::Counter::run_test_sequence