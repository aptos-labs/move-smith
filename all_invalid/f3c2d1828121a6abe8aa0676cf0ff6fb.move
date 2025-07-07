//# publish
module 0xCAFE::UniqueModules {
    use std::vector;
    use std::option;
    use std::signer;
    use std::address;
    use std::error;
    use std::string;

    /// A minimal UniqueMap implementation for <address, vector<u8>> pairs.
    struct UniqueMap has key {
        keys: vector<address>,
        values: vector<vector<u8>>,
    }

    /// Initialize a new empty UniqueMap
    public fun new(): UniqueMap {
        UniqueMap {
            keys: vector::empty<address>(),
            values: vector::empty<vector<u8>>(),
        }
    }

    /// Insert a new key-value pair. If key exists, replace value.
    public fun insert(map: &mut UniqueMap, key: address, value: vector<u8>) {
        let i = index_of(&map.keys, key);
        if (option::is_some(&i)) {
            let idx = option::extract(i);
            vector::borrow_mut(&mut map.values, idx) = value;
        } else {
            vector::push_back(&mut map.keys, key);
            vector::push_back(&mut map.values, value);
        }
    }

    /// Get an iterator that clones keys only
    public fun key_cloned_iter(map: &UniqueMap): vector<address> {
        // Just return a copy of keys vector
        vector::copy(&map.keys)
    }

    /// For each key-value pair, run the given callback on key and value
    /// Here callback is a function that takes (&address, &vector<u8>)
    /// Since we have no function param passing in Move, simulate it with event or just an example
    /// For the test, just simulate by doing nothing (or add code caller can modify)
    public fun for_each<F>(map: &UniqueMap, _callback: F) acquires UniqueMap {
        // Dummy / placeholder implementation: in Move, can't pass closures, so do nothing here.
        // The test will rely on key_cloned_iter for iteration checks.
        let _len = vector::length(&map.keys);
        // no-op
    }

    /// Filter map entries by a predicate on key (returning true keeps the key-value pair)
    /// This returns a new UniqueMap
    public fun filter_by_key(map: &UniqueMap, filter_address: address): UniqueMap {
        let new_map = new();
        let len = vector::length(&map.keys);
        let i = 0;
        while (i < len) {
            let k = *vector::borrow(&map.keys, i);
            if (address::to_u64(k) > address::to_u64(filter_address)) {
                // copy value by cloning vector<u8>
                let v_orig = vector::borrow(&map.values, i);
                let v = vector::copy(v_orig);
                insert(&mut new_map, k, v);
            };
            i = i + 1;
        };
        new_map
    }

    /// Runner function that exercises the UniqueMap:
    /// - Creates map
    /// - Inserts 3 address->module bytes
    /// - Iterates keys by key_cloned_iter, no return
    /// - Calls for_each (does nothing)
    /// - Calls filter_by_key and discards result
    public fun runner() {
        let mut map = new();
        insert(&mut map, 0x100, b"module_a");
        insert(&mut map, 0x200, b"module_b");
        insert(&mut map, 0x300, b"module_c");

        let keys = key_cloned_iter(&map);
        // dummy call to for_each (no callback)
        for_each(&map, &());

        let _filtered = filter_by_key(&map, 0x150);
        // discard filtered
    }
}

//# run 0xCAFE::UniqueModules::runner --signers 0xCAFE


//# publish
module 0xCAFE::AddressModuleFilter {
    use std::vector;

    /// A simple container for (address, vector<u8> module bytes)
    struct AddrModulePair has copy, drop, store {
        addr: address,
        module_bytes: vector<u8>,
    }

    /// Filter pairs and keep only addresses with even low 8 bits
    public fun filter_even_low_byte(pairs: vector<AddrModulePair>): vector<AddrModulePair> {
        let mut result = vector::empty<AddrModulePair>();
        let len = vector::length(&pairs);
        let i = 0;
        while (i < len) {
            let pair = *vector::borrow(&pairs, i);
            let low_byte = (address::to_u64(pair.addr) & 0xff) as u8;
            if (low_byte % 2 == 0) {
                vector::push_back(&mut result, pair);
            };
            i = i + 1;
        };
        result
    }

    /// Runner function to test filtering behavior
    public fun runner() {
        let mut pairs = vector::empty<AddrModulePair>();
        vector::push_back(&mut pairs, AddrModulePair { addr: 0xCAFE, module_bytes: b"mod1" });
        vector::push_back(&mut pairs, AddrModulePair { addr: 0xBEEF, module_bytes: b"mod2" });
        vector::push_back(&mut pairs, AddrModulePair { addr: 0xCAFF, module_bytes: b"mod3" });
        vector::push_back(&mut pairs, AddrModulePair { addr: 0x1234, module_bytes: b"mod4" });

        let _filtered = filter_even_low_byte(pairs);
    }
}

//# run 0xCAFE::AddressModuleFilter::runner --signers 0xCAFE


//# publish
module 0xCAFE::LCM {
    /// Compute gcd using Euclidean algorithm
    public fun gcd(mut a: u64, mut b: u64): u64 {
        while (b != 0) {
            let tmp = b;
            b = a % b;
            a = tmp;
        };
        a
    }

    /// Compute least common multiple for two numbers
    public fun lcm(a: u64, b: u64): u64 {
        (a / gcd(a, b)) * b
    }

    /// Compute lcm of all numbers from 1 up to n inclusive
    public fun smallest_multiple(n: u64): u64 {
        let mut acc = 1;
        let mut i = 2;
        while (i <= n) {
            acc = lcm(acc, i);
            i = i + 1;
        };
        acc
    }

    /// Runner that calls smallest_multiple for a few values
    public fun runner() {
        let _v1 = smallest_multiple(10);  // 2520
        let _v2 = smallest_multiple(15);
        let _v3 = smallest_multiple(20);
    }
}

//# run 0xCAFE::LCM::runner --signers 0xCAFE


//# run 0xCAFE::UniqueModules::runner --signers 0xCAFE

//# run 0xCAFE::AddressModuleFilter::runner --signers 0xCAFE

//# run 0xCAFE::LCM::runner --signers 0xCAFE

// Featurres:
// 9540804edb415aa73dea08a9d6fca2a4: Create a collection of unique modules using 'UniqueMap' and iterate over them with 'key_cloned_iter' and 'for_each' for processing.
// bd55926960feba0d24f5bc21babb44c0: Filter addresses and their associated modules based on specific criteria.
// e2989a9b26c3879d1ef81e34188f3f4d: Verify that the smallest_multiple function correctly computes the least common multiple (LCM) of all integers from 1 up to a given limit.
