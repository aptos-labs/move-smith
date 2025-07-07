//# publish
module 0x123::counter {
    fun inc(counter: &mut u64, step: u64): u64 {
        *counter = *counter + step;
        *counter
    }

    public fun compute_sum(initial: u64): u64 {
        let counter = initial;
        let first_inc = inc(&mut counter, 3);
        let second_inc = inc(&mut counter, 5);
        first_inc + second_inc + counter
    }

    public fun run_all() {
        let result = compute_sum(10);
    }
}

//# run 0x123::counter::run_all

//# publish
module 0x456::vector_ops {
    use std::vector;

    fun create_vector(): vector<u64> {
        vector[4, 8, 15, 16, 23, 42]
    }

    // Custom function to remove element at index i
    public fun remove_at(v: &mut vector<u64>, i: u64): u64 {
        use std::vector;
        let len = vector::length(v);
        if (i >= len) abort 1;

        if (i < len - 1) {
            vector::swap(v, i, len - 1);
        }
        vector::pop_back(v)
    }

    // Function to fold over a vector and compute sum
    public fun sum_vector(v: &vector<u64>): u64 {
        use std::vector;
        vector::fold(v, 0, |acc, val| *acc + *val)
    }

    public fun test_remove_and_fold() {
        let mut v = create_vector();
        let removed = remove_at(&mut v, 2);
        // v should now be [4, 8, 16, 23, 42]
        assert!(*vector::borrow(&v, 0) == 4, 0);
        assert!(*vector::borrow(&v, 2) == 16, 0);
        assert!(vector::length(&v) == 5, 0);
        // sum of remaining vector
        let sum = sum_vector(&v);
        assert!(sum == 4 + 8 + 16 + 23 + 42, 0);
        // removed element should be 15
        assert!(removed == 15, 0);
    }
}

//# run 0x456::vector_ops::test_remove_and_fold