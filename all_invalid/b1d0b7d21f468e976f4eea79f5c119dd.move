//# publish
module MyTestModule {
    use std::signer;

    // Define an internal function to handle variable assignments & loop testing
    internal fun loop_variable_test() {
        let i = 0;

        // Local variable outside the loop
        let outer_var = 100;

        while (i < 5) {
            // Shadowing inner variable
            let inner_var = outer_var; // Shadowing previous outer_var in scope
            inner_var = inner_var + i;

            // Assuming some assertions or state updates here, e.g., event emission
            // For test purposes, just print or log (if environment allows)
            // Note: Move currently doesn't have print statements in tests, so we might
            // just perform state mutations or assertions

            i = i + 1;

            // At the end of each iteration, verify variable values if needed
            // For simplicity, assuming we perform no side-effects
        }

        // After the loop, check final variable values for correctness
        // For example:
        assert!(outer_var == 100, 42); // placeholder assertion
    }

    // Entry point for the transaction test
    public fun run_tests() {
        // Call internal function to perform variable shadowing test
        loop_variable_test();
    }
}
