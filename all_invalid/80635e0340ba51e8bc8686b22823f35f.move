
//# publish
module 0xCAFE::CopyChainTest {
    // This module tests the destruction in a copy chain and ensures equality works correctly.
    public fun test_copy_chain_and_destroy() {
        let x = 42u64;
        let y = copy x; // y is a copy of x
        let z = copy y; // z is a copy, mutable, to allow re-assignment
        // Re-assign z to a different value
        z = 100u64;
        // Destroy z - this should remove all copy info related to the original value
        move_from<u64>(z);
    }

    // Function to illustrate a potential bytecode verifier mismatch
    // (In real test environment, this would be more complex, but for illustration)
    // (This function is a placeholder and does nothing)
    public fun trigger_verifier_mismatch() {
        // intentionally empty
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