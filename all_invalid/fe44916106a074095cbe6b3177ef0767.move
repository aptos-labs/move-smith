
//# publish
module 0xBADD::TestModule {
    use std::debug; // Correctly import std::debug
    // note: std::vector is not needed as a 'use' alias in this code

    // Helper function to test logging when logger is already installed
    public fun test_logger_installation() {
        // Call some debug function to simulate logger involved
        debug::print(b"Logger test started");
    }
}

 

//# publish
module 0xBADD::ConditionalLoopTest {
    use std::vector;
    use std::debug; // Correctly import std::debug

    public fun run_conditionals_and_loops(): u64 {
        // Initialize mutable variables
        let x = 0u64; // variables need to be mutable if reassigned
        let flag = false;

        // For loop using while pattern with if-else to update index and flag
        let i = 0u64;
        while (i < 10) {
            if (i % 2 == 0) {
                flag = true;
            } else {
                flag = false;
            };
            x = x + i;
            i = if (flag) { i + 2 } else { i + 1 };
        };

        // Map over an empty vector with a lambda that uses references
        let empty_vec: vector<u8> = vector::empty<u8>();
        // Using a reference lambda
        let _ = vector::map_with_index(&empty_vec, |index: &u64, value: &u8| {
            debug::print(b"Mapping over empty vector");
            *value
        });

        // Ensure logger handles repeated call gracefully
        debug::print(b"Logger test for existing installation");
        debug::print(b"Logger test for existing installation");

        // Perform an operation relying on the loop logic
        x
    }
}

 

//# run 0xBADD::ConditionalLoopTest::run_conditionals_and_loops

// Note: No changes needed for features comments; they are just descriptive

