//# publish
module 0x1::CounterModule {
    // Initialize the counter resource
    resource struct Counter {
        value: u64,
    }

    // Publish the Counter resource under the account
    public fun init(account: &signer) {
        move_to(account, Counter { value: 0 });
    }

    // Increment the counter by 1
    public fun increment(counter_ref: &mut Counter) {
        counter_ref.value = counter_ref.value + 1;
    }

    // Get current value
    public fun get_value(counter_ref: &Counter): u64 {
        counter_ref.value
    }
}

//# run
script {
    fun main() {
        let deployer = @0x1;
        // Initialize the counter resource
        let signer_ref = &signer deployer;
        // (Assume the deployer account already exists)
        // Initialize counter
        CounterModule::init(signer_ref);
        
        // Borrow the resource and perform the loop
        let counter_ref = borrow_global_mut<CounterModule::Counter>(deployer);
        let mut x = 0u64;
        while (true) {
            if (x >= 5) break;
            CounterModule::increment(counter_ref);
            x = x + 1;
        };
        // Assert that counter value matches number of increments
        let final_value = CounterModule::get_value(counter_ref);
        assert!(final_value == 5, 100);
    }
}