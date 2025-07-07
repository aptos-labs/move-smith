//# publish
module 0xabcde::counter {
    // Initialize the counter to zero
    resource struct Counter {
        value: u64,
    }

    // Publish the resource under the signer
    public fun initialize(account: &signer) {
        move_to(account, Counter { value: 0 });
    }

    // Increment function to increase counter by 'by' and return new value
    public fun inc(counter_ref: &mut Counter, by: u64): u64 {
        counter_ref.value = counter_ref.value + by;
        counter_ref.value
    }

    // Function to get current counter value
    public fun get(counter_ref: &Counter): u64 {
        counter_ref.value
    }

    // Test function that performs multiple increments and computes a sum
    public fun test(): u64 {
        let account = get_signer();
        // Initialize counter
        initialize(&account);
        // Borrow mutable reference to Counter resource
        let counter_ref = borrow_global_mut<Counter>(Signer::address_of(&account));
        // Perform several increments
        let sum = 0;
        let sum = sum + inc(&mut *counter_ref, 5);
        let sum = sum + inc(&mut *counter_ref, 10);
        let sum = sum + inc(&mut *counter_ref, 3);
        // Return the total sum
        sum
    }

    // Runner function to initialize the counter for testing
    public fun run_initializer() {
        let account = get_signer();
        initialize(&account);
    }
}

//# run 0xabcde::counter::test