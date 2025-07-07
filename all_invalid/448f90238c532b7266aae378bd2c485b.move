//# publish
module 0xCAFE::TestModule {
    // A simple struct to hold mutable state
    struct Counter has key {
        value: u64,
    }

    // Initialize the Counter resource under an address
    public fun init_counter(account: &signer) {
        move_to(account, Counter { value: 0 });
    }

    // Function to get current value of the counter
    public fun get_value(counter_ref: &Counter): u64 {
        counter_ref.value
    }

    // Function to increment the counter by a given amount
    public fun increment(counter_ref: &mut Counter, amount: u64) {
        counter_ref.value = counter_ref.value + amount;
    }

    // Function that modifies the counter via a mutable reference and returns a bool
    public fun update_and_check(counter_ref: &mut Counter): bool {
        // Increment value
        counter_ref.value = counter_ref.value + 10;

        // Return true if the value is greater than 100
        if (counter_ref.value > 100) {
            true
        } else {
            false
        }
    }

    // Function that contains a loop based on update_and_check
    public fun loop_and_update(account: &signer) {
        // borrow global as mutable
        let counter_ref = borrow_global_mut<Counter>(Signer::address_of(account));
        let mut counter = *counter_ref;

        // Loop until update_and_check returns true
        while (!update_and_check(&mut counter)) {
            // Increment by 30 each iteration
            increment(&mut counter, 30);
        }

        // Save the final state
        move_to(account, counter);
    }
}

//# run 0xCAFE::TestModule::init_counter --signers 0xCAFE
//# run 0xCAFE::TestModule::loop_and_update --signers 0xCAFE