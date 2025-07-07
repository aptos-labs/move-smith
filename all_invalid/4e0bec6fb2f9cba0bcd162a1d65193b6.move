
//# publish
module 0xBABE::TestFeatures {
    use std::signer;
    use std::vector;

    // Include a standard library module (emulating include directive)
    include 0xBABE::StdLib;

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

        // Assert that the length is as expected (3)
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

// Featurres:
// cae9b328bc35673e0fc06c7e6c0352ee: Include other specification files or modules with the 'include' keyword.
// a0acdd7e316f1a5305cfc4df1f43adfe: Define pragmas with properties in Move code using the 'pragma' syntax.
// 2a6560340db2c44d1961e9f7621b8198: Test that multiple immutable references to the same local variable can coexist and be used correctly in expressions and assertions.
