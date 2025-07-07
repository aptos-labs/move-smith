//#publish
module 0xDEADBEEF::vector_tests {
    use std::vector;

    // Testing behavior of copying vectors after control flow with multiple nested breaks and continues
    public fun copy_after_control_flow(farr: vector<u8>) {
        let i = 0;
        let j = 0;
        while (i < vector::length(&farr)) {
            if (*vector::borrow(&farr, i) == 1) {
                break;
            }
            if (*vector::borrow(&farr, i) == 2) {
                break;
            }
            i = i + 1;
        }
        // Inside nested loop with break
        while (j < vector::length(&farr)) {
            if (*vector::borrow(&farr, j) == 3) {
                break;
            }
            if (*vector::borrow(&farr, j) == 4) {
                continue;
            }
            j = j + 1;
        }
        // copy vector to ensure no invariant violation
        let v_copy = copy farr;
        let v2 = farr;
        // Use v_copy and v2 to test that copying doesn't cause issues
    }

    // Testing the same with assert to cause abort if invariant violated
    public fun assert_after_control_flow(farr: vector<u8>) {
        let k = 0;
        while (k < vector::length(&farr)) {
            assert!(*vector::borrow(&farr, k) != 5, 42);
            if (*vector::borrow(&farr, k) == 6) {
                break;
            }
            k = k + 1;
        }
        let v_copy = copy farr;
        let v2 = farr;
    }

    // Testing with no control flow effects
    public fun no_control_flow_copy(farr: vector<u8>) {
        let len = vector::length(&farr);
        let mut idx = 0;
        while (idx < len) {
            idx = idx + 1;
        }
        let v_copy = copy farr;
        let v2 = farr;
    }

    // Testing continue inside nested loops with nested conditionals
    public fun continue_nested(farr: vector<u8>) {
        let i = 0;
        while (i < vector::length(&farr)) {
            if (*vector::borrow(&farr, i) == 7) {
                i = i + 1;
                continue;
            }
            if (*vector::borrow(&farr, i) == 8) {
                break;
            }
            i = i + 1;
        }
        let v_copy = copy farr;
        let v2 = farr;
    }

    // Running all above tests
    public fun run_tests() {
        let test_vector = vector[0, 1, 2, 3, 4, 5, 6, 7, 8, 9];

        copy_after_control_flow(test_vector);
        assert_after_control_flow(test_vector);
        no_control_flow_copy(test_vector);
        continue_nested(test_vector);
    }
}
//#run 0xDEADBEEF::vector_tests::run_tests

//#publish
module 0xCAFEBABE::unsigned_literal_tests {
    fun verify_literals() {
        // testing various hex with leading zeros
        assert!(15u8 == 0xFu8, 100);
        assert!(15u8 == 0x0Fu8, 100);
        assert!(255u8 == 0xFFu8, 100);
        assert!(255u8 == 0x0FFu8, 100);

        assert!(15u16 == 0xFu16, 100);
        assert!(15u16 == 0x0Fu16, 100);
        assert!(255u16 == 0xFFu16, 100);
        assert!(255u16 == 0x0FFu16, 100);
        assert!(4095u16 == 0xFFFu16, 100);
        assert!(65535u16 == 0xFFFFu16, 100);
        assert!(65535u16 == 0x00FFFFu16, 100);
        
        assert!(15u32 == 0xFu32, 100);
        assert!(15u32 == 0x0Fu32, 100);
        assert!(255u32 == 0xFFu32, 100);
        assert!(255u32 == 0x0FFu32, 100);
        assert!(4095u32 == 0xFFFu32, 100);
        assert!(65535u32 == 0xFFFFu32, 100);
        assert!(4294967295u32 == 0xFFFFFFFFu32, 100);
        assert!(4294967295u32 == 0x00FFFFFFFFu32, 100);

        assert!(15u64 == 0xFu64, 100);
        assert!(15u64 == 0x0Fu64, 100);
        assert!(255u64 == 0xFFu64, 100);
        assert!(255u64 == 0x0FFu64, 100);
        assert!(18446744073709551615u64 == 0xFFFFFFFFFFFFFFFFu64, 100);
        assert!(18446744073709551615u64 == 0x0FFFFFFFFFFFFFFFFu64, 100);

        assert!(15u128 == 0xFu128, 100);
        assert!(15u128 == 0x0Fu128, 100);
        assert!(255u128 == 0xFFu128, 100);
        assert!(255u128 == 0x0FFu128, 100);
        assert!(18446744073709551615u128 == 0xFFFFFFFFFFFFFFFFu128, 100);
        assert!(18446744073709551615u128 == 0x0FFFFFFFFFFFFFFFFu128, 100);
        assert!(
            340282366920938463463374607431768211455u128
            == 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFu128,
            100,
        );
        assert!(
            340282366920938463463374607431768211455u128
            == 0x0FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFu128,
            100,
        );

        // testing large unsigned integers (simulated with u256 as a placeholder)
        // move doesn't natively support u256; assume custom type for test
        // We'll just demonstrate the syntax
        // Note: For actual implementation, you'd require custom types or library support
        // For demonstration, just asserting literals
        // e.g.,
        // assert!(115792089237316195423570985008687907853269984665640564039457584007913129639935u256 
        //    == 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFu256, 100);
    }

    fun run_tests() {
        verify_literals();
    }
}
//#run 0xCAFEBABE::unsigned_literal_tests::run_tests