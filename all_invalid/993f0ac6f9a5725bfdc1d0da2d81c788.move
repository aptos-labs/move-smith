
//# publish
module 0xCAFE::ModuleLockCallbackTest {
    use std::signer;
    use std::vector;

    // A resource to track count, to verify writes and callback effect
    struct CallbackCounter has key, store {
        count: u64,
    }

    // Module-locked function that creates CallbackCounter at signer's addr
    public entry fun setup_counter(s: signer) {
        let addr = signer::address_of(&s);
        let counter = CallbackCounter { count: 0 };
        move_to<CallbackCounter>(&s, counter);
    }

    // Module-locked function that calls a callback and increments count
    public entry fun module_locked_with_callback(
        s: signer,
        callback: |&signer|,
    ) {
        let addr = signer::address_of(&s);
        // First increment
        let counter_ref = borrow_global_mut<CallbackCounter>(addr);
        counter_ref.count = counter_ref.count + 1;

        // Call the callback, which can modify the resource again
        callback(&s);

        // Then increment again after callback
        counter_ref.count = counter_ref.count + 1;
    }

    // A callback function to increment the count again, simulating nested writes
    // Not entry because it is to be called as callback
    public fun callback_increment(s: &signer) {
        let addr = signer::address_of(s);
        let counter_ref = borrow_global_mut<CallbackCounter>(addr);
        counter_ref.count = counter_ref.count + 10;
    }

    // Function to check the count value
    public fun check_count(s: &signer): u64 {
        let addr = signer::address_of(s);
        let counter_ref = borrow_global<CallbackCounter>(addr);
        counter_ref.count
    }

    // Function that performs explicit write flush simulation
    // Aptos Move does not have explicit flush instructions,
    // but we simulate ordering through nested calls and careful mutations
    public entry fun flushed_writes(s: signer) {
        let addr = signer::address_of(&s);
        let counter_ref = borrow_global_mut<CallbackCounter>(addr);
        counter_ref.count = counter_ref.count + 100;

        // Simulate flush by calling a no-op inline function,
        // ensuring commit point is easily trackable.
        flush_point();
        
        counter_ref.count = counter_ref.count + 200;
    }

    fun flush_point() {
        // Empty inline function to act as an execution point boundary
        // In real VM, would be a flush instruction here
    }

    // Runner function exercise all above in order in one transaction
    public entry fun run_all(s: signer) {
        // Setup resource
        setup_counter(s);

        // Call module-locked function with callback that increments by +10
        module_locked_with_callback(s, callback_increment);

        // Call flushed_writes to test write instruction ordering
        flushed_writes(s);

        // After above, count should reflect increments:
        // 1 (before callback) + 10 (callback) + 1 (after callback) + 100 + 200 = 312
        // We do not assert here, just exercise the code
    }
}


//# run 0xCAFE::ModuleLockCallbackTest::setup_counter --signers 0xABCD


//# run 0xCAFE::ModuleLockCallbackTest::module_locked_with_callback --signers 0xABCD --args 0xCAFE::ModuleLockCallbackTest::callback_increment


//# run 0xCAFE::ModuleLockCallbackTest::check_count --signers 0xABCD


//# run 0xCAFE::ModuleLockCallbackTest::flushed_writes --signers 0xABCD


//# run 0xCAFE::ModuleLockCallbackTest::check_count --signers 0xABCD


//# run 0xCAFE::ModuleLockCallbackTest::run_all --signers 0xABCD


// Featurres:
// 03dea97c0dddd7a0153ef576a26b8699: Test that calling a callback function within a module-locked function modifies the resource count as expected, verifying that module lock constraints are enforced during callback execution.
// 1e5a78734c41f2f7d1ec3edbf78b080a: Flush write instructions to ensure proper ordering and optimize write operations.
// 828ef181d35c3e2926bfdd916fb914b0: Ensure scripts pass the bytecode verifier before executing.
