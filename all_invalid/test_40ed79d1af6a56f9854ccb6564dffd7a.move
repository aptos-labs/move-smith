//# publish
module 0xA::resource_scope_tests {
    /// Defines a global resource with a specific address scope.
    struct GlobalResource has key {
        owner: address,
    }

    /// Initializes the resource under the signer's account.
    fun init_resource(s: &signer) {
        move_to(s, GlobalResource { owner: signer::address_of(s) });
    }

    /// Borrow the global resource at a specified address in a read-only manner.
    fun borrow_resource_at(addr_ref: &option<address>): bool reads 0xA::resource_scope_tests::GlobalResource {
        if (option::is_none(addr_ref)) {
            abort 1;
        }
        let addr = option::extract(addr_ref);
        // Attempt to borrow globally, considering address scope and ownership rules.
        // The borrow_global<T>(@addr) call should succeed only if caller owns the resource
        // or if the address is the same as the resource owner.
        borrow_global<GlobalResource>(@addr)
            .owner == signer::address_of(&signer) // For test, check if caller owns resource at the address
        // Note: For the purpose of this test, we mock the condition.
    }

    /// Attempt to borrow resource with invalid address scope, expecting failure.
    fun borrow_invalid_scope(addr_ref: &option<address>) acquires 0xA::resource_scope_tests::GlobalResource {
        if (option::is_none(addr_ref)) {
            abort 1;
        }
        let addr = option::extract(addr_ref);
        // This should abort because address is outside scope or resource not owned.
        // These calls will be tested to ensure failure.
        borrow_global<GlobalResource>(@addr)
    }

    /// Helper function to get a valid resource owner's address.
    fun get_owner_address(s: &signer): address {
        signer::address_of(s)
    }
}

//# run --verbose --signers 0x1 -- 0xA::resource_scope_tests::init_resource

//# run --verbose -- --args 0x1 -- 0xA::resource_scope_tests::borrow_resource_at @0x1
//# run --verbose -- --args 0x2 -- 0xA::resource_scope_tests::borrow_resource_at @0x2
//# run --verbose -- --args 0x3 -- 0xA::resource_scope_tests::borrow_resource_at @0x3

//# run --verbose --signers 0x1 -- 0xA::resource_scope_tests::init_resource

//# run --verbose -- --args 0x1 -- 0xA::resource_scope_tests::borrow_invalid_scope @0x2
//# run --verbose -- --args 0x2 -- 0xA::resource_scope_tests::borrow_invalid_scope @0x3