//# publish
module 0x99::global_resource_access {
    struct Counter has key {
        count: u64,
    }

    // Initialize the Counter resource under the signer's account
    fun init_counter(s: &signer) {
        move_to(s, Counter { count: 0 });
    }

    // Read current count value
    fun get_count(addr: address): u64 {
        borrow_global<Counter>(addr).count
    }

    // Check existence of Counter resource
    fun has_counter(addr: address): bool {
        exists<Counter>(addr)
    }

    // Increment the count by 1
    fun increment(s: &signer): bool {
        let counter_ref = borrow_global_mut<Counter>(signer_address_of(s));
        counter_ref.count = counter_ref.count + 1;
        true
    }

    // Decrement the count by 1 (with error if zero)
    fun decrement(s: &signer): bool {
        let counter_ref = borrow_global_mut<Counter>(signer_address_of(s));
        assert!(counter_ref.count > 0, 42); // error code 42
        counter_ref.count = counter_ref.count - 1;
        true
    }

    // Try to borrow_mut the Counter resource, returning an error if not exists
    fun safe_borrow_mut(addr: address): bool {
        if (exists<Counter>(addr)) {
            let _counter_mut_ref = borrow_global_mut<Counter>(addr);
            true
        } else {
            false
        }
    }

    // Remove the Counter resource
    fun remove_counter(s: &signer): bool {
        move_from<Counter>(signer_address_of(s));
        true
    }
}

//# run --verbose --signers 0xA -- 0x99::global_resource_access::init_counter
//# run --verbose -- 0x99::global_resource_access::has_counter --args 0xA
//# run --verbose --signers 0xA -- 0x99::global_resource_access::increment
//# run --verbose --args 0xA -- 0x99::global_resource_access::get_count
//# run --verbose --signers 0xA -- 0x99::global_resource_access::decrement
//# run --verbose --args 0xA -- 0x99::global_resource_access::has_counter
//# run --verbose --signers 0xA -- 0x99::global_resource_access::remove_counter
//# run --verbose --args 0xA -- 0x99::global_resource_access::has_counter
//# run --verbose --args 0xA -- 0x99::global_resource_access::safe_borrow_mut
