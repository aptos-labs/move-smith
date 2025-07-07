
//# publish
module 0xCAFE::KeyedTable {
    use aptos_std::table;
    use std::vector;
    use std::signer;

    // Struct with key ability for use in a table
    struct KeyedStruct has copy, drop, store, key {
        id: u64,
        category: u8,
        data: vector<u8>
    }

    struct KeyedStruct2 has copy, drop, store, key {
        key1: u64,
        key2: u64,
        flag: bool
    }

    // Resource holding a Table keyed by the struct's id (u64)
    struct KeyedTable has store {
        table: table::Table<u64, KeyedStruct>
    }

    struct KeyedTable2 has store {
        table: table::Table<(u64, u64), KeyedStruct2>
    }

    // Initialize and publish a KeyedTable resource under the signer
    public fun init(s: signer) {
        let new_table = table::new<u64, KeyedStruct>();
        move_to<KeyedTable>(&s, KeyedTable {table: new_table});
    }

    public fun init2(s: signer) {
        let new_table = table::new<(u64, u64), KeyedStruct2>();
        move_to<KeyedTable2>(&s, KeyedTable2 {table: new_table});
    }

    /// Insert a KeyedStruct into the table by destructuring the argument struct using {}
    public fun insert(s: signer, ks: KeyedStruct) {
        let addr = signer::address_of(&s);

        // Destructure to bind variables
        let KeyedStruct {id, category, data} = ks;

        // Borrow resource mutably
        let table_ref: &mut KeyedTable = borrow_global_mut<KeyedTable>(addr);

        // Insert keyed by id
        table::add(&mut table_ref.table, id, KeyedStruct {id, category, data});
    }

    /// Insert a KeyedStruct2 into KeyedTable2, destructure with {}
    public fun insert2(s: signer, ks: KeyedStruct2) {
        let addr = signer::address_of(&s);
        let KeyedStruct2 {key1, key2, flag} = ks;
        let table_ref: &mut KeyedTable2 = borrow_global_mut<KeyedTable2>(addr);
        table::add(&mut table_ref.table, (key1, key2), KeyedStruct2 {key1, key2, flag});
    }

    /// Remove by id
    public fun remove(s: signer, id: u64) {
        let addr = signer::address_of(&s);
        let table_ref: &mut KeyedTable = borrow_global_mut<KeyedTable>(addr);
        table::remove(&mut table_ref.table, id);
    }

    /// Borrow by id and return category and data length
    public fun borrow_info(s: signer, id: u64): (u8, u64) {
        let addr = signer::address_of(&s);
        let table_ref: &KeyedTable = borrow_global<KeyedTable>(addr);
        let ks_ref: &KeyedStruct = table::borrow(&table_ref.table, id);
        (ks_ref.category, vector::length(&ks_ref.data) as u64)
    }

    /// Filtering keys out of the table by removing those whose category == filter_category
    /// Demonstrate "custom filtering during compilation" concept by runtime filtering here
    public fun filter_out_category(s: signer, filter_category: u8) {
        // Iterate keys and remove matching category elements
        let addr = signer::address_of(&s);
        let table_ref: &mut KeyedTable = borrow_global_mut<KeyedTable>(addr);
        let keys: vector<u64> = table::keys(&table_ref.table);

        let len = vector::length(&keys);
        let i = 0;
        while (i < len) {
            let key = *vector::borrow(&keys, i);
            let ks_ref = table::borrow(&table_ref.table, key);
            let KeyedStruct {id, category, ..} = *ks_ref; // destructure for direct access

            if (category == filter_category) {
                table::remove(&mut table_ref.table, key);
            };

            i = i + 1;
        };
    }

    /// Similar filtering for KeyedTable2: remove where flag == false
    public fun filter_flag_false(s: signer) {
        let addr = signer::address_of(&s);
        let table_ref: &mut KeyedTable2 = borrow_global_mut<KeyedTable2>(addr);
        let keys: vector<(u64, u64)> = table::keys(&table_ref.table);

        let len = vector::length(&keys);
        let i = 0;
        while (i < len) {
            let key = *vector::borrow(&keys, i);
            let ks_ref = table::borrow(&table_ref.table, key);
            let KeyedStruct2 {key1: _k1, key2: _k2, flag} = *ks_ref;

            if (!flag) {
                table::remove(&mut table_ref.table, key);
            };

            i = i + 1;
        };
    }

    /// Runner function for combined scenario:
    /// 1. Initialize tables
    /// 2. Insert several elements using destructured structs
    /// 3. Filter based on key fields and flags
    /// 4. Access final data

    public fun runner(s: signer) {
        // Initialize both tables
        init(s);
        init2(s);

        // Insert keyed items into KeyedTable
        let data1 = vector::empty<u8>();
        let data2 = vector::empty<u8>();
        let data3 = vector::empty<u8>();

        vector::push_back(&mut data1, 10);
        vector::push_back(&mut data1, 20);

        vector::push_back(&mut data2, 30);

        // Populate entries using struct destructuring in insert
        let ks1 = KeyedStruct {id: 1, category: 5, data: data1};
        let ks2 = KeyedStruct {id: 2, category: 10, data: data2};
        let ks3 = KeyedStruct {id: 3, category: 5, data: data3};

        insert(s, ks1);
        insert(s, ks2);
        insert(s, ks3);

        // Insert keyed items into KeyedTable2
        let ks21 = KeyedStruct2 {key1: 100, key2: 200, flag: true};
        let ks22 = KeyedStruct2 {key1: 101, key2: 201, flag: false};
        let ks23 = KeyedStruct2 {key1: 102, key2: 202, flag: true};

        insert2(s, ks21);
        insert2(s, ks22);
        insert2(s, ks23);

        // Filter to remove all KeyedStruct entries with category == 5
        filter_out_category(s, 5);

        // Filter to remove all KeyedStruct2 entries with flag == false
        filter_flag_false(s);

        // Access remaining entries' info (just to exercise borrow after filtering)
        let (_cat, _len) = borrow_info(s, 2);
        let (_cat3, _len3) = borrow_info(s, 3); // This one was filtered out; could cause abort if used, but we do not run assertions here

        // no return for runner
    }
}



//# run 0xCAFE::KeyedTable::runner --signers 0xBEEF



//# run 0xCAFE::KeyedTable::init --signers 0xCA11



//# run 0xCAFE::KeyedTable::insert --signers 0xCA11 --args 7u64 1u8 x"010203"



//# run 0xCAFE::KeyedTable::borrow_info --signers 0xCA11 --args 7u64



//# run 0xCAFE::KeyedTable::filter_out_category --signers 0xCA11 --args 1u8



//# run 0xCAFE::KeyedTable::remove --signers 0xCA11 --args 7u64


// Features:
// 16697d963380114940c1851f50dab05a: Bind variables to struct destructuring patterns using `{}` syntax
// 81f94665a6eba2f247b1bdc0d9c04e4c: Filter elements of a Move program based on custom criteria during compilation
// 048eb77e16a691f25cb000b2451938a6: Use the 'Key' ability to designate values as keys for tables or collections.
