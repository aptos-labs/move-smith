//# publish
module 0x42::m_interaction {

    struct Counter has drop {
        count: u64,
        frozen_ref: &mut u64,
        mutable_ref: &mut u64,
    }

    fun initialize_counter(c: &mut Counter) {
        c.count = 0;
        c.frozen_ref = &mut c.count;
        c.mutable_ref = &mut c.count;
    }

    fun increment_counter(c: &mut Counter): u64 {
        // Use mutable reference to increase count
        *c.mutable_ref = *c.mutable_ref + 10;
        c.count
    }

    fun get_counter_value(c: &Counter): u64 {
        // Access via shared reference
        c.count
    }

    fun test_increment_and_access(): u64 {
        let mut c = Counter {
            count: 0,
            frozen_ref: &mut 0,
            mutable_ref: &mut 0,
        };
        initialize_counter(&mut c);
        let val1 = get_counter_value(&c);
        let val2 = increment_counter(&mut c);
        let val3 = get_counter_value(&c);
        // Sum the values to verify correct updates
        val1 + val2 + val3
    }

    // Runner function to execute the test
    public fun run_test(): u64 {
        test_increment_and_access()
    }
}

//# run 0x42::m_interaction::run_test