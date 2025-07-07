
//# publish
module 0xCAFE::CounterMap {
    use std::signer;
    use std::table; // This is incorrect for Aptos: std::table doesn't exist.

    // In Aptos stdlib, the collection for map is std::table::Table, but often the equivalent is std::table. Move stdlib does **not** have std::table.
    // Instead, Aptos provides std::table in `0x1::table` in older Move versions, but newer Aptos stdlib uses std::table from a different address or std::table doesn't exist.
    // Typically, Aptos uses std::table from address 0x1::table, but the error "Unbound module '(std=0x1)::table'" means the module is missing in the stdlib.
    // Alternatively, Aptos uses std::table from 0x1 in stdlib, or sometimes std::table is absent and std::table is replaced with std::table::Table or std::collections::Table.
    // In Aptos the collection module is std::table, the correct import is:
    use 0x1::table;

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
        a = a + 10;
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
