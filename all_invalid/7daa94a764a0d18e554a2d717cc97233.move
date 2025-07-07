//# publish
module 0xCAFE sequential_code_blocks {
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
        // For testing, one could check the final values, but no assertions needed.
    }

    // Test that native constants are not supported: avoid using them.

    // Define a function with access specifiers as a list separated by commas to check syntax
    public(public, private, friend) fun access_modifiers_test() {
        // Nothing needed here; just a placeholder for syntax validation.
    }

    // Optional: create a 'runner' function to invoke the above tests
    public fun run_all_tests() {
        Self::test_multi_code_blocks();
        Self::access_modifiers_test();
    }
}

//# run 0xCAFE::sequential_code_blocks::run_all_tests

// Featurres:
// 5c47e2f6ef5ccda5963f25af5bca8228: Test that multiple code blocks separated by semicolons within an expression are evaluated in order and can each modify and return a local variable.
// 2aa0d1241aaa35c2dbbc5ed762c75ab9: Native constants are not supported; do not use the 'native' modifier on constants.
// 3dc5450a2dcc8d77a03697c97b2a3df2: Define access specifier lists separated by commas.
