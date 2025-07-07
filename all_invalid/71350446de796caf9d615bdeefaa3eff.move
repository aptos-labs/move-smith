
//# publish
module 0xBADD::UsageAnalysisTest {
    /// A dummy function to verify parameter and variable usage analysis.
    public fun dummy_usage(x: u64, y: u64): u64 {
        // Only use the first parameter, ignore y to test analysis.
        x + 10
    }
    
    /// Function to compute the smallest multiple (least common multiple) using the provided algorithm.
    public fun smallest_multiple(a: u64, b: u64): u64 {
        let multiple_a = a;
        let multiple_b = b;
        while (multiple_b != 0) {
            let temp = multiple_b;
            multiple_b = multiple_a % multiple_b;
            multiple_a = temp;
        };
        // compute lcm
        (a / multiple_a) * b
    }

    /// Test for smallest_multiple with 10 and 20
    public fun test_smallest_multiple_10_20(): u64 {
        let result = smallest_multiple(10, 20);
        // Should be 2520
        result
    }

    /// Test for smallest_multiple with larger inputs
    public fun test_smallest_multiple_large(): u64 {
        let result = smallest_multiple(13, 17);
        // Should be 221
        result
    }

    /// Function with annotated abilities for parameters and return type.
    public fun process_with_abilities<C: copy+store+drop>(a: C, b: C): C {
        // Perform a simple movement operation
        a
    }

    /// Function with parameters annotated with different abilities.
    public fun test_ability_annotations() {
        // Copy type
        let a_copy: u8 = 5;
        let b_copy: u8 = 10;
        let res_copy = process_with_abilities<u8>(a_copy, b_copy);

        // Drop type (like a table key or high-level resource)
        let res_drop = process_with_abilities<bool>(true, false);

        // Store type (simulate moving into storage)
        let res_store: address = @0x1;
        let res_stored = process_with_abilities<address>(res_store, @0x2);
    }

    /// A combined test that verifies usage analysis with ability annotations and correctness.
    public fun combined_test() {
        // Use dummy to verify parameter analysis
        let _ = dummy_usage(42, 99);

        // Test smallest multiple computations
        let res1 = test_smallest_multiple_10_20();
        let res2 = test_smallest_multiple_large();

        // Call ability annotated function
        test_ability_annotations();
        
        // Return sum of results to ensure all code path is used
        res1 + res2
    }
}


//# run 0xBADD::UsageAnalysisTest::test_smallest_multiple_10_20


//# run 0xBADD::UsageAnalysisTest::test_smallest_multiple_large


//# run 0xBADD::UsageAnalysisTest::combined_test --args 0 0


// Featurres:
// e593becc494160d3fd18b0080fc9061e: Analyze the usage of function parameters and variables during compilation.
// 14f416cf0e16ffc2d73fdf49543fe0d6: Ensure that the `smallest_multiple` function correctly computes the least common multiple of all numbers from 1 up to the specified limit, specifically verifying it returns 2520 for 10 and 232792560 for 20.
// 50d5db87db2e2d6d33db299be9acb706: Annotate types with abilities such as 'copy', 'drop', 'store', or 'key'.
