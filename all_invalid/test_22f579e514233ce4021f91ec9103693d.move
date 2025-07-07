//# publish
module 0xA117::vector_tests {
    use std::vector;

    // Function to create a vector with sorted u64 values
    fun create_sorted_vector(): vector<u64> {
        vector::empty<u64>()
        |> (v) {
            vector::push_back<u64>(&mut v, 10);
            vector::push_back<u64>(&mut v, 5);
            vector::push_back<u64>(&mut v, 20);
            vector::push_back<u64>(&mut v, 15);
            v
        }
    }

    // Function to create an unsorted vector
    fun create_unsorted_vector(): vector<u64> {
        vector::empty<u64>()
        |> (v) {
            vector::push_back<u64>(&mut v, 20);
            vector::push_back<u64>(&mut v, 10);
            vector::push_back<u64>(&mut v, 15);
            vector::push_back<u64>(&mut v, 5);
            v
        }
    }

    // Clone a vector of u64
    fun clone_vector(x: &vector<u64>): vector<u64> {
        let y: vector<u64> = vector::empty<u64>();
        let len: u64 = vector::length<u64>(x);
        let i: u64 = 0;
        while (i < len) {
            vector::push_back<u64>(&mut y, *vector::borrow<u64>(x, i));
            i = i + 1;
        }
        y
    }

    // Simple bubble sort implementation
    fun sort_in_place(x: &mut vector<u64>) {
        let len: u64 = vector::length<u64>(x);
        let i: u64 = 0;
        while (i < len) {
            let j: u64 = 0;
            while (j + 1 < len) {
                if (*vector::borrow<u64>(x, j) > *vector::borrow<u64>(x, j + 1)) {
                    vector::swap<u64>(x, j, j + 1);
                }
                j = j + 1;
            }
            i = i + 1;
        }
    }

    // Check if two vectors are equal
    fun vectors_equal(x: &vector<u64>, y: &vector<u64>): bool {
        let len_x: u64 = vector::length<u64>(x);
        let len_y: u64 = vector::length<u64>(y);
        if (len_x != len_y) {
            return false;
        }
        let i: u64 = 0;
        while (i < len_x) {
            if (*vector::borrow<u64>(x, i) != *vector::borrow<u64>(y, i)) {
                return false;
            }
            i = i + 1;
        }
        true
    }

    public fun main() {
        // Original vectors
        let unsorted: vector<u64> = create_unsorted_vector();
        let sorted_expected: vector<u64> = create_sorted_vector();

        // Clone unsorted vector
        let clone_of_unsorted: vector<u64> = clone_vector(&unsorted);
        // Verify clone is equal to original
        assert!(vectors_equal(&unsorted, &clone_of_unsorted), 42);

        // Clone sorted vector
        let sorted_clone: vector<u64> = clone_vector(&sorted_expected);
        // Verify clone is equal to original sorted
        assert!(vectors_equal(&sorted_expected, &sorted_clone), 43);

        // In-place sort of unsorted vector
        let mut unsorted_mut: vector<u64> = clone_vector(&unsorted);
        sort_in_place(&mut unsorted_mut);
        // After sorting, it should match the sorted_expected
        assert!(vectors_equal(&sorted_expected, &unsorted_mut), 44);

        // Solve the assertion for unordered comparison
        // The sorted vector should not be equal to the original unsorted vector
        // even before sorting
        assert!(!vectors_equal(&unsorted, &unsorted_mut), 45);
        
        // Also, ensure that sorting a vector already sorted does not change it
        let mut sorted_again: vector<u64> = clone_vector(&sorted_expected);
        sort_in_place(&mut sorted_again);
        assert!(vectors_equal(&sorted_expected, &sorted_again), 46);
    }
}

//# run 0xA117::vector_tests::main --signers 0x1