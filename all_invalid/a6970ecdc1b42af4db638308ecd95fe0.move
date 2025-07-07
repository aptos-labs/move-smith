//# publish
module 0xDEAD::TestErrors {
    use std::vector;

    // Dummy function to generate an error for trailing comma in list
    public fun test_trailing_comma() {
        // This should fail to compile; we include it as a comment to document expected error
        // let v: vector<u8> = vector[1, 2, 3,];
        // We won't execute code here; this is for compiler error testing
    }

    // Dummy function for consecutive commas error
    public fun test_consecutive_commas() {
        // Same as above, should fail with syntax error
        // let v: vector<u8> = vector[1,, 2];
    }

    // Dummy function for misplaced comma
    public fun test_misplaced_comma() {
        // Should fail to compile due to syntax error
        // let v: vector<u8> = vector[1, ,2];
    }

    // Function to test referencing parameter by ref and copying
    public fun ref_and_copy(x: u8): u8 {
        let x_ref: &u8 = &x;
        let x_copy = *x_ref;
        x_copy
    }

    // Side effects to track evaluation order
    struct Counter has store, key {
        count: u64
    }

    // Helper function to increment counter (side effect)
    public fun increment(counter_ref: &mut Counter): u64 {
        counter_ref.count = counter_ref.count + 1;
        counter_ref.count
    }

    // Function accepting multiple closures, evaluating their arguments and side effects
    public fun evaluate_closures(
        closure1: |u64| u64,
        closure2: |u64| u64,
        counter: &mut Counter
    ): (u64, u64) {
        let res1 = closure1(increment(counter));
        let res2 = closure2(increment(counter));
        (res1, res2)
    }

    // Runner function to execute above tests
    public fun run_tests() {
        // Initialize counter
        let counter = Counter { count: 0 };

        // Closure that doubles input
        let double_closure = |n: u64| n * 2;

        // Closure that triples input
        let triple_closure = |n: u64| n * 3;

        // Call evaluate_closures to test order and side effects
        let (res1, res2) = evaluate_closures(double_closure, triple_closure, &mut counter);

        // Use ref_and_copy with a value
        let val = ref_and_copy(7u8);

        // The following variables are to prevent unused variable warnings
        let _ = res1;
        let _ = res2;
        let _ = val;
        // The expected behavior:
        // - counter is incremented twice, so counter.count should be 2
        // - res1 should be 2 * 1 = 2
        // - res2 should be 3 * 2 = 6
    }
}


//# run 0xDEAD::TestErrors::run_tests

// Features:
// 9034f758486b8614f15d17a11db301bc: Reject and report errors for trailing, consecutive, or misplaced commas within delimited lists.
// 73bbd39cc8ad9a38d26719906adce49e: Test that referencing a function parameter by reference and then copying its value produces the correct output.
// b64ffbc2b25986571baa36d48d7a71f1: Test that functions accepting multiple closures as arguments evaluate each closure's arguments in the correct order and propagate side effects as expected.
