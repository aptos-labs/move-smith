//# publish
module 0xCAFE::TestInteraction {
    use std::vector;

    // Module with internal functions and structs to test scope and visibility

//# publish
    module InternalFeatures {
        // Internal struct to test visibility restrictions
        struct InternalStruct has copy, drop, store {
            field: u32
        }

        // Internal function to test internal visibility
        fun internal_increment(val: u32): u32 {
            val + 1
        }
    } // End of InternalFeatures module

    // Scripts to test variable scope in loops and variable shadowing
    public fun run_test() {
        // Testing variable declaration outside and inside while loop
        let a: u64 = 0; // Declare as mutable
        let initial_a = a;

        // Loop with variable shadowing: simulate shadowing by reusing variable name in nested scope
        while (a < 5) {
            let a_shadow = a; // shadow outside 'a'
            a = a_shadow + 1;
        };

        // Verify a is 5
        assert!(a == 5, 101);

        // Declare variables outside inner loop
        let b: u64 = 10;

        // Nested loop with inner variable shadowing
        while (b > 0) {
            let b_shadow = b; // shadow
            b = b_shadow - 1;
        }

        assert!(b == 0, 102);

        // Verify that initial variables remain unchanged outside reassignment
        assert!(initial_a == 0, 103);
    }

    // Function to test variables after update to ensure no unintended modifications
    public fun test_variable_integrity() {
        let x: u64 = 42;
        let y: u64 = 100;

        // Call functions that update variables
        let new_x = update_x(x);
        let new_y = update_y(y);

        // Variables should remain unchanged outside
        assert!(x == 42, 104);
        assert!(y == 100, 105);
        // Return new values
        (new_x, new_y)
    }

    // Helper functions to simulate updates
    fun update_x(val: u64): u64 {
        val + 1
    }

    fun update_y(val: u64): u64 {
        val + 2
    }

    // Testing that internal functions and structs are not accessible externally
    public fun test_internal_visibility() {
        // Instantiate InternalStruct
        let s = InternalFeatures::InternalStruct { field: 20 };
        let res = InternalFeatures::internal_increment(s.field);
        (res)
    }

    // Entry point to run all tests
    public fun run_all_tests() {
        run_test();
        let (nx, ny) = test_variable_integrity();
        (nx, ny)
    }
}

//# run 0xCAFE::TestInteraction::run_all_tests
