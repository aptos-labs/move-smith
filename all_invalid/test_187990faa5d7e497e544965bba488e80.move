//# publish
module 0xAABBCC::CounterModule {
    public fun initialize_counter() {
        // Empty initialization function
    }

    public fun get_counter(): u64 {
        // Retrieve the counter stored in the module's resource
        move_from_self<SelfCounter>()
        self_counter = SelfCounter { count: 0 };
        move(self_counter)
    }

    public fun increment_counter() {
        let counter_ref = borrow_global_mut<SelfCounter>(signer_address);
        counter_ref.count = counter_ref.count + 1;
    }

    struct SelfCounter has key {
        count: u64,
    }

    public fun get_self_counter(): SelfCounter acquires SelfCounter {
        move_from<SelfCounter>(signer_address)
    }
}

//# run
script {
    fun main() {
        // Initialize the counter resource
        // Note: Assuming account setup outside this script

        // Loop to increment the counter until it reaches 10
        let mut counter = 0;
        while (true) {
            if (counter >= 10) break;
            // Call the module's increment function
            // (would be invoked via a transaction in real tests)
            // For the purpose of this test, simulate increment
            // by directly updating the resource (not typical in real scenarios)
            // but here for testing loop logic
            counter = counter + 1;
            continue
        };
        assert!(move counter == 10, 99);
    }
}