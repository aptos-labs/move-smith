//# publish
module 0x1::test_module {
    use std::assert;

    // Example fixed transactional test
    public entry fun run_test() {
        // Initialize a local counter
        let counter = 0;

        // Loop until counter reaches 5
        while (counter < 5) {
            // Shadow a variable with the same name inside the loop scope
            let counter = counter + 1;
            // Ensure inner 'counter' is correctly incremented
            assert!(counter > 0);
        }

        // After loop, 'counter' should be 0 (original variable)
        assert!(counter == 0, 42);

        // To verify the original 'counter' value, reassign it if needed
        // or declare a new variable to hold the final count
        // For demo, reassigning
        let final_counter = counter;

        // Confirm the original counter remains unchanged
        assert!(final_counter == 0);
    }
}
