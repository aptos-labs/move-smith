// Fixed Transactional Test code for Aptos Move

//# publish
module 0x1::TestModule {
    use std::signer;
    use std::vector;
    use std::error;

    /// Example function to test.
    public fun test_function(account: &signer) acquires SomeResource {
        // Initialize resource
        let resource = SomeResource { value: 42 };
        // Store resource under signer
        move_to(account, resource);
        // Validate resource
        let retrieved = borrow_global::<SomeResource>(signer::address_of(account));
        assert!(retrieved.value == 42, 1);
    }
}

struct SomeResource {
    value: u64,
}
