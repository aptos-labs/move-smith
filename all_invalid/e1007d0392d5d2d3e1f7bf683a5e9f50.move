//# publish
module 0xCAFE::TestModule {
    use std::collections::BTreeMap;

    // A struct to track counts of keys
    struct Counter has store, drop {
        counts: BTreeMap::BTreeMap<u64, u64>,
    }

    // Initialize an empty counter
    public fun new_counter(): Counter {
        Counter {
            counts: BTreeMap::new(),
        }
    }

    // Increment count for a key
    public fun increment(counter: &mut Counter, key: u64) {
        let counts = &mut counter.counts;
        let old_count = if (BTreeMap::contains_key(counts, &key)) {
            *BTreeMap::borrow_mut(counts, &key)
        } else {
            0u64
        };
        BTreeMap::insert(counts, key, old_count + 1);
    }

    // Get count for a key
    public fun get_count(counter: &Counter, key: u64): u64 {
        if (BTreeMap::contains_key(&counter.counts, &key)) {
            *BTreeMap::borrow(&counter.counts, &key)
        } else {
            0u64
        }
    }

    // runner function for testing increment and get_count (no arguments)
    public fun runner() {
        let mut c = new_counter();
        increment(&mut c, 10);
        increment(&mut c, 10);
        increment(&mut c, 20);
        // Just call get_count to cover the code:
        let _ = get_count(&c, 10);
        let _ = get_count(&c, 20);
        let _ = get_count(&c, 30);
    }

    spec increment {
        // After increment(counter, key), the new count >= old count + 1
        // Note: we cannot do old_count here but we can assert new count > 0
        assert get_count(&counter, key) > 0;
    }
    spec get_count {
        // get_count always returns a number >= 0 (u64 is always >=0, so trivial)
        assert get_count(&counter, key) >= 0;
    }
}
//# run 0xCAFE::TestModule::runner

//# run
script {
    use std::collections::BTreeMap;
    use 0xCAFE::TestModule;

    fun main() {
        let mut c = TestModule::new_counter();

        // Increment keys 1,2,1,3,2,2 to test internal BTreeMap in VM
        TestModule::increment(&mut c, 1);
        TestModule::increment(&mut c, 2);
        TestModule::increment(&mut c, 1);
        TestModule::increment(&mut c, 3);
        TestModule::increment(&mut c, 2);
        TestModule::increment(&mut c, 2);

        // Check counts - no asserts needed but this calls the functions
        let count1 = TestModule::get_count(&c, 1);
        let count2 = TestModule::get_count(&c, 2);
        let count3 = TestModule::get_count(&c, 3);
        let count4 = TestModule::get_count(&c, 4);

        // Just dummy usage to confirm no error:
        let _ = (count1, count2, count3, count4);
    }
}

// Featurres:
// 560244dd82d11bf77636ba489a52fb2c: Define the function body in braces when not native.
// 68f197fdb492ae6a91cfb6c758c2fef5: Use BTreeMap to store and count occurrences of keys.
// 9905fa83fd66c01ba6a8ea2447e49bb0: Declare 'assert' conditions within specifications.
