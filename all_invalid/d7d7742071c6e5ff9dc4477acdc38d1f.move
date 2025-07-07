
//# publish
module 0xCAFE::LoopTest {
    use std::vector;

    // This function tests for-loops with break and continue
    public fun test_loop_control() {
        let sum: u64 = 0;
        let i: u64 = 0;
        while (i < 10) {
            if (i == 5) {
                break;
            }
            if (i % 2 == 0) {
                i = i + 1;
                continue;
            }
            sum = sum + i;
            i = i + 1;
        };
        // Return sum (should be sum of odd numbers 1,3,7,9)
        sum
    }
}

//// Generate file format bytecode from modules and scripts in the test above. (Implicit in the test framework)


//# run 0xCAFE::LoopTest::test_loop_control


//# expected_failure(out_of_gas)

// Featurres:
// 4449dcffb07284a60f55e227a05c8659: Test the interaction of for-loops with break and continue statements within a Move script.
// cc169c5676d9b558792a9ebb20d1f829: Generate file format bytecode from Move modules and scripts.
// 447a0a2e92baf94205eeedbcef8abb18: Indicate an out-of-gas error expected in your test with `#[expected_failure(out_of_gas)]` attribute.
