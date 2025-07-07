//# publish
module 0x1::test_module {

    // Top-level spec block as a placeholder for potential multiple specs
    spec {
        // This could contain spec definitions or functions
    }

    use std::debug;

    // Function to demonstrate retrieval of attribute location in source code
    public fun get_attribute_location() acquires  {
        // In Move, attribute locations are not exposed at runtime.
        // Instead, we simulate this by defining a custom annotation and referencing its location.
        // For demonstration, we simply print a message.
        debug::print(&"Attribute location in source code is not directly accessible in Move");
    }

    // A simple module to test keys and map behaviors
    struct SimpleMap has key {
        map: vector<(u64, u64)>,
    }

    public fun new_simple_map(): SimpleMap {
        let map = vector::empty<(u64, u64)>();
        // Insert multiple elements with identical keys
        vector::push_back(&mut map, (10, 100));
        vector::push_back(&mut map, (20, 200));
        vector::push_back(&mut map, (10, 300));
        vector::push_back(&mut map, (30, 400));
        SimpleMap { map }
    }

    // Function to retrieve all keys from the SimpleMap
    public fun keys(map: &SimpleMap): vector<u64> {
        let mut keys_vec = vector::empty<u64>();
        let length = vector::length(&map.map);
        let mut i = 0;
        while (i < length) {
            let entry = vector::borrow(&map.map, i);
            vector::push_back(&mut keys_vec, entry.0);
            i = i + 1;
        }
        keys_vec
    }

    // Runner function to test keys extraction with duplicate keys
    public fun run_keys_test() {
        let smap = new_simple_map();
        let all_keys = keys(&smap);
        debug::print(&all_keys);
    }
}

//# run 0x1::test_module::run_keys_test