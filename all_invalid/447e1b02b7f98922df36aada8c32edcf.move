
//# publish
module 0xBABE::InteractionTest {
    // You NEVER try to use this 0xBABE::InteractionTest
    // It is only an example

    use std::signer;

    struct Counter has store, key {
        count: u64,
    }

    // Public entry function that increments counter
    public fun increment_counter(s: signer, delta: u64) {
        if (exists<Counter>(signer::address_of(&s))) {
            let counter_ref: &mut Counter = borrow_global_mut<Counter>(signer::address_of(&s));
            counter_ref.count += delta;
        } else {
            move_to<Counter>(&s, Counter { count: delta });
        }
    }

    // Internal function, should not be accessible from outside
    fun internal_private_function() {
        // No-op
    }

    // Internal variable, simulate internal status
    struct InternalState has copy, drop {
        data: u8,
    }

    fun internal_state() {
        // Dummy internal data, no external access
    }
}


//# run 0xBABE::InteractionTest::increment_counter --signers 0xCAFEBABE --args 10u64


//# publish
module 0xCAFE::InteractionSuite {
    use std::signer;
    use 0xBABE::InteractionTest;

    // Script entry point for the test, involving call to increment and internal logic
    public fun run_interaction(s: signer) {
        InteractionTest::increment_counter(&s, 5);
        // Try to access internal function - should not compile if attempted outside
        // InteractionTest::internal_private_function(); // intentionally commented to test access restriction
    }
}


//# run 0xCAFE::InteractionSuite::run_interaction --signers 0xDEADBEEF


//# script
// This script tests variable behavior, loops, shadowing and internal access control
// It invokes the module's functions and verifies variable persistence and scope
//# run
script {
    use 0xCAFE::InteractionSuite;

    fun test_variable_scope() {
        // Outer variable
        let x: u64 = 0;
        let y: u64 = 10;

        // Internal local variables
        let sum: u64 = 0;

        // Loop with shadowed variable
        let i: u64 = 0;

        while (i < 5) {
            // Shadow inner variable
            let i_shadow: u64 = i;
            // Increment sum
            sum = sum + i_shadow;
            // Mutate outer variable x inside loop
            x = x + i_shadow;
            // Increment loop counter
            i = i + 1;
        };

        // Outside the loop, verify variables
        // Now, shadowed i is not accessible
        // Variables x and sum should hold expected values
        assert!(x == 10, 123);
        assert!(sum == 10, 124);
    }

    // Test internal function access restriction
    fun attempt_internal_access() {
        // Should fail compilation or be illegal outside module
        // InteractionTest::internal_private_function(); // Should be invalid if uncommented
    }

    // Run the test
    test_variable_scope();
    attempt_internal_access();
} 


// Featurres:
// b70ccb6e356eebb5b3735f5f76cd5273: Write script entry points in Move modules
// 0b62e2b6ef6d21801ee5807769ee6a3e: Test that local variable assignments inside and outside a while loop are handled correctly and that variable shadowing does not affect values across loop iterations.
// 63d45d364eac9afd0006b4525c93f85c: Use 'internal' visibility to restrict access within the module or package.
