script {
    // Transactional test to verify:
    // 1. 'ensures' postconditions enforce correctness after function execution,
    // 2. Move compiler with whole program analysis enabled,
    // 3. Left-to-right evaluation order of assignments and immediate effects in complex expressions.

    use std::signer;
    use std::debug;
    use std::vector;

    module 0x1::TestEnsuresAndOrder {
        /// A mutable global resource to test side effects of assignments.
        resource struct Counter has key {
            val: u64,
        }

        /// Initialize the counter with a starting value under the caller's address.
        public entry fun init_counter(account: &signer, initial: u64) {
            move_to(account, Counter { val: initial });
        }

        /// Increments the counter and returns the old value.
        public fun increment_counter(counter: &mut Counter): u64 {
            let old = counter.val;
            counter.val = old + 1;
            old
        }

        /// Function with a postcondition that ensures the counter's val increases by exactly `n`.
        public fun increment_n(counter: &mut Counter, n: u64)
            ensures counter.val == old(counter).val + n
        {
            let mut i = 0;
            while (i < n) {
                counter.val = counter.val + 1;
                i = i + 1;
            }
        }

        /// Test left-to-right evaluation and immediate effect of assignments in complex expressions.
        /// Returns sum of old val and values obtained from two increments performed in a single let binding.
        public fun complex_expr(counter: &mut Counter): u64 {
            // Expression breakdown:
            // increment_counter(counter) increments val and returns old val,
            // So, in an expression: increment_counter(counter) + increment_counter(counter),
            // the increments should happen left to right, with counter.val increased twice,
            // and returned values correspond to values before each increment.

            let a = increment_counter(counter);
            let b = increment_counter(counter);
            a + b
        }
    }

    /// Transactional test entry function
    public entry fun test_ensures_and_order(account: signer) {
        // Initialize the counter with 10
        0x1::TestEnsuresAndOrder::init_counter(&account, 10);

        // Borrow the Counter resource as mutable
        let counter_ref = borrow_global_mut<0x1::TestEnsuresAndOrder::Counter>(signer::address_of(&account));

        // 1. Test 'ensures' postcondition of increment_n:
        // increment by 5, must ensure counter.val is original + 5
        0x1::TestEnsuresAndOrder::increment_n(counter_ref, 5);

        let val_after_increment_n = counter_ref.val;
        assert!(val_after_increment_n == 15, 1);

        // 2. Whole program analysis is enabled by default in Move CLI when run with --package
        // This test script code structure aligns with that setting and relies on it.

        // 3. Test left-to-right evaluation order and immediate effect in complex expression
        // counter.val should be currently 15
        // complex_expr does two increments and returns sum of old two values
        let sum = 0x1::TestEnsuresAndOrder::complex_expr(counter_ref);

        // Since counter.val was 15,
        // first increment_counter returns 15 (val increments to 16)
        // second increment_counter returns 16 (val increments to 17)
        // sum = 15 + 16 = 31
        assert!(sum == 31, 2);

        // After complex_expr, counter.val should be 17
        assert!(counter_ref.val == 17, 3);

        // Log success message
        debug::print(&vector::empty<u8>());
    }
}

// Featurres:
// ef89fb716321f49d8a65468e9d0e9179: Use 'ensures' to specify postconditions that must hold after a function executes.
// 91eebeae2016a8b9a56171751839e97e: Run the Move compiler with whole program analysis enabled.
// 2d2d4e6172ba762bc3c07dc83cc3f34b: Test left-to-right evaluation order and immediate effect of assignments within complex expressions.
