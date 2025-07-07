//# publish
module 0xabc::mutation {
    // This module tests in-place mutation and aggregation through multiple function calls.

    fun decrease(x: &mut u64, y: u64): u64 {
        *x = *x - y;
        *x
    }

    public fun test_mutation(): u64 {
        let mut total = 10;
        decrease(&mut total, 2);
        decrease(&mut total, 3);
        decrease(&mut total, 1);
        total
    }
}

//# run 0xabc::mutation::test_mutation

//# publish
module 0xdef::resource_borrow {
    // This module tests borrowing a resource with a matched type and handling type mismatch errors.

    struct Data<T> has key, drop { value: T }

    fun init_data(s: &signer) {
        move_to(s, Data<u64>{value: 42});
    }

    fun borrow_u64(): u64 reads Data<u64> {
        borrow_global<Data<u64>>(@0x1).value
    }

    fun borrow_bool(): bool reads Data<bool> {
        borrow_global<Data<bool>>(@0x1).value
    }

    fun borrow_wrong_type(): u64 reads Data<bool> {
        borrow_global<Data<bool>>(@0x1).value
        // The above line is intended to cause a type mismatch error if uncommented.
        // In actual test execution, this should produce an error.
        0
    }
}

//# run --verbose --signers 0x1 -- 0xdef::resource_borrow::init_data

//# run --verbose -- 0xdef::resource_borrow::borrow_u64

//# run --verbose -- 0xdef::resource_borrow::borrow_bool

//# run --verbose -- 0xdef::resource_borrow::borrow_wrong_type  // expecting a type mismatch error

//# publish
module 0x123::storage_test {
    // Testing storing and retrieving a custom persistent resource.

    use 0x1::signer;

    struct Counter has store, key {
        count: u64
    }

    #[persistent]
    fun default_counter(): u64 {
        0
    }

    entry fun initialize_counter(s: &signer) {
        move_to(s, Counter { count: default_counter() });
    }

    entry fun increment_counter(s: &signer) acquires Counter {
        let cnt = move_from<Counter>(signer::address_of(s));
        let new_count = cnt.count + 1;
        move_to(s, Counter { count: new_count });
    }

    fun get_counter_value(addr: address): u64 acquires Counter {
        borrow_global<Counter>(addr).count
    }
}

//# run 0x123::storage_test::initialize_counter --signers 0x123

//# run 0x123::storage_test::increment_counter --signers 0x123

//# run 0x123::storage_test::get_counter_value --args 0x123