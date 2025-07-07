//# publish
module 0xABCD::test_module {
    struct Counter has key {
        count: u64,
    }

    public fun create_counter(account: &signer) {
        move_to(account, Counter { count: 0 });
    }

    public fun get_counter_value(addr: address): u64 acquires Counter {
        borrow_global<Counter>(addr).count
    }

    public fun increment_counter(addr: address): u64 acquires Counter {
        let counter_ref = &mut borrow_global_mut<Counter>(addr);
        counter_ref.count = counter_ref.count + 1;
        counter_ref.count
    }

    // Runner function that initializes a counter and then increments it
    public fun run_sequence(account: &signer): u64 {
        create_counter(account);
        increment_counter(&address_of(account))
    }
}

//# run 0xABCD::test_module::create_counter --signers 0xABCD

//# run 0xABCD::test_module::run_sequence --signers 0xABCD

// Test that storing a function in a resource and invoking it later returns 23
//# publish
module 0x1234::function_test {
    use 0x1234::test_module;

    struct StoredFunction has key {
        f: Fun<(), u64>
    }

    public fun init(account: &signer) {
        let f = fun() { 23 };
        move_to(account, StoredFunction { f });
    }

    public fun call(addr: address): u64 acquires StoredFunction {
        let stored = borrow_global<StoredFunction>(addr);
        let result = stored.f();
        result
    }
}

//# run 0x1234::function_test::init --signers 0x1234

//# run 0x1234::function_test::call --args @0x1234

// Test that a struct with incremented fields returns the correct sum
//# publish
module 0x5678::struct_test {
    fun inc(x: &mut u64, by: u64): u64 {
        *x = *x + by;
        *x
    }

    struct Data has drop {
        a: u64,
        b: u64,
        c: u64,
    }

    public fun test(): u64 {
        let mut initial = 5;
        let Data { a, b, c } = Data { a: initial, b: inc(&mut initial, 10), c: inc(&mut initial, 15) };
        a + b + c
    }
}

//# run 0x5678::struct_test::test

// Test that invoking a callback within a module-locked function modifies resources respecting lock constraints
//# publish
module 0x9ABC::lock_test {
    use 0x9ABC::callee;

    struct ResourceHolder has key {
        value: u64
    }

    fun init(s: &signer) {
        move_to(s, ResourceHolder { value: 0 });
    }

    #[module_lock]
    fun lock_sensitive_operation(): bool acquires ResourceHolder {
        callee::call_me(&mut borrow_global_mut<ResourceHolder>(@0x9ABC), |res| {
            res.value += 1;
        });
        // Verify that the value has been incremented
        let res = borrow_global<ResourceHolder>(@0x9ABC);
        assert!(res.value == 1);
        true
    }
}

//# run 0x9ABC::lock_test::init --signers 0x9ABC

//# run 0x9ABC::lock_test::lock_sensitive_operation --verbose