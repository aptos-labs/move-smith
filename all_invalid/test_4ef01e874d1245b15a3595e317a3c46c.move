//# publish --print-bytecode
module 0x50::resource_test {
    // Define a resource with key and drop capability
    struct AttrResource has key, drop {
        value: u64,
    }

    // Attempt to call invalid function with type that has key and drop
    public fun trigger_assert(addr: address) {
        assert!(exists<AttrResource>(addr), 0);
        let _ = borrow_global<AttrResource>(addr);
        move_from<AttrResource>(addr);
    }

    // Runner function to invoke invalid with type having key + drop
    public fun run_trigger() {
        trigger_assert(@0x50);
    }
}

//# publish --print-bytecode
module 0x51::vector_ops {
    use std::vector;

    // Create an unsorted vector
    public fun create_unsorted() : vector<u64> {
        vector::<u64>[10, 5, 20, 15]
    }

    // Create a sorted vector
    public fun create_sorted() : vector<u64> {
        vector::<u64>[5, 10, 15, 20]
    }

    // Clone vector
    public fun clone_vector(vec: &vector<u64>) : vector<u64> {
        let mut new_vec = vector::empty<u64>();
        let len = vector::length<u64>(vec);
        let mut i: u64 = 0;
        while (i < len) {
            vector::push_back::<u64>(&mut new_vec, *vector::borrow::<u64>(vec, i));
            i = i + 1;
        }
        new_vec
    }

    // Sort the vector in ascending order
    public fun sort(vec: &mut vector<u64>) {
        let len = vector::length::<u64>(vec);
        let mut i: u64 = 0;
        while (i < len) {
            let mut j: u64 = i + 1;
            while (j < len) {
                if (*vector::borrow::<u64>(vec, i) > *vector::borrow::<u64>(vec, j)) {
                    vector::swap::<u64>(vec, i, j);
                }
                j = j + 1;
            }
            i = i + 1;
        }
    }

    // Check if two vectors are equal
    public fun vectors_equal(x: &vector<u64>, y: &vector<u64>) : bool {
        let l1 = vector::length::<u64>(x);
        let l2 = vector::length::<u64>(y);
        if (l1 != l2) { return false; }
        let mut i: u64 = 0;
        while (i < l1) {
            if (*vector::borrow::<u64>(x, i) != *vector::borrow::<u64>(y, i)) {
                return false;
            }
            i = i + 1;
        }
        true
    }

    // Main function to test vector behaviors
    public fun main() {
        let unsorted = create_unsorted();
        let sorted = create_sorted();

        // Clone the unsorted vector
        let cloned = clone_vector(&unsorted);
        // Verify clone matches original
        assert!(vectors_equal(&unsorted, &cloned), 50);

        // Clone the sorted vector
        let cloned_sorted = clone_vector(&sorted);
        // Verify clone matches original sorted
        assert!(vectors_equal(&sorted, &cloned_sorted), 52);

        // Sort the unsorted vector
        let mut unsorted_copy = clone_vector(&unsorted);
        sort(&mut unsorted_copy);
        // After sorting, it should equal the sorted vector
        assert!(vectors_equal(&unsorted_copy, &sorted), 55);

        // Assert that unsorted and sorted are not initially equal
        assert!(!vectors_equal(&unsorted, &sorted), 57);
        // Confirm that sorted vector remains sorted
        let mut sorted_copy = clone_vector(&sorted);
        sort(&mut sorted_copy);
        assert!(vectors_equal(&sorted_copy, &sorted), 59);
    }
}

//# run --signers 0x50
script {
    use 0x50::resource_test::run_trigger;
    use 0x51::vector_ops::main;

    fun main(s: &signer) {
        run_trigger();
        main();
    }
}