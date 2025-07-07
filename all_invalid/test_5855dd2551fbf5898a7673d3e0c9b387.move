//# publish
module 0xA11E::InlineFunctionTest {
    inline fun compute_if(g: |u8, u8| u8, condition: bool, a: u8, b: u8): u8 {
        if (condition) {
            g(a, b)
        } else {
            0
        }
    }

    public fun run_test() {
        let result_true = compute_if(|x, y| x + y, true, 5, 10);
        let result_false = compute_if(|x, y| x * y, false, 3, 4);
        // The following are assertions just for internal testing purposes
        assert!(result_true == 15, 0);
        assert!(result_false == 0, 1);
    }
}

//# run 0xA11E::InlineFunctionTest::run_test

//# publish
module 0xA11E::ScalarInitializer {
    use std::vector;

    struct Scalar has copy, store, drop {
        data: vector<u8>
    }

    /// Creates a Scalar with the specified byte value as its first byte.
    public fun create_scalar_with_value(byte: u8): Scalar {
        let s = scalar_zero();
        let first_byte = vector::borrow_mut(&mut s.data, 0);
        *first_byte = byte;
        s
    }

    /// Returns a Scalar filled with zeros.
    public fun scalar_zero(): Scalar {
        Scalar {
            data: vector::empty<u8>()
        }
    }

    public fun run_test() {
        let scalar_42 = create_scalar_with_value(42);
        let first_byte = vector::borrow(&scalar_42.data, 0);
        assert!(*first_byte == 42, 0);
        
        let scalar_ff = create_scalar_with_value(255);
        let first_byte_ff = vector::borrow(&scalar_ff.data, 0);
        assert!(*first_byte_ff == 255, 1);
    }
}

//# run 0xA11E::ScalarInitializer::run_test