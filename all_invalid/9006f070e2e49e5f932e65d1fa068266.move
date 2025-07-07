// This test module is intended to be used in Aptos Move's testing framework.
// It tests resolving symbolic addresses, axiom kind annotation, and proper in-place mutation
// through multiple calls to a function that increments a mutable variable.

address 0x1 {
    module TestModule {
        use std::signer;

        /// A mutable global resource to demonstrate mutation and accumulation
        struct Counter has key {
            value: u64,
        }

        /// Initializes the counter resource under the signer address
        public fun init(s: &signer) {
            move_to(s, Counter { value: 0 });
        }

        /// Increment the counter's value by a given amount
        public fun inc(c: &mut Counter, delta: u64) {
            c.value = c.value + delta;
        }

        /// Read the counter's current value
        public fun get(c: &Counter): u64 {
            c.value
        }

        /// Test function which increments the counter multiple times, accumulating the value
        public fun test(s: &signer) {
            let c_ref = borrow_global_mut<Counter>(signer::address_of(s));
            
            // Multiple increments
            inc(&mut c_ref, 1);
            inc(&mut c_ref, 2);
            inc(&mut c_ref, 3);

            // Now c_ref.value should be 6 = 1 + 2 + 3
        }

        // ==== Axiom annotation ====
        // Here we test annotating an axiom with a kind 'Axiom' with a type parameter.
        // For example, an axiom specifying that the counter always holds a value >= 0.
        #[axiom(Axiom)]
        // This is a simple property axiom over the Counter type for illustration.
        public fun counter_always_non_negative(c: &Counter): bool {
            c.value >= 0
        }
    }
}

///////
// Transactional test scenario (assumes Aptos Move testing framework syntax)
script {
    use 0x1::TestModule;

    fun test_entry(account: signer) {
        // 1. Resolve symbolic address (0x1) via environment (done by testing framework by address prefix)
        // 2. Init the counter resource for this signer
        TestModule::init(&account);

        // 3. Run the test function that mutates the counter multiple times
        TestModule::test(&account);

        // 4. Borrow the counter and check the accumulated value is 6
        let c = borrow_global<TestModule::Counter>(signer::address_of(&account));
        let v = TestModule::get(&c);
        // Check value equals 6
        assert!(v == 6, 100, "Counter value after increments should be 6");
    }
}

// Featurres:
// fe582e2f5329300d797e0a2ab3bd9a44: Resolve symbolic addresses to concrete addresses using the environment settings.
// ef392edc2f3957442d957f1a89431406: Annotate the 'axiom' with a kind, such as 'Axiom', along with any type parameters.
// 3ec81caac0abb53d66246c0ca58d1ffe: Test that calling the `test` function correctly updates and aggregates the mutable variable `x` through multiple calls to `inc`, demonstrating proper in-place mutation and accumulation.
