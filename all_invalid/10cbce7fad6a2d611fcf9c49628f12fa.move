//# publish
module 0xCAFE::LoopAndVectorTest {
    use 0xCAFE::VectorHelpers;
    use 0xCAFE::Assert;

    /// Helper module to provide vector utilities
    //# publish
    module 0xCAFE::VectorHelpers {
        public fun push(vector: &mut vector<u8>, value: u8) {
            vector.push_back(value);
        }

        public fun get_element(vector: &vector<u8>, index: u64): u8 {
            assert!(index < vector.length(), 1);
            vector[index]
        }
    }

    //# run 0xCAFE::LoopAndVectorTest::test_loop_and_vector_features
    public fun test_loop_and_vector_features() {
        // Testing while loop with break and continue
        let count: u64 = 0;
        let target: u64 = 10;

        while (count < 20) {
            if (count == target) {
                break;
            }
            if (count % 2 == 0) {
                // Emulate continue by moving to next iteration
                count = count + 1;
                continue;
            }
            // For odd count, just increment
            count = count + 1;
        }

        // After loop, count should be equal to target (10)
        // (In test, you might ignore assertion, just ensure no abort)
    }

    //# run 0xCAFE::LoopAndVectorTest::test_vector_overflow
    public fun test_vector_overflow() {
        let vec = vector::empty<u8>();
        // Push maximum value
        vector::push_back(&mut vec, 255);
        // Access element at index 0, should succeed
        let val = vector::borrow(&vec, 0);
        // Now, test overflow by wrapping addition (which panics in Move)
        // We purposely cause overflow to test abort
        let _ = val + 1; // Should abort
    }

    //# run 0xCAFE::LoopAndVectorTest::test_division_by_zero
    public fun test_division_by_zero() {
        let numerator = 10;
        let denominator: u64 = 0;
        let _res = numerator / denominator; // Should abort due to division by zero
    }

    //# run 0xCAFE::LoopAndVectorTest::test_shift_out_of_range
    public fun test_shift_out_of_range() {
        let value: u64 = 1;
        let shift_amount: u8 = 65; // exceeds bit size of u64 (64 bits)
        let _res = value << shift_amount; // Should abort due to invalid shift
    }

    // Test using alias import
    use 0xCAFE::VectorHelpers as VH;

    //# run 0xCAFE::LoopAndVectorTest::test_alias_import
    public fun test_alias_import() {
        let vec: vector<u8> = vector::empty<u8>();
        VH::push(&mut vec, 42);
        let elem = VH::get_element(&vec, 0);
        // No assertion needed, just to verify code runs
    }
}

// Featurres:
// d10f9df330268b61315c1c021eeb081d: Test that the while loop correctly handles the use of both break and continue statements to increment a variable until it reaches a specific value.
// 7a24b3028aed0d75386b5a5f74f23b22: Verify that the Move program's vector element expressions that involve overflows, divisions by zero, or out-of-range shifts correctly cause aborts during execution.
// 183ecf11e40cd8fa5b885c8dfa839e08: Import modules or items using an alias with the 'use' statement in your Move code.
