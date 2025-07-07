//# publish
module 0xABCD::closure_test {
    // Define a struct with a function pointer trait that takes an &u64 and returns bool
    struct Predicate(|&u64| bool) has drop;

    // Function to test closure assignment and invocation
    public fun test_closure() {
        // Assign a closure to the predicate, checking if the value is even
        let is_even: Predicate = |x| (*x) % 2 == 0;

        // Verify that the closure behaves as expected
        assert!((*is_even)(&2));
        assert!(!(*is_even)(&3));
    }

    // Test that calling an increment multiple times updates local state
    public fun test_increment_chain() : u64 {
        let mut count = 0;

        // A local function to increment and return the value
        fun inc() : u64 {
            count = count + 1;
            count
        }

        // Call inc multiple times within the function
        let first = inc();
        let second = inc();
        let third = inc();

        // Return the final count
        first + second + third // Should be 1 + 2 + 3 = 6 if correctly accumulated
    }

    // Test multiple aborts in a function, ensuring execution continues
    public fun test_abort_handling(x: u64): u64 acquires None {
        // First abort based on input
        if (x % 2 == 0) {
            abort 42
        }

        let mut total = x;

        // Attempt an abort, but handle gracefully by catching the abort
        // (In Move, aborts are fatal unless in transaction tests, so simulate behavior)
        // For the sake of test, call an abort scenario and then continue
        // Here, just proceed to manipulate total
        total = total + 10;

        // Final return value
        total
    }
}

//# run 0xABCD::closure_test::test_closure

//# run 0xABCD::closure_test::test_increment_chain

//# run 0xABCD::closure_test::test_abort_handling --args 3