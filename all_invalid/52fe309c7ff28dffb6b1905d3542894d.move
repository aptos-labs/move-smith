//# publish
module 0xCAFE::CounterMap {
    use std::vector;
    use std::table;

    /// A simple counter map, associating keys of type K (which must have key ability) to u64 counters.
    struct CounterMap<K: copy + store + key> has store {
        inner: table::Table<K, u64>,
    }

    public fun new<K: copy + store + key>(): CounterMap<K> {
        let map = table::new<K, u64>();
        CounterMap { inner: map }
    }

    public fun increment<K: copy + store + key>(map: &mut CounterMap<K>, key: K) {
        if (table::contains(&map.inner, &key)) {
            let current = *table::borrow(&map.inner, &key);
            table::insert(&mut map.inner, key, current + 1);
        } else {
            table::insert(&mut map.inner, key, 1);
        };
    }

    public fun get<K: copy + store + key>(map: &CounterMap<K>, key: K): u64 {
        if (table::contains(&map.inner, &key)) {
            *table::borrow(&map.inner, &key)
        } else {
            0
        }
    }

    /// Example runner function to test CounterMap with u8 keys.
    public fun run_example() {
        let mut map = new<u8>();
        increment(&mut map, 10u8);
        increment(&mut map, 10u8);
        increment(&mut map, 5u8);
        let count_10 = get(&map, 10u8);
        let count_5 = get(&map, 5u8);
        let count_3 = get(&map, 3u8);

        // Dummy usage to avoid unused variables warnings
        assert!(count_10 == 2, 1);
        assert!(count_5 == 1, 2);
        assert!(count_3 == 0, 3);
    }
}

//# run 0xCAFE::CounterMap::run_example

//# publish
module 0xCAFE::NamedAddressExample {
    /// Demonstrate named address usage at compile time.
    /// The named address `OWNER` is conceptually mapped to 0xCAFE externally.
    /// Here we just declare a constant and show simple usage.

    const OWNER: address = @0xCAFE;

    struct Data has copy, drop, store, key {
        val: u64,
    }

    public fun create_data(): Data {
        Data { val: 42u64 }
    }

    public fun owner_address(): address {
        OWNER
    }
}

//# run 0xCAFE::NamedAddressExample::owner_address

//# publish
module 0xCAFE::AbilitiesExample {
    /// Illustrate named abilities on type parameters.

    struct Storeable has store {
        value: u8,
    }

    struct Copyable has copy, store {
        value: u8,
    }

    struct CopyDrop has copy, drop, store {
        value: u8,
    }

    /// Generic struct requiring that T must have copy and store abilities
    struct CopyStore<T: copy + store> has store {
        t: T,
    }

    /// Function only accepts T with copy + drop + store
    public fun use_copydrop<T: copy + drop + store>(input: T): T {
        input
    }

    /// Function only accepts T with store only (not copy or drop)
    public fun use_store_only<T: store>(input: T): T {
        input
    }

    /// Example function to demonstrate instantiation and usage
    public fun run_abilities_example() {
        let a = Storeable { value: 1u8 };
        let _ = use_store_only(a);

        let b = Copyable { value: 2u8 };
        let cs = CopyStore { t: b };
        let _ = cs;

        let c = CopyDrop { value: 3u8 };
        let _ = use_copydrop(c);
    }
}

//# run 0xCAFE::AbilitiesExample::run_abilities_example

// Featurres:
// c1f87a541029837d0a52204fd606080e: Store counters in a map associating keys to integer values
// 08b3b53bc1c560bd97ad1e7a9d7c3e33: Declare named addresses and assign them values when compiling your Move package.
// 2c877806b5aaac93b9a83e2cbd0f5fa0: Annotate each type parameter with its name and a list of abilities that it must satisfy.
