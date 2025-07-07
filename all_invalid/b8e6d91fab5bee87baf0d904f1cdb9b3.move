// Corrected transaction test code for Aptos Move

//# run
script {
    // Assume necessary imports and dependencies are included here

    // Test function for verifying variable shadowing and loop variable correctness
    fun test_variable_shadowing() {
        // Initialize variables
        let total = 0;

        // Start a loop
        let i = 0;
        while (i < 5) {
            // Shadowing 'i' inside loop block
            let i = i + 1;
            total = total + i;
            // Loop variable 'i' outside the block remains unchanged
            // but within the iteration, 'i' is shadowed
            // No external effect, so safe
            i = i + 1;
        }

        // Assert the total value
        assert!(total == 15, 42, "Total should be 15");
    }

    // Additional test for struct destructuring with inline initializers
    struct Point {
        x: u64,
        y: u64,
        z: u64,
    }

    fun test_destructuring_struct() {
        // Create a Point with inline initializations
        let p = Point { x: 3, y: 4, z: 5 };

        // Destructure
        let Point { x: a, y: b, z: c } = p;

        // Compute sum
        let sum = a + b + c;

        // Assert the sum
        assert!(sum == 12, 42, "Sum of fields should be 12");
    }

    // Entry point to run tests
    fun main() {
        test_variable_shadowing();
        test_destructuring_struct();
    }
}
