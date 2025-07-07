//# publish
module 0xBADA::TestFeatures {
    use std::signer;
    use std::vector;

    // Struct to hold a map of keys to their lengths plus two
    struct KeyMap has store {
        keys: vector<vector<u8>>,
        values: vector<u16>,
    }

    public fun init(s: &signer, keys: vector<vector<u8>>, values: vector<u16>) {
        let key_map = KeyMap {
            keys: keys,
            values: values,
        };
        move_to<&signer, KeyMap>(&s, key_map);
    }

    // Function to modify values: add three to each value
    public fun transform_values(map_ref: &mut KeyMap) {
        let len: u64 = vector::length(&map_ref.values);
        let i: u64 = 0;
        while (i < len) {
            let val: u16 = *vector::borrow(&map_ref.values, i);
            let new_val: u16 = val + 3u16;
            vector::borrow_mut(&mut map_ref.values, i) = new_val;
            i = i + 1;
        }
    }

    // Helper function to access key map by reference
    public fun borrow_key_map(s: &signer): &mut KeyMap acquires KeyMap {
        &mut borrow_global_mut<KeyMap>(signer::address_of(&s))
    }

    // Simulate the entire process: initialize, modify
    public fun run_all(s: &signer, keys: vector<vector<u8>>, values: vector<u16>) {
        let key_map_ref = borrow_key_map(s);
        transform_values(key_map_ref);
    }
}

// Usage example (for the CLI):
/*
  // run 0xBADA::TestFeatures::run_all --signers 0xCAFEE --args [vector[b"key1", "key2"], vector[10u16, 20u16]]
*/
// Note: Ensure that the test invocation syntax matches the CLI expectations. 
// The args should be interpreted as two vectors: the first a vector of byte vectors, the second a vector of u16s.
