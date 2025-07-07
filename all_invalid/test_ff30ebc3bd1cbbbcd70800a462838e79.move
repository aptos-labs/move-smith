//# publish
module 0xabcde::test_module {
    struct DataHolder has copy, drop {
        x: u64,
        y: u64,
        z: u64,
        w: u64,
        v: u64,
    }

    /// Function to perform sequential copying of variables and return the final struct.
    fun sequential_copy(p: DataHolder): DataHolder {
        let first = p;
        let second = first;
        let third = second;
        let fourth = third;
        let fifth = fourth;
        fifth
    }

    /// Runner function to test variable assignments and struct integrity.
    public fun run_sequential_copy() {
        let initial = DataHolder {x: 10, y: 20, z: 30, w: 40, v: 50};
        let result = sequential_copy(initial);
        assert!(
            result == DataHolder {x: 10, y: 20, z: 30, w: 40, v: 50},
            0
        );
    }

    /// Function to verify that copying and reassignments do not alter the original data.
    public fun verify_copy_integrity() {
        let original = DataHolder {x: 100, y: 200, z: 300, w: 400, v: 500};
        // Perform a sequence of reassignments
        let a = original;
        let b = a;
        let c = b;
        let d = c;
        let e = d;
        // Check the final struct
        assert!(
            e == original,
            0
        );
    }

    /// Function to test multiple reassignments and ensure immutability of original values.
    public fun multiple_reassignments() {
        let val = DataHolder {x: 7, y: 14, z: 21, w: 28, v: 35};
        let first_copy = val;
        let second_copy = first_copy;
        let mut mutable_copy = second_copy;
        // Modify mutable_copy's fields arbitrarily
        mutable_copy = DataHolder {x: 1, y: 2, z: 3, w: 4, v: 5};
        // original val remains unchanged
        assert!(
            val == DataHolder {x: 7, y: 14, z: 21, w: 28, v: 35},
            0
        );
        // the mutable_copy has new values
        assert!(
            mutable_copy == DataHolder {x: 1, y: 2, z: 3, w: 4, v: 5},
            0
        );
    }
}

//# run 0xabcde::test_module::run_sequential_copy
//# run 0xabcde::test_module::verify_copy_integrity
//# run 0xabcde::test_module::multiple_reassignments