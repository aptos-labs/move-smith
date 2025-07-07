
//# publish
module 0xCAFE::TransactionalTest {
    use std::vector;

    // Helper function to simulate spec embedding
    fun spec_block<T>(block: T): T {
        // Placeholder for inline spec, just return the input for test.
        block
    }

    // Function that returns a value to test local variable management and reuse
    public fun test_return_and_reuse(x: u64): u64 {
        let a = x + 10;
        let b = a * 2;
        b
    }

    // Function to test sequential assignment and usage in arithmetic
    public fun test_sequential_assignment(y: u32): u32 {
        let val = y;
        let val = val + 5; // sequential reassignment
        let result = val * 3;
        result
    }

    // Function that embeds a 'spec' block in an expression
    public fun test_inline_spec(w: bool): u32 {
        let result = if (w) {
            spec_block(42u32)
        } else {
            spec_block(0u32)
        };
        result
    }

    // Runner function to execute all tests
    public fun run_all_tests() {
        let val1 = test_return_and_reuse(5);
        // reuse val1
        let doubled = val1 + val1;

        let val2 = test_sequential_assignment(10);
        let tripled = val2 + val2 + val2;

        let spec_result = test_inline_spec(true);

        // Store results to verify accumulation
        let _ = (doubled, tripled, spec_result);
    }
}


//# run 0xCAFE::TransactionalTest::run_all_tests

// Featurres:
// 2a06a5c3c4311fb5835a792534913bac: Test that values returned from a function are properly saved to locals and managed on the stack when they must be used multiple times in subsequent operations.
// f5d85ae3cb5ae9c572071bd106e8a755: Test that the Move function correctly performs sequential assignments and uses the updated value in an arithmetic operation.
// a86de4c293c224fb889184ab0355339e: Embed 'spec' blocks as part of an expression for in-line specification.
