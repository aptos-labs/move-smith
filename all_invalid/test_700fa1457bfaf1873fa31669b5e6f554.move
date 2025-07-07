//# publish
module 0xabc::calculator {
    /// Adds two u64 numbers
    public fun add(a: u64, b: u64): u64 {
        a + b
    }

    /// Performs a complex expression involving addition and triggers an abort intentionally
    public fun compute_and_abort(): u64 {
        let result = {20u64 + 30u64} + {abort 99; 50u64};
        result
    }

    /// Runner to test compute_and_abort without arguments
    public fun run_abort_test(): u64 {
        compute_and_abort()
    }
}

//# run 0xabc::calculator::run_abort_test --args

//# publish
module 0xabc::resource_manager {
    struct DataResource has key {
        value: u64,
    }

    public fun initialize(s: &signer) {
        move_to(s, DataResource { value: 0 });
    }

    public fun increase(s: &signer, amount: u64) acquires DataResource {
        let res = borrow_global_mut<DataResource>(Signer::address_of(s));
        res.value = res.value + amount;
    }
}

//# publish
module 0xabc::nested_operations {
    use 0xabc::resource_manager;

    /// Function to simulate nested resource manipulations with different modules
    public fun nested_update(s: &signer) {
        // Initialize resources
        resource_manager::initialize(s);
        // First update
        resource_manager::increase(s, 10);
        // Simulate nested call across modules
        perform_external_update(s);
        // Another nested call
        external_resource::modify(s);
    }

    fun perform_external_update(s: &signer) {
        resource_manager::increase(s, 20);
    }
}

module 0xabc::external_resource {
    use 0xabc::resource_manager;

    public fun modify(s: &signer) acquires resource_manager::DataResource {
        resource_manager::increase(s, 5);
    }
}

//# run 0xabc::nested_operations::nested_update --signers 0xabc