//# publish
module 0x1::DeprecatedAndLoopTest {
    /// Mark the entire module as deprecated.
    // deprecated]
    public(struct DeprecatedStruct {}) {}

    /// Constants for testing
    const MY_INT: u64 = 42;

    /// Internal function demonstrating a while loop
    fun repeat_until_five(mut count: u64) {
        // Continue looping until count reaches 5
        while (count < 5) {
            // For simplicity, just increment count each iteration
            count = count + 1;
            // You might include some logic here
        }
        // After loop, count should be 5
        assert!(count == 5, 0);
    }

    /// Public entrypoint for testing
    public fun test_function() {
        // Call the loop function
        Self::repeat_until_five(0);

        // Demonstrate using a reference to a constant
        let ref_const = &MY_INT;
        let local_copy = *ref_const; // Mutability via local copy
        local_copy = local_copy + 1;

        // Ensure original constant is unchanged
        assert!(MY_INT == 42, 1);
        // Ensure mutation does not affect constant
        assert!(local_copy == 43, 2);
    }

    // test]
    public fun run_tests() {
        Self::test_function();
    }
}
