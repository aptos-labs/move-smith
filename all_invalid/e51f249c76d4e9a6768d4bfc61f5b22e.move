
//# publish
module 0xCAFE::CounterMap {
    use std::signer;
    use std::table;

    struct Counter has store, key {
        value: u64,
    }

    struct CounterMap has store {
        counters: table::Table<address, Counter>,
    }

    // Initialize a CounterMap resource to the signer if not exists
    public fun init(s: signer) {
        let addr = signer::address_of(&s);
        if (!exists<CounterMap>(addr)) {
            let counters = table::new<address, Counter>();
            move_to(&s, CounterMap {counters});
        };
    }

    // Increment counter for the given key address.
    // If missing, initialize with value=1, else increment.
    public fun increment(s: signer, key: address) {
        let addr = signer::address_of(&s);
        assert!(exists<CounterMap>(addr), 1);
        let counter_map_ref = borrow_global_mut<CounterMap>(addr);
        if (table::contains(&counter_map_ref.counters, key)) {
            let counter_ref = table::borrow_mut(&mut counter_map_ref.counters, key);
            counter_ref.value = counter_ref.value + 1;
        } else {
            let counter = Counter {value: 1};
            table::add(&mut counter_map_ref.counters, key, counter);
        };
    }

    // Get counter value for a given key. Returns 0 if missing.
    public fun get(s: signer, key: address): u64 {
        let addr = signer::address_of(&s);
        if (!exists<CounterMap>(addr)) {
            return 0u64;
        };
        let counter_map_ref = borrow_global<CounterMap>(addr);
        if (!table::contains(&counter_map_ref.counters, key)) {
            0u64
        } else {
            let counter_ref = table::borrow(&counter_map_ref.counters, key);
            counter_ref.value
        }
    }

    // Runner function to test type assertions and reassignment.
    public fun runner(): bool {
        let a: u32 = 0;
        a = a + 1;
        let b: u64 = 0;
        b = b + 1;
        a = (a + 10) as u32;
        b = b + 20u64;
        // verify final values as 11 and 21
        (a == 11) && (b == 21)
    }
}


//# run 0xCAFE::CounterMap::init --signers 0xD00D


//# run 0xCAFE::CounterMap::increment --signers 0xD00D --args 0xEFFE


//# run 0xCAFE::CounterMap::increment --signers 0xD00D --args 0xEFFE


//# run 0xCAFE::CounterMap::get --signers 0xD00D --args 0xEFFE


//# run 0xCAFE::CounterMap::get --signers 0xD00D --args 0xAABB


//# run 0xCAFE::CounterMap::runner


// Featurres:
// 996b314a17f4fed53032b52b753c5c91: Automatically initialize a counter to 1 if its key is missing in the map
// b2543182abea3036b9a0fe551b2036c3: Test that the module correctly performs type assertions and variable reassignments, ensuring that u32 and u64 variables can be incremented and that the main function verifies the final value.
// 20b305c5a5055d33eca4e37722be0cb7: Define modules and script modules in Move code to generate file format compiled units.
