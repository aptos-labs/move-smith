
//# publish
module 0xCAFE::MapModule {
    use std::vector;
    use std::option;
    use std::hash;

    // Key: u64
    // Value: u64
    struct Map has key {
        inner: vector<(u64, u64)>,
    }

    public fun init_map(): Map {
        Map { inner: vector::empty() }
    }

    public fun get_or_init(map: &mut Map, key: u64): u64 {
        let len = vector::length(&map.inner);
        let i = 0;
        while (i < len) {
            let (k, v) = *vector::borrow(&map.inner, i);
            if (k == key) {
                return v;
            };
            i = i + 1;
        };
        // Key not found, initialize with 1
        vector::push_back(&mut map.inner, (key, 1));
        1
    }

    public fun set_value(map: &mut Map, key: u64, value: u64) {
        let len = vector::length(&map.inner);
        let i = 0;
        while (i < len) {
            let (k, _) = *vector::borrow(&map.inner, i);
            if (k == key) {
                *vector::borrow_mut(&mut map.inner, i) = (k, value);
                return;
            };
            i = i + 1;
        };
        // Key not found, insert with value
        vector::push_back(&mut map.inner, (key, value));
    }
}


//# run 0xCAFE::MapModule::init_map --args 

//# run 0xCAFE::MapModule::get_or_init --args 42u64

//# run 0xCAFE::MapModule::set_value --args 42u64 100u64

//# run 0xCAFE::MapModule::get_or_init --args 42u64

// Featurres:
// bfaf18604daf2a7a1f0d7329aeda4392: Use the '::' syntax to specify the namespace of a module after an address in a module identifier.
// f5aa7ac54063febf350e6a0e16c6871d: Create specification functions with the `fun` or `native` keywords.
// 996b314a17f4fed53032b52b753c5c91: Automatically initialize a counter to 1 if its key is missing in the map
