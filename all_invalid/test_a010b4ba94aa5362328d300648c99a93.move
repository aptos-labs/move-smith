//# publish
module 0xDEADBEEF::VectorComparison {
    use std::vector;

    // Function to create two identical large vectors of zeros
    public fun create_zero_vectors(): (vector<u8>, vector<u8>) {
        let vec1 = vector[
            0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
            0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
            0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
            0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
            // Repeat to make large vector
            0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
            0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
            // ... (additional repetition as needed to ensure large size)
        ];
        let vec2 = vector[
            0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
            0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
            // Repeat similarly to create identical vector
            0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
            0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
            // Ensure vectors are large and identical for comparison
            // ... (additional repetition)
        ];
        (vec1, vec2)
    }

    // Function to compare two vectors for equality
    public fun compare_vectors(vec1: &vector<u8>, vec2: &vector<u8>): bool {
        vector::len(vec1) == vector::len(vec2) && vector::elements_equal(vec1, vec2)
    }
}

//# run 0xDEADBEEF::VectorComparison::main
/// #spawn 0x1 as admin // optional, assuming some signer is needed
public fun main(): bool {
    let (v1, v2) = create_zero_vectors();
    compare_vectors(&v1, &v2)
}
//# run 0xDEADBEEF::VectorComparison::main

//# publish
module 0xBEAD::ShiftAndCompare {
    // Signer for testing
    use std::signer;

    // Function to test left shift operation
    public fun shifted_value(x: u8): u8 {
        x << 2 // shifting left by 2 bits
    }

    // Function to check if shifted value equals expected
    public fun verify_shift(original: u8, shifted: u8): bool {
        shifted == (original * 4)
    }

    // Runner function to test several values
    public fun run_tests() {
        let values = vector[u8] {1, 2, 3, 4, 128};
        let results = vector<bool>(vector::len(&values));
        let i = 0;
        while (i < vector::len(&values)) {
            let val = *vector::borrow(&values, i);
            let shifted = shifted_value(val);
            // compare shifted to expected
            vector::push_back(&mut results, verify_shift(val, shifted));
            i = i + 1;
        }
        // Return true if all tests pass
        vector::elements_equal(&results, &vector<bool> {true, true, true, true, true})
    }
}

//# run 0xBEAD::ShiftAndCompare::run_tests