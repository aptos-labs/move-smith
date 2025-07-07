//# publish
module 0xCAFE::GenericMap {
    use std::vector;
    use std::error;

    /// A generic map-like data structure with keys and values stored in parallel vectors
    struct Map<K: copy + drop + store + key, V: store> has store {
        keys: vector<K>,
        values: vector<V>,
    }

    /// Initialize an empty map
    public fun init_map<K: copy + drop + store + key, V: store>(): Map<K, V> {
        Map {
            keys: vector::empty<K>(),
            values: vector::empty<V>(),
        }
    }

    /// Insert a key-value pair into the map; if key exists, replace the value
    public fun insert<K: copy + drop + store + key, V: store>(map: &mut Map<K, V>, key: K, value: V) {
        let len = vector::length(&map.keys);
        let mut i = 0;
        while (i < len) {
            if (*vector::borrow(&map.keys, i) == key) {
                // Correct usage to mutate vector element:
                vector::borrow_mut(&mut map.values, i).copy_from(&value);
                return;
            };
            i = i + 1;
        };
        vector::push_back(&mut map.keys, key);
        vector::push_back(&mut map.values, value);
    }

    /// Retrieve a vector of keys transformed by a generic function f
    public fun keys_map<K: copy + drop + store + key, V: store, R: copy + drop + store>(
        map: &Map<K, V>,
        f: &fun(K): R
    ): vector<R> {
        let keys_ref = &map.keys;
        let len = vector::length(keys_ref);
        let mut result = vector::empty<R>();
        let mut i = 0;
        while (i < len) {
            let key = *vector::borrow(keys_ref, i);
            let mapped = f(key);
            vector::push_back(&mut result, mapped);
            i = i + 1;
        };
        result
    }

    /// Returns the number of keys in the map
    public fun size<K: copy + drop + store + key, V: store>(map: &Map<K, V>): u64 {
        vector::length(&map.keys)
    }

    /// Function to test keys_map with a specific mapping function
    public fun test_keys_map(): vector<u8> {
        let mut map = init_map<u8, u8>();
        insert(&mut map, 1u8, 10u8);
        insert(&mut map, 2u8, 20u8);
        insert(&mut map, 3u8, 30u8);

        let lambda: fun(u8): u8 = fun(k: u8): u8 { k + 1u8 };

        keys_map(&map, &lambda)
    }
}

/// Functions to test quantified expressions (forall/exists)
/// Note: Move does not have native quantifiers; simulate using loops and conditions

/// Return true if forall i in 0..len, predicate(i) holds
public fun forall(len: u64, predicate: &fun(u64): bool): bool {
    let mut i = 0;
    while (i < len) {
        if (!(predicate(i))) { return false; };
        i = i + 1;
    };
    true
}

/// Return true if exists i in 0..len, predicate(i) holds
public fun exists(len: u64, predicate: &fun(u64): bool): bool {
    let mut i = 0;
    while (i < len) {
        if (predicate(i)) { return true; };
        i = i + 1;
    };
    false
}

/// Test quantifiers with witness expressions and conditions
public fun test_quantifiers(): (bool, bool) {
    let len = 5u64;

    let all_less_than_ten = forall(len, &fun(i: u64): bool {
        i < 10
    });
    let exists_three = exists(len, &fun(i: u64): bool {
        i == 3
    });

    (all_less_than_ten, exists_three)
}

// A helper struct to test abort and destructuring behavior
struct AbortAndDestructure has store {
    a: u8,
    b: u8,
}

public fun abort_then_destructure(x: u8) {
    if (x == 0) {
        abort 100;
    };
    let obj = AbortAndDestructure {a: x, b: x + 1};
    let AbortAndDestructure {a, b} = obj;
    // We will just ignore a and b here, it's to test destructuring after abort check
}

//# run 0xCAFE::GenericMap::test_keys_map

//# run 0xCAFE::GenericMap::test_quantifiers

//# run 0xCAFE::GenericMap::abort_then_destructure --args 0u8

//# run 0xCAFE::GenericMap::abort_then_destructure --args 5u8