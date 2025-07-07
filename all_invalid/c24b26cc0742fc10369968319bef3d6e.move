//# publish
module 0xCAFE::IncrementMap {
    use std::debug;
    use std::option::{Option, some, none};
    use std::vector;
    use std::signer; // Added signer module import
    use std::collections::btree_map;

    /// A resource that holds a map from u64 to u64
    resource struct MapHolder {
        map: btree_map::BTreeMap<u64, u64>,
    }

    #[inline]
    fun new_map_holder(): MapHolder {
        MapHolder {
            map: btree_map::BTreeMap::new(),
        }
    }

    /// Initialize the resource under the specified address
    public fun initialize_account(addr: address) {
        move_to(addr, new_map_holder());
    }

    /// Increment the value for a key in the map if it exists, else insert 1
    public fun increment_value_in_map(addr: address, key: u64) {
        let holder_ref = borrow_global_mut<MapHolder>(addr);
        let existing_value_option = btree_map::lookup(&mut holder_ref.map, &key);
        if (option::is_some(&existing_value_option)) {
            let value = option::extract(&existing_value_option);
            let new_value = value + 1;
            btree_map::insert(&mut holder_ref.map, &key, &new_value);
        } else {
            btree_map::insert(&mut holder_ref.map, &key, &1);
        }
    }

    /// Get the value for a key in the map (for testing purposes)
    public fun get_value(addr: address, key: u64): Option<u64> {
        let holder_ref = borrow_global<MapHolder>(addr);
        btree_map::lookup(&holder_ref.map, &key)
    }

    // Optional: Define a helper function for the test script to call instead of direct access.
    public fun main(account_signer: &signer) {
        initialize_account(signer::address_of(account_signer));
        increment_value_in_map(signer::address_of(account_signer), 42);
        increment_value_in_map(signer::address_of(account_signer), 42);
        increment_value_in_map(signer::address_of(account_signer), 100);
    }
}

//# run
script {
    fun main(account: &signer) {
        0xCAFE::IncrementMap::main(account);
    }
}

//# run 0xCAFE::IncrementMap::main --signers 0xCAFE