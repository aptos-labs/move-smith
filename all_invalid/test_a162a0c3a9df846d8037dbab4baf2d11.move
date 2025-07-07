//# publish
module 0x1::BoolAndByteVectorTest {
    // Define boolean vectors with different logical expressions
    const B0: vector<bool> = vector[];
    const B1: vector<bool> = vector[true];
    const B2: vector<bool> = vector[false];
    const B3: vector<bool> = vector[true || false];
    const B4: vector<bool> = vector[true && (false || true)];
    const B5: vector<bool> = vector[false == false, true != false];

    // Define empty and non-empty byte vectors and compare
    const E0: bool = vector<u8>[] == vector<u8>[];
    const E1: bool = vector<u8>[] == vector[1, 2, 3];
    const E2: bool = vector[0] == vector[0];
    const E3: bool = vector[5] != vector[6];

    // Create nested vectors of byte vectors to test vector of vectors
    const V0: vector<vector<u8>> = vector[
        vector[10, 20],
        vector[],
        vector[30]
    ];

    // Function to test the correctness of the above initializations and comparisons
    fun test_vectors() {
        // Assert boolean vector logical expressions
        assert!(vector[true, false, true && false] == vector[true, false, false], 0);
        assert!(vector[false, true || false] == vector[false, true], 0);
        assert!(vector[false, true != false] == vector[false, true], 0);

        // Assert equality and inequality of byte vectors
        assert!(E0, 0); // Both empty
        assert!(!E1, 0); // Empty vs non-empty
        assert!(E2, 0); // Equal bytes
        assert!(!E3, 0); // Different bytes

        // Assert nested vector equality
        assert!(V0[0] == vector[10, 20], 0);
        assert!(V0[2] == vector[30], 0);
        assert!(V0[1] == vector[], 0);

        // Additional check: compare nested vectors with logical expressions
        let nested_bool: vector<bool> = vector[true && true, false || false];
        assert!(nested_bool == vector[true, false], 0);
    }
}

//#run 0x1::BoolAndByteVectorTest::test_vectors