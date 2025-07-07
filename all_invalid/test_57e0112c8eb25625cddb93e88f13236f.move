//# publish
module 0xAB::reentrant_test {
    use 0xAB::callee;

    // A resource that holds a counter, used to test access during reentrant calls
    struct CounterResource has key, store {
        count: u64
    }

    // Initialize the resource in the account
    fun init_resource(s: &signer) {
        move_to(s, CounterResource { count: 0 });
    }

    // Function that attempts a callback which accesses the resource
    fun call_callback_safely(s: &signer) acquires CounterResource {
        let r = &mut borrow_global_mut<CounterResource>(address_of(s));
        // Call the callback with access to the resource
        callee::call_me(r, |res: &mut CounterResource| {
            // Access and modify the resource inside the callback
            res.count += 10;
        });
        // After callback, modify resource to verify state
        r.count += 5;
    }

    // Function that simulates an unsafe callback causing reentrancy
    fun call_callback_unsafe(s: &signer) acquires CounterResource {
        let r = &mut borrow_global_mut<CounterResource>(address_of(s));
        // Attempting to modify resource directly inside callback which is re-entrant
        callee::call_me(r, |res: &mut CounterResource| {
            // This should not cause reentrancy error if handled properly
            res.count += 20;
        });
        r.count += 5;
    }

    // Runner to demonstrate safe callback
    fun run_safe(s: &signer) {
        init_resource(s);
        call_callback_safely(s);
        let r = borrow_global<CounterResource>(address_of(s));
        assert(*r.count == 15, 100); // 0 + 10 + 5
    }

    // Runner to demonstrate unsafe callback, expecting possible reentrancy error
    fun run_unsafe(s: &signer) {
        init_resource(s);
        call_callback_unsafe(s);
        let r = borrow_global<CounterResource>(address_of(s));
        assert(*r.count == 25, 101); // 0 + 20 + 5
    }
}

//# run 0xAB::reentrant_test::run_safe --signers 0xAB

//# run 0xAB::reentrant_test::run_unsafe --signers 0xAB --verbose