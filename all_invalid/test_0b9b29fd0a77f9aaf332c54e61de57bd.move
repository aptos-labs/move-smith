//# publish
module 0xA11CE::ResourceTest {

    // Define a global resource holding a counter
    struct Counter has key {
        count: u64,
    }

    // Initialize the Counter resource
    public fun init_counter(account: &signer) {
        move_to(account, Counter { count: 42 });
    }

    // Read the current value of the Counter resource
    public fun get_counter(): u64 acquires Counter {
        borrow_global<Counter>(@0xA11CE).count
    }

    // Increment the counter
    public fun increment_counter() acquires Counter {
        let counter_ref = borrow_global_mut<Counter>(@0xA11CE);
        counter_ref.count = counter_ref.count + 1;
    }

    // Helper function to read and increment inside a transaction
    public fun read_and_increment(): u64 acquires Counter {
        let current = get_counter();
        increment_counter();
        current
    }

    //# run 0xA11CE::ResourceTest::init_counter --signers 0xA11CE

    //# run 0xA11CE::ResourceTest::read_and_increment --signers 0xA11CE

    //# run 0xA11CE::ResourceTest::get_counter --signers 0xA11CE



    //# publish
module 0xBEEF::ShadowTest {

    // Function that shadows outer variable via lambda parameter
    public inline fun shadowing_example(f:|u64|) {
        let outer_value = 5;
        f(outer_value);
    }

    public fun test_shadow() {
        let mut result = 0;
        shadowing_example(|val: u64| {
            result = val; // Should assign 5
        });
        // The result should be 5 after execution
        assert!(result == 5, 0);
    }
}
//# run 0xBEEF::ShadowTest::test_shadow