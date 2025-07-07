
//# publish
module 0xDEAD::TestModule {
    use std::vector;

    // A helper function to simulate a `spec` block by providing an inline comment.
    // Note: Move language doesn't currently embed formal spec annotations, so it's a comment.
    // The key is to add descriptive comments indicating the property being tested.

    // Test module focusing on destructuring, vector copying, and live variable analysis.
}



//# run 0xDEAD::TestModule::test_destructuring_and_vector_copy --signers 0xBADA

public fun test_destructuring_and_vector_copy() {
    // Testing destructuring multiple return values
    let (val1, val2) = f_destructure();

    // Use val1 and val2 after destructuring
    assert!(val1 == 42, 1);
    assert!(val2 == 84, 2);

    // Create a vector
    let vec1: vector<u8> = b"hello";

    // Copy the vector (since vector has copy+drop ability)
    let vec_copy = vector::copy(&vec1);

    // Move vec1, now vec1 is invalid, but vec_copy should still be accessible
    let _ = move(vec1);

    // Use the copied vector after move
    let s = vector::length(&vec_copy);
    // Should still be accessible
    assert!(s == 5, 3);
}

// Helper function to return multiple values to test destructuring
public fun f_destructure(): (u32, u32) {
    (42, 84)
}



//# -- -- 
// Note: Removed the unrecognized 'return' command from the spec annotations to prevent parsing errors.