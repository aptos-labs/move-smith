//# publish
module 0x0a1b2c::counter_module {
    // Mutable variable encapsulation
    resource struct Counter {
        count: u64,
    }

    // Initialize counter with zero
    public fun init_counter(account: &signer): Counter {
        let counter = Counter { count: 0 };
        move_to(account, counter);
        counter
    }

    // Increment the counter by a given value
    public fun increment(counter_ref: &mut Counter, value: u64) {
        counter_ref.count = counter_ref.count + value;
    }

    // Retrieve current value
    public fun get_counter(counter_ref: &Counter): u64 {
        counter_ref.count
    }

    // Perform multiple increments internally
    public fun perform_multiple_increments(account: &signer, increments: vector<u64>) {
        // Borrow the counter resource
        let counter_ref = borrow_global_mut<Counter>(signer::address_of(account));
        for increment_value in &increments {
            increment(counter_ref, *increment_value);
        }
    }
}

//# run 0x0a1b2c::counter_module::init_counter --signers 0xabc
// Initialize the counter for testing

//# run 0x0a1b2c::counter_module::perform_multiple_increments --signers 0xabc --args ['vector[64]/u64','[10, 15, 20]']

//# run 0x0a1b2c::counter_module::get_counter --signers 0xabc
/// Retrieve the counter's value after multiple increments to verify accumulation