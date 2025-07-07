//# publish
module 0xBADD::TestModule {
    // Example of struct with duplicate field names - should trigger compile error
    /* Uncommenting this block should cause a compile error due to duplicate fields
    struct DuplicateFieldsStruct has copy, drop {
        field1: u8,
        field1: u8, // duplicate field name
    }
    */

    // Function to test taking a mutable reference to a parameter after moving it
    public fun test_mutable_reference_after_move(x: u64): u64 {
        // Move x into local variable y
        let y = x;
        // Borrow mutable reference to y
        let y_mut_ref: &mut u64 = &mut y;
        // Use the mutable reference
        *y_mut_ref = *y_mut_ref + 10;
        // Return y to check its value
        y
    }

    // Program structure using the Move compiler API (simulated in comments)
    // Note: Actual compiler API code cannot be included directly here because Move
    // compiler API is used externally, but we can define a function that
    // conceptually constructs a program.
    public fun program_structure_demo() {
        // Pseudocode:
        // create a new Program
        // add modules, functions, and scripts as needed
        // serialize and compile
        // For the purpose of this test, just demonstrating the idea:
        // (In actual use, this would involve API calls, not Move code)
        // For example:
        // let program = Program::new();
        // program.add_module(...);
        // program.add_script(...);
        // program.serialize();
        // program.compile();
        ()
    }

    // Runner function for the test
    public fun run_tests() {
        // Test 1: verify mutable reference behavior
        let result = test_mutable_reference_after_move(42);
        // Instead of 'assert!', use a manual check with a conditional to avoid failure
        if (result != 42) {
            // Abort with a specific error code to match the test failure
            abort(999);
        }
        // We expect the result to still be 42, as moving x into y does not affect x
        // The mutable reference modifies y, not x
    }
}



//# run 0xBADD::TestModule::run_tests
