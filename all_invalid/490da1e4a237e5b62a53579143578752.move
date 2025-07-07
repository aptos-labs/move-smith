
//# publish
module 0xCAFE::MapModule {
    use std::vector;

    // Key: u64
    // Value: u64
    struct Map has key {
        inner: vector<(u64, u64)>,
    }

    public fun init_map(): Map {
        Map { inner: vector::empty<(u64, u64)>() }
    }

    public fun get_or_init(map: &mut Map, key: u64): u64 {
        let len = vector::length<&(u64, u64)>(&map.inner);
        let i = 0;
        while (i < len) {
            let (k, v) = *vector::borrow<&(u64, u64)>(&map.inner, i);
            if (k == key) {
                return v;
            };
            i = i + 1;
        };
        // Key not found, insert with initial value 1
        vector::push_back(&mut map.inner, (key, 1));
        1
    }

    public fun set_value(map: &mut Map, key: u64, value: u64) {
        let len = vector::length<&(u64, u64)>(&map.inner);
        let i = 0;
        while (i < len) {
            let (k, _) = *vector::borrow<&(u64, u64)>(&map.inner, i);
            if (k == key) {
                *vector::borrow_mut<&mut (u64, u64)>(&mut map.inner, i) = (k, value);
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