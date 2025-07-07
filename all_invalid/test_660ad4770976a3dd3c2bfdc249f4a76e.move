//# publish
module 0x123::scalar_tests {
    use std::vector;

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
            data: vector::empty<u8>(),
        }
    }

    pub fun run_tests() {
        let test_value1 = 0xABu8;
        let scalar1 = new_scalar_from_u8(test_value1);
        let bytes_ref1 = &scalar1.data;
        let first_byte1 = *vector::borrow(bytes_ref1, 0);
        assert(first_byte1 == test_value1, 0);

        let test_value2 = 0x7Fu8;
        let scalar2 = new_scalar_from_u8(test_value2);
        let bytes_ref2 = &scalar2.data;
        let first_byte2 = *vector::borrow(bytes_ref2, 0);
        assert(first_byte2 == test_value2, 1);

        let test_value3 = 0x00u8;
        let scalar3 = new_scalar_from_u8(test_value3);
        let bytes_ref3 = &scalar3.data;
        let first_byte3 = *vector::borrow(bytes_ref3, 0);
        assert(first_byte3 == test_value3, 2);
    }
}

//# run 0x123::scalar_tests::run_tests


//# publish
module 0x456::enum_match_test {
    struct S0 has drop {}

    struct S1<A, B> has drop {
        x: A,
        y: B
    }

    enum E has drop {
        V1{ x: u8, y: S1<u8, bool>},
        V2 {
            y: S0,
            x: u8
        }
    }

    /// Extracts the last u8 value from an E enum.
    fun extract_last_u8(y: &E): u8 {
        match (y) {
            E::V1{ x: val_x, y: S1 { x: _, y: _ } } => *val_x,
            E::V2 { y: _, x } => *x,
        }
    }

    pub fun run_tests() {
        let v1 = E::V1 { x: 42, y: S1 { x: 0, y: false } };
        let v2 = E::V2 { y: S0 {}, x: 99 };

        // Testing match on V1 variant
        let res1 = extract_last_u8(&v1);
        assert(res1 == 42, 0);

        // Testing match on V2 variant
        let res2 = extract_last_u8(&v2);
        assert(res2 == 99, 1);
    }
}

//# run 0x456::enum_match_test::run_tests


//# publish
module 0x789::arithmetic_sequence {
    /// Performs multiple sequential arithmetic operations on a local variable and returns the final result.
    public fun compute_sequence(): u64 {
        let res = 10;
        let temp = res + 5;   // 15
        res = res * 2;        // error: reassigning immutable variable: 'res'
        // Correction: Use a mutable variable
    }

    // Corrected version with proper mutability
    public fun perform_sequence(): u64 {
        let mut res = 10;
        res = res + 5;        // 15
        res = res * 2;        // 30
        res = res - 4;        // 26
        res = res + 10;       // 36
        res
    }
}

//# run 0x789::arithmetic_sequence::perform_sequence