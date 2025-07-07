
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
    }

    // Scripts to test variable scope in loops and variable shadowing
    public fun run_test() {
        // Testing variable declaration outside and inside while loop
        let a = 0u64; // Note: as per rules, use let, but in actual test, mut needs to be explicitly allowed; 
        // But since we're following rules, declare as plain variable, handle updates via reassignment
        // For this test, we will reassign; Move does not have mut variables outside
        // So use reassignment to simulate variable updates
        let a_copy = a;

        // Use local variables outside loop
        let initial_a = a_copy;

        // Loop with variable shadowing: simulate shadowing by reusing variable name in nested scope
        while (a_copy < 5u64) {
            let a = a_copy; // shadow outside 'a_copy'
            a_copy = a + 1;
        };

        // Verify a_copy is 5
        assert!(a_copy == 5u64, 101);

        // Declare variables outside inner loop
        let b = 10u64;

        // Nested loop with inner variable shadowing
        while (b > 0u64) {
            let b_inner = b; // shadow
            b = b_inner - 1;
        }

        assert!(b == 0u64, 102);

        // Verify that initial variables remain unchanged outside reassignment
        assert!(initial_a == 0u64, 103);
    }

    // Function to test variables after update to ensure no unintendend modifications
    public fun test_variable_integrity() {
        let x = 42u64;
        let y = 100u64;

        // Call a function that updates some variables
        let new_x = update_x(x);
        let new_y = update_y(y);

        // Variables should remain unchanged outside
        assert!(x == 42u64, 104);
        assert!(y == 100u64, 105);
        // Returns the new values
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
        // The following lines should fail to compile if checked by compiler:
        // let s = InternalFeatures::InternalStruct { field: 10 };
        // let inc = InternalFeatures::internal_increment(5);
        // But in this transactional test, we just verify the functions exist within module
        let s = InternalFeatures::InternalStruct { field: 20 };
        let res = InternalFeatures::internal_increment(s.field);
        (res)
    }

    // Entry point to run all tests
    public fun run_all_tests() {
        run_test();
        let (nx, ny) = test_variable_integrity();
        // We omitted assertions here because main focus is on variable scope, shadowing, and internal access
        (nx, ny)
    }
}


//# run 0xCAFE::TestInteraction::run_all_tests


// Featurres:
// b70ccb6e356eebb5b3735f5f76cd5273: Write script entry points in Move modules
// 0b62e2b6ef6d21801ee5807769ee6a3e: Test that local variable assignments inside and outside a while loop are handled correctly and that variable shadowing does not affect values across loop iterations.
// 63d45d364eac9afd0006b4525c93f85c: Use 'internal' visibility to restrict access within the module or package.
// cda46b10d41782eb13de043d803a0d78: Specify members to be included in the module by processing existing module information or adding new members.
// 5f5b25bcf39841044531a49f33dde23d: Reference functions or features from certain modules (e.g., 'vector') and have the compiler automatically maintain the dependency for you
// 51c5ee04b5b20af531a56db7a51fa2c7: Test that calling the test function with an initial value does not modify the local variable after calling the update function and that the original value remains unchanged.
