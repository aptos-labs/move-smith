
//# publish
module 0xBADD::TestModule {
    // This module is to help create a contextual environment if needed
    // for testing named spec blocks and friend access.

    public fun dummy() {
        // Empty dummy function
    }
}


//# run 0xBADD::TestModule::dummy


//# publish
module 0xC0FF::FeatureTest {
    use std::vector;

    // Apply spec block to specific functions by naming.
    // Also, test variable updates on break statements in loops.
    // Simulate "friend" access by exposing functions that can be called externally.

    // Define a public function with a spec block tagged to it.
    // For Move, assume we add custom attributes or comments as annotation
    // (this is conceptual since Move doesn't have annotations like that, but for test purposes).

    //* spec “test_conditions” (simulating condition application)
    public fun process_numbers(limit: u64): u64 {
        let sum: u64 = 0;
        let i: u64 = 0;
        while (i < limit) {
            if (i == 5) {
                break;
            };
            sum = sum + i;
            i = i + 1;
        };
        // After break, variable i should be 5
        // And sum should be sum of 0..4
        sum
    }

    //* spec “test_conditions”
    public fun update_and_check_flags() {
        let flag_a: bool = false;
        let flag_b: bool = false;

        // Update flags inside a loop with break
        let count: u8 = 0;
        loop {
            if (count >= 3) {
                flag_b = true;
                break;
            };
            flag_a = true; // Should be set for each iteration before break
            count = count + 1;
        };
        (flag_a, flag_b)
    }

    // Helper function to retrieve the final value of the variable after loop with break
    public fun run_process_numbers(): u64 {
        process_numbers(10)
    }

    public fun run_update_and_check_flags(): (bool, bool) {
        update_and_check_flags()
    }
}


//# run 0xC0FF::FeatureTest::run_process_numbers --args 10u64


//# run 0xC0FF::FeatureTest::run_update_and_check_flags


// Featurres:
// ad61769847cc49bf32acec870432b4d9: Apply spec blocks or conditions to specific named entities such as functions or modules in your code.
// 431feb4d6c714a223a719930f11d883b: Specify the friend entity or module using a name access chain.
// f3fe8548f5064f4cacde58056ce40e0c: Test that variables updated inside a loop are correctly assigned when a break statement is used.
