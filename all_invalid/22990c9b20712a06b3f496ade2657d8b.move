
//# publish
module 0xCAFE::RefEqualityAndLoopTest {
    use std::vector;
    use std::signer;

    // Test 1: Compare mutable references to different variables
    public fun test_reference_inequality(): bool {
        let a = 42;
        let b = 42;

        // Borrow mutable references to local variables
        let ref_a = &mut a;
        let ref_b = &mut b;

        // Compare the references for inequality
        // Since they point to different variables, should be unequal
        ref_a != ref_b
    }

    // Test 2: Mutate a resource within a loop and verify its state
    struct Counter has store, key {
        count: u64,
    }

    public fun initialize_counter(addr: address): Counter {
        move_to<Counter>(&signer::borrow_address(&addr), Counter { count: 0 })
    }

    public fun mutate_counter_in_loop(counter: &mut Counter, iterations: u64) {
        let i = 0;
        while (i < iterations) {
            counter.count = counter.count + 1;
            i = i + 1;
        }
        // Return the final count (not necessarily used in test but for verification)
        counter.count
    }

    // Test 3: Turn on or off a named experiment: "enable_mut_ref_test=on"
    public fun turn_experiment_on() {
        // This function is a placeholder to simulate setting experiment flags.
        // In actual compiler flags, this would be set outside of Move code.
        // For test purposes, this can be a no-op or a dummy.
        // (In real tests, the compiler is invoked with flags, not via code.)
        // No action needed here.
        0
    }
}


//# run 0xCAFE::RefEqualityAndLoopTest::test_reference_inequality


//# run 0xCAFE::RefEqualityAndLoopTest::initialize_counter --signers 0xCAFE


//# run 0xCAFE::RefEqualityAndLoopTest::mutate_counter_in_loop --signers 0xCAFE --args 100u64


//# run 0xCAFE::RefEqualityAndLoopTest::turn_experiment_on

// Featurres:
// 9336318e9e8ce1337d0b9ef3f2ee5291: Test whether mutable references to different local variables are considered unequal when compared.
// 7dffe8f03b6cccc2e3f2ff4865b529eb: Test that modifying a mutable resource within a loop updates its state correctly and that the modifications produce expected values without causing bytecode verifier errors.
// 5261fe6d66f5c0fb96e593b96dea3caa: Turn on or off named experiments in the compiler by passing `<exp_name>` for on or `<exp_name>=on/off` for explicit control.
