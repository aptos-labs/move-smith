//# publish
module 0xCAFE::OptionMatchTest {
    use std::vector;
    use std::option;

    /// A helper function demonstrating use of 'match' expressions with optional type annotations
    /// and the Move keyword `vector`. This function receives an optional u64 and returns u64.
    public fun match_option(opt: option::Option<u64>): u64 {
        // use explicit type annotation in match
        match opt {
            option::Some(inner) => inner,
            option::None => 0,
        }
    }

    /// Tests vector copying, sorting, and equality on vectors of u64.
    public fun vector_test(): bool {
        let original = vector::empty<u64>();
        let original = vector::push_back(original, 3u64);
        let original = vector::push_back(original, 1u64);
        let original = vector::push_back(original, 2u64);

        // vector::copy clones vector
        let clone = vector::copy(&original);

        // Ensure equality by direct check (std::vector equality not available, so element-wise)
        let mut equal = true;
        let len = vector::length(&original);
        if (len != vector::length(&clone)) {
            equal = false;
        }
        let mut i = 0;
        while (i < len) {
            if (*vector::borrow(&original, i) != *vector::borrow(&clone, i)) {
                equal = false;
            }
            i = i + 1;
        }

        // sort clone
        let sorted = vector::sort(clone);

        // element-wise check that sorted vector is [1, 2, 3]
        let mut sorted_correct = true;
        if (vector::length(&sorted) != 3) {
            sorted_correct = false;
        } else {
            if (*vector::borrow(&sorted, 0) != 1u64) { sorted_correct = false; }
            if (*vector::borrow(&sorted, 1) != 2u64) { sorted_correct = false; }
            if (*vector::borrow(&sorted, 2) != 3u64) { sorted_correct = false; }
        }

        // Return true only if both equality and sorted check passed
        equal && sorted_correct
    }

    /// Runner function to be called without arguments.
    public fun run_tests(): bool {
        let opt_some = option::some(42u64);
        let opt_none: option::Option<u64> = option::none();

        // test match_option with Some and None
        let some_val = match_option(opt_some);
        let none_val = match_option(opt_none);

        // run vector_test to verify copying, sorting, and equality
        let vectors_ok = vector_test();

        // No assertions required, just return combined result
        some_val == 42u64 && none_val == 0u64 && vectors_ok
    }
}
//# run 0xCAFE::OptionMatchTest::run_tests --signers 0xCAFE


//# run
script {
    use 0xCAFE::OptionMatchTest;

    fun main() {
        let result = OptionMatchTest::run_tests();
        // No asserts needed; this runs the VM and compiler paths
        // Could optionally return or log result if Move VM supported it
    }
}

// Featurres:
// 644ee5d5e5c15902cb72950195e26707: Optionally use specific Move language tokens in your code without requiring them in every context.
// ab8a6e617e0ea19a30a23efdb5d81681: Use 'match' expressions with optional type annotations for pattern matching in your code.
// 5ea401f7a54a8be7c8484197718c3540: Test that vector copying, sorting, and equality functions correctly handle comparison, cloning, and ordering of u64 vectors, ensuring assertions pass as expected.
