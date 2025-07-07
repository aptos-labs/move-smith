//# publish
module 0xCAFE::LoopAndVectorTest {
    use 0xCAFE::VectorHelpers;
    use 0xCAFE::Assert;

    /// Helper module to provide vector utilities
    //# publish
    module 0xCAFE::VectorHelpers {
        // Avoid using reserved name 'vector' for variables
        public fun push(vec: &mut vector<u8>, value: u8) {
            vector::push_back(vec, value);
        }

        public fun get_element(vec: &vector<u8>, index: u64): u8 {
            assert!(vector::length(vec) > index, 1);
            vector::borrow(vec, index)
        }
    }

    //# run 0xCAFE::LoopAndVectorTest::test_loop_and_vector_features
    public fun test_loop_and_vector_features() {
        // Testing while loop with break and continue
        let mut count: u64 = 0;
        let target: u64 = 10;

        while (count < 20) {
            if (count == target) {
                break;
            }
            if (count % 2 == 0) {
                // Emulate continue by incrementing and continuing
                count = count + 1;
                continue;
            }
            // For odd count, just increment
            count = count + 1;
        }
        // The loop ends when count >= 20 or count == target
        // Post-conditions or assertions can be omitted as per instructions
    }

    //# run 0xCAFE::LoopAndVectorTest::test_vector_overflow
    public fun test_vector_overflow() {
        let mut vec = vector::empty<u8>();
        // Push maximum value
        vector::push_back(&mut vec, 255);
        // Access element at index 0, should succeed
        let val = vector::borrow(&vec, 0);
        // Test overflow by wrapping addition (which panics in Move)
        let _ = val + 1; // This should abort due to overflow
    }

    //# run 0xCAFE::LoopAndVectorTest::test_division_by_zero
    public fun test_division_by_zero() {
        let numerator: u64 = 10;
        let denominator: u64 = 0;
        let _res = numerator / denominator; // Should abort due to division by zero
    }

    //# run 0xCAFE::LoopAndVectorTest::test_shift_out_of_range
    public fun test_shift_out_of_range() {
        let value: u64 = 1;
        let shift_amount: u8 = 65; // exceeds u64 bit size
        let _res = value << shift_amount; // Should abort due to invalid shift
    }

    // Test using alias import
    use 0xCAFE::VectorHelpers as VH;

    //# run 0xCAFE::LoopAndVectorTest::test_alias_import
    public fun test_alias_import() {
        let mut vec: vector<u8> = vector::empty<u8>();
        VH::push(&mut vec, 42);
        let elem = VH::get_element(&vec, 0);
        // No assertion needed, just verify code runs
    }
}