//# publish
module 0xCAFE::Counter {
    use std::signer;
    use std::table;
    use std::option;
    use std::error;
    use std::string;

    struct Counter has key {
        value: u64,
    }

    struct CounterHolder has key {
        counters: table::Table<u64, Counter>,
    }

    // Initialize CounterHolder with empty table
    public fun init_account(account: &signer) {
        let holder = CounterHolder {
            counters: table::new<u64, Counter>(),
        };
        move_to(account, holder);
    }

    // Get a mutable reference to CounterHolder
    fun borrow_holder(account: &signer): &mut CounterHolder acquires CounterHolder {
        borrow_global_mut<CounterHolder>(signer::address_of(account))
    }

    // Get counter value by key, returning Option<u64>
    public fun get_counter(account: &signer, key: u64): option::Option<u64> acquires CounterHolder {
        let holder_ref = borrow_global<CounterHolder>(signer::address_of(account));
        let table_ref = &holder_ref.counters;
        if (table::contains(table_ref, &key)) {
            let counter_ref = table::borrow(table_ref, &key);
            option::some(counter_ref.value)
        } else {
            option::none()
        }
    }

    // Increment counter by key. If missing, auto initializes to 1.
    public fun increment(account: &signer, key: u64) acquires CounterHolder {
        let holder_ref = borrow_holder(account);
        let table_ref = &mut holder_ref.counters;
        if (!table::contains(table_ref, &key)) {
            table::add(table_ref, key, Counter { value: 1 });
        } else {
            let counter_ref = table::borrow_mut(table_ref, &key);
            counter_ref.value = counter_ref.value + 1;
        }
    }

    // Runner function: Increment counters for keys 42 and 100 and do a safety check on references
    public entry fun runner(account: &signer) acquires CounterHolder {
        // Increment key 42 (new -> auto init 1)
        increment(account, 42);
        // Increment again (should become 2)
        increment(account, 42);

        // Borrow holder to do some manual reference safety checks
        let holder_ref = borrow_holder(account);

        // Borrow two mutable references to two different keys safely
        // Insert key 100 if missing
        if (!table::contains(&holder_ref.counters, &100)) {
            table::add(&mut holder_ref.counters, 100, Counter { value: 1 });
        }
        let counter_42_ref = table::borrow_mut(&mut holder_ref.counters, &42);
        let counter_100_ref = table::borrow_mut(&mut holder_ref.counters, &100);

        // Modify counters using references
        counter_42_ref.value = counter_42_ref.value + 10;
        counter_100_ref.value = counter_100_ref.value + 20;

        // Note: We do not deliberately violate reference safety - no double mutable borrows on same key

        // No asserts needed, this is to ensure compiler/VM exercises reference safety

    }
}

//# run 0xCAFE::Counter::init_account --signers 0xCAFE

//# run 0xCAFE::Counter::runner --signers 0xCAFE


//# publish
module 0xCAFE::SpecModule {
    // Spec module - intended to test that a spec without an implementation fails
    spec module {
        // Spec only for a function that does not exist
        spec fun missing_target_function() {
            // empty spec
        }
    }
}
// Intentionally no corresponding implementation module for SpecModule to trigger compiler error (per guideline 2).
// No run commands here because compilation should fail.


//# publish
module 0xCAFE::LegacyRefSafety {
    // Legacy style to test reference safety with raw borrow and borrow_mut to cause errors in some cases

    struct Container has key {
        val: u64,
    }

    public fun create(account: &signer, v: u64) {
        move_to(account, Container { val: v });
    }

    public fun double_borrow(account: &signer) acquires Container {
        let addr = signer::address_of(account);
        let c_ref1 = borrow_global_mut<Container>(addr);
        // The following line would cause error if uncommented: mutable borrow twice
        // let c_ref2 = borrow_global_mut<Container>(addr);
        // let _sum = c_ref1.val + c_ref2.val;
        // Instead, do allowed nested borrows with immutable borrow while mutable borrow is live
        let c_ref2 = &c_ref1.val;
        let _local = *c_ref2 + c_ref1.val;
    }

    public entry fun runner(account: &signer) acquires Container {
        double_borrow(account);
    }
}

//# run 0xCAFE::LegacyRefSafety::create --signers 0xCAFE --args 10u64

//# run 0xCAFE::LegacyRefSafety::runner --signers 0xCAFE

// Featurres:
// d909a2208f147d4c283476498aa0ead5: Perform reference safety checks based on features or legacy rules.
// d4dccfeee89ce45d6510a84b34380f76: Be warned that a spec module without an associated target module in the same compilation unit will result in a compilation error
// 996b314a17f4fed53032b52b753c5c91: Automatically initialize a counter to 1 if its key is missing in the map
