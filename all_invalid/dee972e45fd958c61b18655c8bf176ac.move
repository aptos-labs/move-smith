module 0x1::transactional_test {

    use std::vector;
    use std::table::{Self, Table};
    use std::signer;

    /// A simple struct with a counter field.
    struct Counter has key, store {
        value: u64,
    }

    /// The resource that holds a Table from address to Counter.
    struct CounterTable has key {
        map: Table<address, Counter>,
    }

    /// Initialize the CounterTable resource at the sender
    public entry fun initialize(s: &signer) {
        let table = Table::new<address, Counter>();
        move_to(s, CounterTable { map: table });
    }

    /// Add a counter for a given address key with initial value 0.
    public entry fun add_counter(s: &signer, key: address) {
        let counter = Counter { value: 0 };
        let ct = borrow_global_mut<CounterTable>(signer::address_of(s));
        Table::insert(&mut ct.map, key, counter);
    }

    /// Increment the counter for a given key if present.
    /// Does nothing if the key is not present.
    public entry fun increment_counter(s: &signer, key: address) {
        let ct = borrow_global_mut<CounterTable>(signer::address_of(s));
        if (Table::contains(&ct.map, key)) {
            let counter = Table::borrow_mut(&mut ct.map, key);
            counter.value = counter.value + 1;
        }
    }

    /// Get the current counter value for a given key (used in test assertions)
    public fun get_counter(key_owner: address, key: address): u64 acquires CounterTable {
        if (!exists<CounterTable>(key_owner)) {
            return 0;
        };
        let ct = borrow_global<CounterTable>(key_owner);
        if (!Table::contains(&ct.map, key)) {
            return 0;
        };
        let counter = Table::borrow(&ct.map, key);
        counter.value
    }


    #[test]
    public fun test_explicit_numeric_literal_address_and_apply_increment() {
        // 1. Specify an explicit numeric literal address (0xA).
        // 2. Apply other types/structs by name (apply Table and Counter).
        // 3. Increment counter for a key if present.

        // Explicit address literal
        let owner_addr: address = 0xA; // explicit numeric literal

        // Create a signer for owner_addr.
        // In Move test framework, use `signer::spec` to create a signer for a specific address.
        // However, since this is a transactional test, the framework will provide an implicit signer
        // here we use `signer::spec()` construct hypothetically for demonstration.

        // Let's assume for the test that the current signer (say 0x1) will hold the CounterTable,
        // and 0xA is the "key" we use in the map.

        let owner_signer = @0x1; // test signer address (implicit in tests)
        // In Aptos testing, signer is implicit, so we can just call entry functions with the signer.

        // Initialize CounterTable under signer 0x1
        initialize(&signer::spec()); 

        // Insert a counter at key 0xA
        add_counter(&signer::spec(), owner_addr);

        // Check initial counter is zero
        let initial = get_counter(signer::address_of(&signer::spec()), owner_addr);
        assert!(initial == 0, 100);

        // Increment the counter - should succeed (key present)
        increment_counter(&signer::spec(), owner_addr);

        // Check counter incremented
        let after_increment = get_counter(signer::address_of(&signer::spec()), owner_addr);
        assert!(after_increment == 1, 101);

        // Increment again
        increment_counter(&signer::spec(), owner_addr);
        let after_second_increment = get_counter(signer::address_of(&signer::spec()), owner_addr);
        assert!(after_second_increment == 2, 102);

        // Increment counter for a missing key - 0xB
        let missing_key: address = 0xB;
        increment_counter(&signer::spec(), missing_key);

        // The counter for 0xB should remain 0 (not present)
        let missing_count = get_counter(signer::address_of(&signer::spec()), missing_key);
        assert!(missing_count == 0, 103);
    }
}

// Featurres:
// bb5867633dc875eaca5348c1993e3fd3: Specify an address as an explicit numeric literal.
// c728f942158633b6b6700b9e36cc7bcc: Apply other types or structs by name with 'Apply'.
// 3092a226b33041460bf836d8e9024ba9: Increment a counter for a given key when it is present in the map
