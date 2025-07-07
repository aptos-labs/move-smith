address 0x1 {
    module TestMove2Features {
        use std::vector;

        /// A public function with optional generic type parameters and parameters.
        /// The generic type `T` defaults to `u64` but can be specialized.
        public fun optional_generic<T = u64>(count: u64, size: u64) acquires Counter {
            let mut counter = Counter::initialize();
            let total_expected = count * size;

            // Nested loops to increment the counter.
            let mut i = 0;
            while (i < count) {
                let mut j = 0;
                while (j < size) {
                    counter.increment();
                    j = j + 1;
                }
                i = i + 1;
            };

            // Verify the counter matches the expected total.
            assert!(counter.get() == total_expected, 1); // error code 1 means mismatch
        }

        /// A struct to keep the counter state in memory during the function call.
        struct Counter has copy, drop, store {
            value: u64,
        }

        /// Initialize the counter with zero.
        fun initialize(): Counter {
            Counter { value: 0 }
        }

        /// Increment the counter.
        fun increment(counter: &mut Counter) {
            counter.value = counter.value + 1;
        }

        /// Get the current counter value.
        fun get(counter: &Counter): u64 {
            counter.value
        }

        /// Wrapper to acquire and update counter (since Counter is resource-like here)
        fun increment(counter: &mut Counter) {
            counter.value = counter.value + 1;
        }

        /// Wrapper to create mut ref to Counter and increment it.
        fun increment(counter: &mut Counter) {
            counter.value = counter.value + 1;
        }

        /// Fix the counter usage above to correctly use mutable references.
        public fun optional_generic<T = u64>(count: u64, size: u64) {
            // Mutable local variable for counter
            let mut counter = Counter { value: 0 };
            let total_expected = count * size;

            let mut i = 0;
            while (i < count) {
                let mut j = 0;
                while (j < size) {
                    counter.value = counter.value + 1;
                    j = j + 1;
                }
                i = i + 1;
            };

            assert!(counter.value == total_expected, 1);
        }
    }


    #[test_only]
    script {
        use 0x1::TestMove2Features;

        fun test_nested_loop_counter() {
            // Test with default generic (u64)
            TestMove2Features::optional_generic(5, 10);

            // Test with explicit generic parameter, still compiles but generic unused
            TestMove2Features::optional_generic::<u128>(3, 7);

            // Test with zero loops (should match zero)
            TestMove2Features::optional_generic(0, 10);
            TestMove2Features::optional_generic(10, 0);
        }
    }
}

// Featurres:
// 0303ed29a1e49f84c9479dc9458b0acb: Ensure code only uses features enabled by Move 2.0 to maintain compatibility.
// 33c9ab6aab95b96c8b95d1523d5b8f30: Declare function signatures with optional generic type parameters and parameters in Move code.
// 2eccb8c408c0d24e4020ef8cdbb150e1: Verify that nested loops correctly increment a counter and that the final value matches the expected total after repeated iterations.
