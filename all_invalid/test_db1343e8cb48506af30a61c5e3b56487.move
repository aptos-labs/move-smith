//# publish
module 0xABCD::resource_test {
    struct Counter has key {
        count: u64,
    }

    // A resource with a counter, to be accessed and modified via lambda closure.
    public fun initialize(s: &signer) {
        move_to(s, Counter { count: 0 });
    }

    // Test whether a lambda closure can access and modify the resource, then verify direct modification.
    public fun test_lambda_modification() acquires Counter {
        // Define a lambda closure that increments the counter.
        let increment_counter = || {
            let counter_ref = &mut Counter[@0xABCD];
            counter_ref.count = counter_ref.count + 10;
        };

        // Invoke the closure to modify the resource.
        increment_counter();

        // Directly modify the resource after closure invocation.
        let counter_ref = &mut Counter[@0xABCD];
        counter_ref.count = counter_ref.count + 5;

        // Return true to indicate test has run (assertions can be added as needed)
        true
    }
}

//# run 0xABCD::resource_test::initialize --signers 0xABCD

//# run 0xABCD::resource_test::test_lambda_modification --verbose