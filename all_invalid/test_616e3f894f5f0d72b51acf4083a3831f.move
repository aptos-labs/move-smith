//# publish
module 0xA::test_scalar_and_early_return {
    use std::vector;

    // Define a Scalar struct similar to the example
    struct Scalar has copy, store, drop {
        data: vector<u8>
    }

    /// Creates a Scalar from an u8.
    public fun new_scalar_from_u8(byte: u8): Scalar {
        let s = scalar_zero();
        let byte_zero = vector::borrow_mut(&mut s.data, 0);
        *byte_zero = byte;
        s
    }

    /// Returns 0 as a Scalar.
    public fun scalar_zero(): Scalar {
        Scalar {
            data: vector::empty<u8>()
        }
    }

    // Define a runner function to test `new_scalar_from_u8`
    public fun run_new_scalar_from_u8_test() {
        let test_value: u8 = 0xAB;
        let scalar = new_scalar_from_u8(test_value);
        // For testing, borrow the first byte and check if it equals test_value
        let byte_ref = vector::borrow(&scalar.data, 0);
        assert!(*byte_ref == test_value, 999);
    }
}

//# run 0xA::test_scalar_and_early_return::run_new_scalar_from_u8_test