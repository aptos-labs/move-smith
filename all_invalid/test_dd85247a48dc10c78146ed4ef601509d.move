//# publish
module 0xAABBCC::MutableStructTest {
    struct Counter has store {
        count: u64
    }

    public fun new(): Counter {
        Counter { count: 0 }
    }

    public fun get_count(c: &Counter): u64 {
        c.count
    }

    public fun increment(c: &mut Counter): u64 {
        c.count = c.count + 2;
        c.count
    }
}

//# publish
module 0xAABBCC::TestInteraction {
    use 0xAABBCC::MutableStructTest;

    // Helper function to perform multiple increments
    public fun run_increments(counter: &mut MutableStructTest::Counter, times: u64): u64 {
        let mut i = 0;
        let mut last_value = 0;
        while (i < times) {
            last_value = MutableStructTest::increment(counter);
            i = i + 1;
        }
        last_value
    }

    // Function that calls the mutator repeatedly and checks the value
    public fun test_repeated_mutation(addr: address) {
        let counter = &mut MutableStructTest::new();

        // Perform 5 increments
        let final_value = Self::run_increments(counter, 5);
        // The expected value is initial 0 + 2 * 5 = 10
        assert!(final_value == 10, 70003);

        // Check that the internal count matches the expected value
        assert!(MutableStructTest::get_count(counter) == 10, 70004);
    }
}

//# run 0xAABBCC::TestInteraction::test_repeated_mutation --signers 0xAABBCC