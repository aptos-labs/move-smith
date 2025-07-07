//# publish
module 0xCAFE::LoopTest {
    use std::debug;

    #[test_only]
    #[verifier(decreases_by = 1)]
    public fun nested_loops_and_control_flow(): u64 {
        let mut sum = 0;
        let mut i = 0;
        while (i < 5) {
            let mut j = 0;
            while (j < 5) {
                j = j + 1;
                if (j == 3) {
                    // Skip this iteration of the inner loop
                    continue;
                }
                if (j == 4) {
                    // Break inner loop early if j == 4
                    break;
                }
                sum = sum + i + j;
            }
            i = i + 1;
            if (i == 3) {
                // Break outer loop early
                break;
            }
            // else continue normally
        }
        // Expected calculation:
        // i=0: j = 1,2, (j=3 continue), (j=4 break)
        // sum += 0+1 + 0+2 = 0+1 + 0+2 = 3
        // i=1: j=1,2 (j=3 continue) (j=4 break)
        // sum += 1+1 + 1+2 = 2 + 3 = 5
        // i=2: j=1,2 (j=3 continue) (j=4 break)
        // sum += 2+1 + 2+2 = 3 + 4 = 7
        // total sum = 3 + 5 + 7 = 15
        sum
    }

    public fun simple_addition(a: u64, b: u64): u64 {
        a + b
    }

    #[verifier(ignore)]
    public fun ignored_function() {
        debug::print(&"This function is ignored by verifier");
    }
}
//# run 0xCAFE::LoopTest::nested_loops_and_control_flow --signers 0xCAFE
//# run 0xCAFE::LoopTest::simple_addition --args 15u64 27u64

//# publish
script {
    use 0xCAFE::LoopTest;

    #[verifier(ignore)]
    fun main() {
        let res = LoopTest::nested_loops_and_control_flow();
        debug::print(&("Result nested_loops_and_control_flow: "));
        debug::print(&res);

        let sum = LoopTest::simple_addition(42, 58);
        debug::print(&("Result simple_addition: "));
        debug::print(&sum);

        LoopTest::ignored_function();
    }
}
//# run

// Featurres:
// 802f80faa85da9b54168540bf1cea833: Test that nested loops with multiple break and continue statements, along with variable updates, correctly influence control flow and final assertions.
// 0ea978679d5fdf0f1de63ab95f43eee6: Test that the Move module can define a function that performs simple integer addition.
// 5e57bd5da0005044c3de25974ad77f2f: Use custom verification attributes to control verification and analysis for code elements.
