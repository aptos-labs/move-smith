
//# publish
module 0xBABE::TestFeatures {
    use std::signer;
    use std::vector;

    // Remove the 'include' directive, as Move does not support it
    // include 0xBABE::StdLib; // <-- Removed

    // Define pragma with properties (simulated as a constant for testing purposes)
    const PRAGMA_PROPERTY: u8 = 1;

    // Function to combine multiple immutable references
    public fun test_multiple_immutable_borrowes() {
        let vec_of_u8: vector<u8> = vector[b"abc"];

        // Get immutable reference to the vector
        let ref1: &vector<u8> = &vec_of_u8;
        let ref2: &vector<u8> = &vec_of_u8;

        // Use the references in expressions
        let sum_length: u64 = (vector::length(ref1) as u64) + (vector::length(ref2) as u64);

        // Assert that the length sum is as expected (6)
        assert!(sum_length == 6, 777);
    }

    // Additional function to test references within multiple operations
    public fun composite_reference_test(x: u8, y: u8) {
        let val: u8 = 42;

        let ref_x: &u8 = &val;
        let ref_y: &u8 = &val;

        let sum: u8 = *ref_x + *ref_y;
        assert!(*ref_x == 42, 888);
        assert!(*ref_y == 42, 888);
        assert!(sum == 84, 999);
    }
}



//# run 0xBABE::TestFeatures::test_multiple_immutable_borrowes --args
// no args needed, just run



//# run 0xBABE::TestFeatures::composite_reference_test --args 1u8 2u8