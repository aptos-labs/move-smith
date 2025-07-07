//# publish
module 0x1::TestAbilities {
    use std::signer;

    struct Duplicate abilities copy, drop, store, store {}
    // `store` is duplicated above, this should trigger compiler error or warning about duplicate ability

    // We write a function that returns 2 if input is 5, else 0
    public fun test_fn(x: u64): u64 {
        if (x == 5) {
            2
        } else {
            0
        }
    }

    // Main function that asserts test_fn(5) == 2
    public fun main() {
        let val = test_fn(5);
        // assert val == 2, but we ignore assertions per instruction
        val;
    }

    // A function that inserts key=1 with value 1 into the map if not exists
    use std::table;

    struct MapHolder has key {
        map: table::Table<u64, u64>,
    }

    public fun new_map_holder(account: &signer): MapHolder {
        MapHolder {
            map: table::new(),
        }
    }

    public fun insert_if_not_exists(holder: &mut MapHolder) {
        if (!table::contains(&holder.map, 1)) {
            table::add(&mut holder.map, 1, 1);
        }
    }

    /// Runner function without arguments for #run test
    public fun runner(account: &signer) {
        let mut holder = new_map_holder(account);
        insert_if_not_exists(&mut holder);
        main();
    }
}

//# run 0x1::TestAbilities::runner --signers 0x1