//# publish
module 0xE0::NestedApplyTest {

    /// Creates an `apply` function similar to the example, but with different operators to test nested calls.
    public inline fun apply(f: |u64, u64|u64, x: u64, y: u64): u64 {
        f(x, y)
    }

    /// Applies multiple nested functions with various operations to test nested function calls.
    public fun test_nested(): u64 {
        // First, apply a subtraction on x and y, then add the result to the product of new numbers
        apply(
            |x, y| {
                // Inside, combine different operations
                let sub = x - y;
                sub + apply(|a, b| a * b, 3, 4)
            },
            10,
            apply(|a, b| a + b, 5, 7)
        )
    }

    /// Runner function to invoke test_nested
    public fun run_test(): u64 {
        test_nested()
    }
}

//# run 0xE0::NestedApplyTest::run_test