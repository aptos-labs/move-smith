
//# publish
module 0xCAFE::ConstAndMapTest {

    use std::signer;
    use std::table;

    const MAGIC_KEY: u64 = 42;
    const INCREMENT_AMOUNT: u64 = 5;
    const FORBIDDEN_ERROR_CODE: u64 = 1001;

    struct Dummy has store, key {
        id: u64,
    }

    // Table from u64 (key) to u64 (value)
    struct MapWrapper has store {
        map: table::Table<u64, u64>,
    }

    /// Create a new MapWrapper under given signer 
    public fun create_map(s: &signer) {
        let map = table::new<u64, u64>();
        let mw = MapWrapper { map };
        move_to<MapWrapper>(s, mw);
    }

    /// Read the value for a key from the table.
    /// Returns 0 if key not found.
    public fun get_value(s: &signer, key: u64): u64 {
        if (!exists<MapWrapper>(signer::address_of(s))) {
            return 0;
        };
        let mw_ref = borrow_global<MapWrapper>(signer::address_of(s));
        if (table::contains(&mw_ref.map, key)) {
            table::borrow(&mw_ref.map, key)
        } else {
            0
        }
    }

    /// Insert (key, value) entry into table.
    public fun insert_value(s: &signer, key: u64, value: u64) {
        assert!(exists<MapWrapper>(signer::address_of(s)), 777);
        let mw_ref = borrow_global_mut<MapWrapper>(signer::address_of(s));
        table::add(&mut mw_ref.map, key, value);
    }

    /// Increment map value at key ONLY IF key exists; no insertion otherwise
    public fun increment_if_exists(s: &signer, key: u64, amt: u64) {
        assert!(exists<MapWrapper>(signer::address_of(s)), 777);
        let mw_ref = borrow_global_mut<MapWrapper>(signer::address_of(s));
        if (table::contains(&mw_ref.map, key)) {
            let val = table::borrow(&mw_ref.map, key);
            table::insert(&mut mw_ref.map, key, val + amt);
        };
    }

    /// Increment map value at key using the constants MAGIC_KEY and INCREMENT_AMOUNT
    public fun increment_with_constants(s: &signer) {
        increment_if_exists(s, MAGIC_KEY, INCREMENT_AMOUNT);
    }

    /// Function that always aborts with FORBIDDEN_ERROR_CODE
    public fun cannot_call_error(): never {
        abort(FORBIDDEN_ERROR_CODE);
    }

    /// Guarded increment function
    /// If allow_call is false, it aborts via cannot_call_error().
    /// Otherwise increments the map at MAGIC_KEY by INCREMENT_AMOUNT.
    public fun guarded_increment(s: &signer, allow_call: bool) {
        if (!allow_call) {
            cannot_call_error();
        };
        increment_with_constants(s);
    }

    /// Function to test constant values are usable in code and immutable
    public fun test_constants_use(): (u64, u64, u64) {
        // Use constants in arithmetic and checks
        let sum = MAGIC_KEY + INCREMENT_AMOUNT;
        // Check if FORBIDDEN_ERROR_CODE is same as expected value
        let is_forbidden = if (FORBIDDEN_ERROR_CODE == 1001) { 1 } else { 0 };
        (MAGIC_KEY, INCREMENT_AMOUNT, sum + is_forbidden)
    }

    /// Runner function that creates a MapWrapper and inserts one entry with MAGIC_KEY and 10
    public fun setup_with_entry(s: &signer) {
        create_map(s);
        insert_value(s, MAGIC_KEY, 10);
    }

    /// Runner function that creates a MapWrapper without any entries
    public fun setup_empty_map(s: &signer) {
        create_map(s);
    }
}
