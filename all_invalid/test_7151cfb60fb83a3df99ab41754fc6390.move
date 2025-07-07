//# publish
module 0x50::resource_manager {
    resource struct MyResource has key {
        value: u64,
        data: vector<u8>
    }

    public fun create_resource(account: &signer, initial_value: u64, data: vector<u8>) {
        move_to(account, MyResource { value: initial_value, data })
    }

    public fun get_resource(account: &address): &mut MyResource acquires MyResource {
        &mut borrow_global_mut<MyResource>(move(account))
    }

    // A helper to modify resource in a non-reentrant way
    public fun modify_resource(account: &signer, delta: u64) acquires MyResource {
        let resource_ref = get_resource(&signer::address_of(account));
        resource_ref.value += delta;
        // Simulate some update
    }

    // Callback that modifies resource, to check no reentrancy errors occur
    public fun callback_modify(account: address, delta: u64) acquires MyResource {
        let res = &mut borrow_global_mut<MyResource>(account);
        res.value += delta;
    }

    // A "runner" function to test callback inside resource context
    public fun run_callback(account: &signer, delta: u64) {
        callback_modify(signer::address_of(account), delta)
    }
}

//# publish
module 0x50::test_module {
    use 0x50::resource_manager;

    // Helper function that performs reentrant calls via callback
    public fun reentrant_test(account: &signer, delta: u64) {
        // Create resource first
        resource_manager::create_resource(account, 10, b"abc");
        // Call callback which modifies resource
        resource_manager::run_callback(account, delta);
        // Attempt to modify again outside callback
        resource_manager::modify_resource(account, delta);
    }

    // Runner function to invoke the test
    public fun run_reentrant_test(signer: &signer, delta: u64) {
        reentrant_test(signer, delta)
    }
}

//# run 0x50::test_module::run_reentrant_test --signers 0xA550 --args 5u64