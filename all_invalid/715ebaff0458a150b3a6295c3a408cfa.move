//# publish
module 0xCAFE::IncrementMap {
    use std::debug;
    use std::option::{Option, some, none};
    use std::vector;

    /// A resource that holds a map from u64 to u64
    resource struct MapHolder {
        map: std::collections::btree_map::BTreeMap<u64, u64>,
    }

    #[inline]
    fun new_map_holder(): MapHolder {
        MapHolder {
            map: std::collections::btree_map::BTreeMap::new(),
        }
    }

    /// Initialize the resource under the specified address
    public fun initialize_account(addr: address) {
        move_to(addr, new_map_holder());
    }

    /// Increment the value for a key in the map if it exists, else insert 1
    public fun increment_value_in_map(addr: address, key: u64) {
        let holder_ref = borrow_global_mut<MapHolder>(addr);
        let existing_value_option = std::collections::btree_map::lookup(&mut holder_ref.map, &key);
        if (exists existing_value_option) {
            let value = copy std::option::some_value(&existing_value_option);
            let new_value = value + 1;
            std::collections::btree_map::insert(&mut holder_ref.map, &key, &new_value);
        } else {
            std::collections::btree_map::insert(&mut holder_ref.map, &key, &1);
        }
    }

    /// Get the value for a key in the map (for testing purposes)
    public fun get_value(addr: address, key: u64): Option<u64> {
        let holder_ref = borrow_global<MapHolder>(addr);
        std::collections::btree_map::lookup(&holder_ref.map, &key)
    }
}

//# run
script {
    fun main(account: signer) {
        // Initialize the resource for account 0xCAFE
        0xCAFE::IncrementMap::initialize_account(&signer::address_of(account));
        // Increment value at key 42
        0xCAFE::IncrementMap::increment_value_in_map(&signer::address_of(account), 42);
        // Increment again to test increment logic
        0xCAFE::IncrementMap::increment_value_in_map(&signer::address_of(account), 42);
        // Increment new key 100
        0xCAFE::IncrementMap::increment_value_in_map(&signer::address_of(account), 100);
    }
}

//# run 0xCAFE::IncrementMap::main --signers 0xCAFE

// Featurres:
// 59201f17162999d5e1ab206c86bdaf65: Increment the value for a key if it already exists in the map.
// 5b21b06461f9c3e8984db547ae8cb06a: Declare function return types, defaulting to '()' if unspecified.
// f3a04639cbf00572c112bac1cda633ed: Define specification functions or native specification functions using the 'fun' or 'native' keywords in spec blocks.
