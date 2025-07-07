//# publish
module 0xdeadbeef::tuple_mod {
    // This module tests multiple local variable assignments via tuple destructuring
    // with sequential modifications within the function.
    public fun test_destructuring(): u64 {
        let x;
        let y;
        let z;
        let w;
        // Initialize variables with constants and manipulate some along the way
        (x, y, z, w) = (10, { let temp = 5; temp }, { let temp = 3; temp + 2 }, { let mut a = 1; a = a * 2; a });
        // Further modify some variables after destructuring
        (x, y) = (x + y, y + z);
        (z, w) = (z + w, w + 10);
        // Sum all variables to produce result
        x + y + z + w
    }
}

//# run 0xdeadbeef::tuple_mod::test_destructuring

//# publish
module 0xbeefcafe::copy_vector {
    use std::vector;

    // Function that demonstrates copying vectors with sequential modifications inside functions
    public entry fun test_vector_copy(vec: vector<u8>) {
        // Call helper function with inline loop containing break
        process_vector_with_break(&vec);
        // Copy the vector (should succeed)
        let _vec_copy = copy vec; 

        // Again, assign original vector to new variable (valid in Move)
        let _vec_alias = vec;
    }

    pub fun process_vector_with_break(vec: &vector<u8>) {
        let mut i = 0;
        while (i < vector::length(vec)) {
            if (*vector::borrow(vec, i) != 0) {
                break;
            };
            // Increment element at position i
            // Since in Move we can't mutate via borrow directly, assume we have a way to mutate for complex tests
            // For simplicity, skip mutation here; just demonstrate loop with break
            i = i + 1;
        }
    }

    // Directly process vector without inline loop with break
    pub entry fun test_vector_no_break(vec: vector<u8>) {
        let mut index = 0;
        while (index < vector::length(&vec)) {
            assert!(*vector::borrow(&vec, index) >= 0, 4);
            index = index + 1;
        }
        let _v_copy = copy vec; // Should succeed
    }

    // Function that uses non-inline loop with break
    pub fun process_vector_with_break_no_inline(vec: &vector<u8>) {
        let mut i = 0;
        while (i < vector::length(vec)) {
            if (*vector::borrow(vec, i) == 0) {
                break;
            }
            i = i + 1;
        }
        // After break or completion, copying should be safe
        let _copy1 = copy vec;
        let _copy2 = vec;
    }

    // Function that uses inline loop without break
    inline fun process_vector_without_break(vec: &vector<u8>) {
        let mut idx = 0;
        while (idx < vector::length(vec)) {
            assert!(*vector::borrow(vec, idx) >= 0, 4);
            idx = idx + 1;
        }
    }

    // Entry point to test vector copying after processing
    public fun run_tests() {
        let v = vector[1, 0, 2, 0, 3];
        test_vector_with_break(v);
        test_vector_no_break(v);
        process_vector_with_break_no_inline(&v);
        process_vector_without_break(&v);
    }

    fun test_vector_with_break(v: vector<u8>) {
        process_vector_with_break(&v);
        let _copy = copy v; // safe copy after processing
    }
}

//# run 0xbeefcafe::copy_vector::run_tests