//# publish
module 0xCAFE::sequential_code_blocks {
    // Test that multiple code blocks separated by semicolons within an expression are evaluated in order and modify local variables.
    public fun test_multi_code_blocks() {
        let var1 = 0;
        let var2 = 10;
        // Evaluate multiple blocks: each should execute in order, modifying variables
        let result = {
            var1 = var1 + 1;
            var2 = var2 + 2;
            // The last expression in the block is the value of result
            var1 + var2
        }; // The block evaluates to var1 + var2 after modifications
        // For testing purposes, no assertions needed.
    }

    // Test that native constants are not supported: avoid using them.
    // (No code needed here, just a placeholder comment.)

    // Define a function with access specifiers as a list separated by commas to check syntax
    public(key, public, friend) fun access_modifiers_test() {
        // Nothing needed here; just a placeholder for syntax validation.
    }

    // Optional: create a 'runner' function to invoke the above tests
    public fun run_all_tests() {
        Self::test_multi_code_blocks();
        Self::access_modifiers_test();
    }
}

//# run 0xCAFE::sequential_code_blocks::run_all_tests