
//# publish
module 0xBADA::TestFeatures {
    use std::signer;
    use std::vector;

    // Struct to hold a map of keys to their lengths plus two
    struct KeyMap has store, key {
        keys: vector<vector<u8>>,
        values: vector<u16>,
    }

    public fun init(s: signer, keys: vector<vector<u8>>, values: vector<u16>) {
        let key_map = KeyMap {
            keys: keys,
            values: values,
        };
        move_to<KeyMap>(&s, key_map);
        // Map initialization is done; calling map manipulation functions for testing
        key_map
    }

    // Function to modify values: add three to each value
    public fun transform_values(map_ref: &mut KeyMap) {
        let len: u64 = vector::length(&map_ref.values);
        let i: u64 = 0;
        loop {
            if (i >= len) {
                break;
            };
            let val: u16 = *vector::borrow(&map_ref.values, i);
            let new_val: u16 = val + 3u16;
            vector::borrow_mut(&mut map_ref.values, i) = new_val;
            i = i + 1;
        };
    }

    // Helper function to access key map by reference
    public fun borrow_key_map(s: signer): &mut KeyMap acquires KeyMap {
        &mut borrow_global_mut<KeyMap>(signer::address_of(&s))
    }

    // Simulate the entire process: initialize, modify, verify
    public fun run_all(s: signer, keys: vector<vector<u8>>, values: vector<u16>) {
        let key_map_ref = borrow_key_map(s);
        transform_values(key_map_ref);
    }
}


//# run 0xBADA::TestFeatures::run_all --signers 0xCAFEE --args [vector[b"key1", "key2"], vector[10u16, 20u16]]


// Featurres:
// 571535d76ec45523fbe6cc5de0eeba0f: Use leading name access for identifiers and addresses in your code
// 627844f84ecfc748b79956e89aeb9bf1: Test that calling the init function correctly maps the KEYS to their lengths plus two and adds three to each value in VALUES without errors.
// 5f869b549fde17cd795d12789f578890: Annotate expressions with types using the colon syntax (e: Type).
