//# publish
module 0xCAFE::GenericRegistry {
    use std::signer;
    use std::vector;
    use std::option;

    struct Registry<T> has store, key {
        owner: address,
        items: vector<T>,
    }

    public fun create_registry<T>(account: &signer) {
        let owner_addr = signer::address_of(account);
        let registry = Registry<T> {
            owner: owner_addr,
            items: vector::empty<T>(),
        };
        move_to<Registry<T>>(account, registry);
    }

    public fun add_item<T>(account: &signer, item: T) {
        let owner_addr = signer::address_of(account);
        let registry_ref = borrow_global_mut<Registry<T>>(owner_addr);
        vector::push_back(&mut registry_ref.items, item);
    }

    public fun contains_item<T: copy + drop + store + partial_eq>(account: &signer, item: T): bool {
        let owner_addr = signer::address_of(account);
        let registry_ref = borrow_global<Registry<T>>(owner_addr);
        vector::any(&registry_ref.items, |x| *x == item)
    }

    public fun length<T>(account: &signer): u64 {
        let owner_addr = signer::address_of(account);
        let registry_ref = borrow_global<Registry<T>>(owner_addr);
        vector::length(&registry_ref.items)
    }

    public fun remove_last<T>(account: &signer): option::Option<T> {
        let owner_addr = signer::address_of(account);
        let registry_ref = borrow_global_mut<Registry<T>>(owner_addr);
        if (vector::length(&registry_ref.items) > 0) {
            option::some(vector::pop_back(&mut registry_ref.items))
        } else {
            option::none<T>()
        };
    }

    public fun exists<T>(account: address): bool {
        exists<Registry<T>>(account)
    }

    // A "runner" function to test generic registry with u8 type
    public fun test_runner(account: &signer) {
        create_registry<u8>(account);
        add_item<u8>(account, 10u8);
        add_item<u8>(account, 20u8);
        let _has_10 = contains_item<u8>(account, 10u8);
        let length_before = length<u8>(account);
        let _removed_item = remove_last<u8>(account);
        let length_after = length<u8>(account);

        // no return value, just to exercise usage
        let _exists = exists<u8>(signer::address_of(account));
        ();
    }
}

//# run 0xCAFE::GenericRegistry::test_runner --signers 0xBEEF

//# run 0xCAFE::GenericRegistry::create_registry<u64> --signers 0xCAFE
//# run 0xCAFE::GenericRegistry::add_item<u64> --signers 0xCAFE --args 123u64
//# run 0xCAFE::GenericRegistry::contains_item<u64> --signers 0xCAFE --args 123u64
//# run 0xCAFE::GenericRegistry::length<u64> --signers 0xCAFE
//# run 0xCAFE::GenericRegistry::remove_last<u64> --signers 0xCAFE
//# run 0xCAFE::GenericRegistry::exists<u64> --args 0xCAFE

// Featurres:
// 649533cb9c7559bb985c95ba8ec28fa9: Apply model AST lint checks for conformance to best practices
// 4ca8ffd29af511d66e3a78ca3cca731a: Declare use statements to import modules or their members in Move code
// 2d957171cf5a5296383f9397a46e1b89: Test that storing, retrieving, verifying existence, and removing custom structs associated with an account works correctly using generic registry modules.
