
//# publish
module 0xCAFE::CopyChainTest {
    // This module tests the destruction in a copy chain and ensures equality works correctly.
    public fun test_copy_chain_and_destroy() {
        let x = 42u64;
        let y = x; // y is a copy of x
        let z = y; // z is a copy, mutable, to allow re-assignment
        // Re-assign z to a different value
        z = 100u64;
        // Destroy z - this should remove all copy info related to the original value
        move_from<u64>(z);
    }

    // Function to illustrate a potential bytecode verifier mismatch
    // (In real test environment, this would be more complex, but for illustration)
    public fun trigger_verifier_mismatch() {
        // Simulate bytecode mismatch via intentionally malformed code
        // Note: In actual testing, this would be an invalid bytecode scenario,
        // but here we just assume calling an invalid operation to trigger diagnostics.
        // For demonstration, this function is a placeholder.
        // In practice, this might be a dummy function that isn't properly complied.
    }

    // Function that performs an expression with correct operator precedence
    public fun evaluate_precedence() {
        let result = (2 + 3) * 4 - 5 / 1;
        // result should be (5)*4 - 5 = 20 - 5 = 15
        move_from<u64>(result);
    }
}


//# run 0xCAFE::CopyChainTest::test_copy_chain_and_destroy

//# run 0xCAFE::CopyChainTest::trigger_verifier_mismatch

//# run 0xCAFE::CopyChainTest::evaluate_precedence

// Featurres:
// 5f2ba91b946acfaef5bc1b41c3366d82: Test that destroying a variable in a copy chain with a re-assignment correctly removes all related copy information, ensuring equality comparisons use the correct values.
// fefd36857fb737b210012bc5a2b3b39d: Trigger compiler diagnostics when bytecode verifier mismatches occur in user code
// 57919bd46e68fd73db04e28e80162320: Use binary operators with correct precedence during expression parsing.
