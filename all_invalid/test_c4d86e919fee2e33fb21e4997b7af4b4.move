//# publish
module 0x1::InvariantNestedLoops {
    public fun nested_loops_with_invariant() {
        let mut counter = 0;
        // Outer loop runs twice
        for (outer in 0..2 spec { invariant counter >= 0; }) {
            counter = 0;
            // Inner loop runs three times
            for (inner in 0..3 spec { invariant counter >= 0; }) {
                counter = counter + 1;
                // Check invariant after each inner iteration
                assert!(counter <= 3, 42);
            }
            // After inner loop, counter should be 3
            assert!(counter == 3, 43);
            // Break condition based on outer variable
            if (outer == 1) break
        }
        // Final assertion
        assert!(counter == 3, 44);
    }
}

//# run 0x1::InvariantNestedLoops::nested_loops_with_invariant

//# run
script {
    // Call the function to validate nested loop with invariant
    0x1::InvariantNestedLoops::nested_loops_with_invariant();
}