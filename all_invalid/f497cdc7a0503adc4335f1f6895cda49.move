//# publish
module 0xCAFE::TestSpecInvariants {
    use std::debug;

    // Specification block with invariant
    spec {
        // Declare some invariant over a global resource
        invariant {
            // Invariant: counter always non-negative
            forall(counter: &Counter) {
                counter.count >= 0
            }
        }
    }

    // Global resource to be used for invariants
    resource struct Counter {
        count: u64,
        // The invariant annotation is outside the struct body
        // so removing inline invariant here
    }

    // Initialize the resource
    public fun init_counter(account: &signer) {
        move_to(account, Counter { count: 0 });
    }

    // Specify a function that updates counter with invariants
    public fun increment_counter(account: &signer, delta: u64) acquires Counter {
        let counter_ref = borrow_global_mut<Counter>(signer::address_of(account));
        // Update inside a block, variable tracking
        let new_value = counter_ref.count + delta;
        counter_ref.count = new_value;
    }

    // Spec function to check the invariant is maintained
    public fun check_counter(account: &signer) acquires Counter {
        let counter_ref = borrow_global<Counter>(signer::address_of(account));
        assert!(counter_ref.count >= 0, 100); // Should always hold
    }

    //# run 0xCAFE::TestSpecInvariants::init_counter --signers 0xCAFE
}

/// Testing variable assignment order within control flow
//# publish
module 0xCAFE::AssignmentFlow {
    // Function to test assignment inside expressions and control flow
    public fun assign_in_conditional(flag: bool): u64 {
        let a = 0u64;
        let b = 0u64;
        // Assign before condition
        a = 42;
        b = a + 1;

        if (flag) {
            // Assign inside block, should execute before using
            a = 100;
        } else {
            a = 200;
        }
        // Final assignment combining previous
        let result = a + b;
        result
    }

    public fun run_assignments() {
        let res_true = assign_in_conditional(true);
        let res_false = assign_in_conditional(false);
        // No assertions, just to exercise assignment order
        debug::print(&b"Res true: " as &vector<u8>);
        debug::print((&res_true) as &u64);
        debug::print(&b"Res false: " as &vector<u8>);
        debug::print((&res_false) as &u64);
    }
    //# run 0xCAFE::AssignmentFlow::run_assignments
}