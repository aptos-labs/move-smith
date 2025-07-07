//# publish
module 0xCAFE::TestModule {
    use std::signer;

    // A simple resource to test storage and borrow
    struct Counter has store, key {
        value: u64,
    }

    // Publisher function to initialize the counter
    public fun init_counter(account: &signer) {
        move_to(account, Counter { value: 0 });
    }

    // A function to increment the counter by a given amount
    public fun increment_counter(counter_ref: &mut Counter, amount: u64) {
        counter_ref.value = counter_ref.value + amount;
    }

    // Function to get the current counter value
    public fun get_counter_value(counter: &Counter): u64 {
        counter.value
    }

    // Main test function for storage and borrow
    public fun test_counter_flow(account: &signer): u64 {
        // Initialize counter
        init_counter(account);
        // Borrow global counter
        let counter_ref = borrow_global_mut<Counter>(signer::address_of(account));
        increment_counter(&mut counter_ref, 42);
        get_counter_value(&counter_ref)
    }

    // A function to test the apply logic with an anonymous inline function
    public fun apply<F: copy + drop>(a: u64, b: u64, f: &F): u64
        where F: fn(u64, u64) -> u64
    {
        f(a, b)
    }

    // Runner function for apply test
    public fun run_apply_test(): u64 {
        // Define a simple addition function
        return apply(10, 20, &add);
    }

    // Internal function matching the function pointer signature
    fun add(x: u64, y: u64): u64 {
        x + y
    }
}

//# run 0xCAFE::TestModule::test_counter_flow --signers 0xCAFE
//# run 0xCAFE::TestModule::run_apply_test

// Featurres:
// b03d1aca2c80fed7251f511e62573624: Declare each module inside the address block with its attributes and content.
// 324fb212eadc0a8bba9ecc14a09b64a1: Collect and organize test functions into a test plan for the module.
// dd5fd14ccc0eef054bd1323604bce732: Test that the apply function correctly executes a provided anonymous function to add two u64 values.
