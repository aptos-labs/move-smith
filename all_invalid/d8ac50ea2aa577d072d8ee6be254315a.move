module 0x1::transactional_tests {
    use std::debug;
    use std::vector;

    /// Resource used to detect if right-hand side expressions are evaluated or not.
    resource struct SideEffectCounter has key {
        count: u64,
    }

    /// Initialize a SideEffectCounter resource under the given address
    public fun init_side_effect_counter(account: &signer) acquires SideEffectCounter {
        move_to<SideEffectCounter>(account, SideEffectCounter { count: 0 });
    }

    /// Increment the counter by 1
    public fun increment_counter(account: &signer) acquires SideEffectCounter {
        let counter = borrow_global_mut<SideEffectCounter>(signer::address_of(account));
        counter.count = counter.count + 1;
    }

    /// Read the current counter value
    public fun read_counter(addr: address): u64 acquires SideEffectCounter {
        let counter = borrow_global<SideEffectCounter>(addr);
        counter.count
    }

    #[test_only]
    public fun test_loop_return_exit(): bool {
        // This tests that 'loop return;' inside an if block exits the entire script immediately
        let mut hit_after_return = false;

        // The outer loop - should exit immediately via loop return inside the if block.
        loop {
            if (true) {
                // Exit the entire script early:
                loop {
                    return true;
                }
            }
            // This should never be set, the code should never reach here because of the early return.
            hit_after_return = true;
        }

        // If the loop return worked properly, hit_after_return should remain false.
        !hit_after_return
    }

    #[test_only]
    public fun test_resource_acquisition_declaration(account: &signer): bool acquires SideEffectCounter {
        // This test is to check the compiler properly tracks resource acquisition
        // The Move compiler requires explicit 'acquires' declaration if a function reads or writes resources on the address
        // Here we acquire SideEffectCounter and increment it - the function 'increment_counter' is declared with 'acquires SideEffectCounter'
        // If the compiler does not enforce this, test compilation fails

        // Acquires declaration ensures this compiles and runs:
        increment_counter(account);

        // Make sure the counter is incremented once
        let val = read_counter(signer::address_of(account));
        val == 1
    }

    /// Functions to test short circuit OR (||)
    /// The right side increments a counter as a side effect if executed
    #[test_only]
    public fun test_short_circuit_or(account: &signer): bool acquires SideEffectCounter {
        // Reset counter to 0 at start
        move_to<SideEffectCounter>(account, SideEffectCounter { count: 0 });

        // Left side true, right side must be skipped (no increment)
        let left = true;
        let right = || {
            increment_counter(account);
            false
        };

        // Evaluate short circuit OR
        let result = left || right();

        // Result must be true
        // Counter must remain 0 because right side skipped
        let count_after = read_counter(signer::address_of(account));

        result && (count_after == 0)
    }

    /// Functions to test short circuit AND (&&)
    #[test_only]
    public fun test_short_circuit_and(account: &signer): bool acquires SideEffectCounter {
        // Reset counter to 0 at start
        move_to<SideEffectCounter>(account, SideEffectCounter { count: 0 });

        // Left side false, right side must be skipped (no increment)
        let left = false;
        let right = || {
            increment_counter(account);
            true
        };

        // Evaluate short circuit AND
        let result = left && right();

        // Result must be false
        // Counter must remain 0 because right side skipped
        let count_after = read_counter(signer::address_of(account));

        (!result) && (count_after == 0)
    }

    #[test_only]
    public fun run_all_tests(account: &signer): bool acquires SideEffectCounter {
        // Initialize shared resource for counters
        if (!exists<SideEffectCounter>(signer::address_of(account))) {
            init_side_effect_counter(account);
        } else {
            // reset count to 0 by moving a new one over existing
            move_to<SideEffectCounter>(account, SideEffectCounter { count: 0 });
        }

        let r1 = test_loop_return_exit();
        let r2 = test_resource_acquisition_declaration(account);
        let r3 = test_short_circuit_or(account);
        let r4 = test_short_circuit_and(account);

        r1 && r2 && r3 && r4
    }
}

// Featurres:
// 0152aafeff6b98a8df2dd0b869900afd: Test that the `loop return` statement correctly exits a script even when used inside an `if` block.
// 73d4b20956f885ed998d023491815143: Ensure that all target modules and functions correctly declare the resources they acquire, or have those acquisitions inferred by the compiler.
// 0ff2b719bdeba11c8287d54d14c82eeb: Verify that the Move language correctly implements short-circuit evaluation for boolean operators (|| and &&) so that the right-hand side expressions are not executed when the left-hand side determines the result.
