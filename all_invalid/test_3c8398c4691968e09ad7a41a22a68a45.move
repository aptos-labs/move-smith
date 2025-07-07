//# publish
module 0xabcd::vector_borrow_modify {
    use std::vector;

    // Function to test copying and modifying a vector of u8
    public fun test_copy_and_modify(v: vector<u8>) {
        // Call an inline helper that uses loop with break
        process_vector_with_break(&v);
        // Copying the vector after processing should be safe
        let _copy1 = copy v; // should succeed
        // Direct assignment (move) of vector
        let _move1 = v; // should succeed
    }

    // Inline function with a loop containing a break
    inline fun process_vector_with_break(vec: &vector<u8>) {
        let i = 0;
        while (i < vector::length(vec)) {
            if (*vector::borrow(vec, i) == 255) {
                break
            };
            // attempt to modify element
            // Note: cannot directly modify via borrow in current Move semantics
            // Instead, demonstrate shadowing or a placeholder logic
            i = i + 1;
        }
    }

    // Function with a loop that does not contain break
    public fun process_vector_without_break(vec: &vector<u8>) {
        let i = 0;
        while (i < vector::length(vec)) {
            // Read and assert
            let val = *vector::borrow(vec, i);
            assert!(val <= 255, 0);
            i = i + 1;
        }
        // After processing, copying should be safe
        let _copy2 = copy vec; // should succeed
    }

    // Function that copies vector directly
    public fun copy_vector(v: vector<u8>): vector<u8> {
        copy v
    }

    // Runner function, to test shadowing and variable capture
    public fun run_shadow_capture() {
        let x = 2;
        // Define a closure that accesses outer variable x
        // Move semantics do not allow modifying captured variables directly
        // but for test, simulate shadowing
        let change_x = |y: u64| {
            // Shadow outer x
            let x = y;
            // x is local to closure
        };
        change_x(3);
        // To test modification, define a mutable variable
        let mut outer_x = 1;
        // Define a function that captures mutable reference
        fun modify_outer_x(val: u64) {
            outer_x = val;
        }
        modify_outer_x(3);
        // outer_x should now be 3
        // For assertion, but as per instruction, assertions are optional
    }

    // Entry points / test cases
    public fun test_logic() {
        let vec = vector[1, 2, 3, 4];
        process_vector_with_break(&vec);
        process_vector_without_break(&vec);
        let copied = copy_vector(vec);
        // For shadowing test
        run_shadow_capture();
    }
}

//# run 0xabcd::vector_borrow_modify::test_logic