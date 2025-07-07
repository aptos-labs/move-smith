
//# publish
module 0xBADD::TestModule {
    use std::vector;
    use std::debug;

    // Helper function to test logging when logger is already installed
    public fun test_logger_installation() {
        // Call some debug function to simulate logger involved
        debug::print(b"Logger test started");
    }
}

 
//# run 0xBADD::TestModule::test_logger_installation


//# publish
module 0xBADD::ConditionalLoopTest {
    use std::vector;
    use std::debug;

    public fun run_conditionals_and_loops(): u64 {
        let x = 0u64;
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


// Featurres:
// de2140cd3b814ad3fd0cf0b16b451553: Use 'if' and 'else' statements within the loop to update the loop index and flag variables.
// 2a5422f316ef62fe7d9ca4c5e83b59c2: Test mapping over constant empty vectors with lambdas that use references and type annotations.
// eb6cca76eb76d49ed4fba425009e8264: Rely on the function to handle the case where a logger is already installed without failing.
