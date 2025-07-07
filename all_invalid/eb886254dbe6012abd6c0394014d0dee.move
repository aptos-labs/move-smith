//# publish
module 0xCAFE::NestedSpecModule {
    use std::debug;

    struct Counter has copy, drop, store {
        value: u64
    }

    public fun update_counter(counter: &mut Counter, n: u64): u64 {
        let i = 0u64;
        let mut value = counter.value;

        // Nested spec block to verify correctness of the loop and mutation
        spec {
            // Outer spec for function
            ensures counter.value == value + n;
            ensures result == value + n;
            // Nested spec within function to reason about loop and mutation
            let mut spec i_local = 0u64;
            let mut spec val_local = value;
            while (i_local < n) {
                val_local = val_local + 1;
                i_local = i_local + 1;
            };
            val_local == counter.value && val_local == result;
        };

        while (i < n) {
            value = value + 1;
            i = i + 1;
        };

        counter.value = value;
        value
    }

    // Function to test multiple assignments and return sum
    public fun multi_assign_and_sum(x: u64): u64 {
        let a = x;
        let b = 0;
        let b = a + 1;
        let c = b + 2;

        a + b + c
    }
}

//# run 0xCAFE::NestedSpecModule::update_counter --args 5u64

//# run 0xCAFE::NestedSpecModule::multi_assign_and_sum --args 10u64

// Featurres:
// 0b3188b910069a5f4cc923ef2dc33263: Include nested function bodies within spec blocks for detailed specifications.
// 109b77a6ede69c1af0f085a6b92d94fd: Verify that the function modifies a mutable reference and that the loop correctly iterates based on the function's return value, resulting in the expected final value of the variable.
// ba19b39a881c3c5f015925d37268986f: Test that the Move function correctly initializes variables, performs multiple assignments involving updating the same variable, and returns the correct sum of computed values.
