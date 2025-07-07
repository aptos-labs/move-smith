//# publish
module 0xCAFE::TestTupleAndLogging {
    use std::debug;

    public fun return_sum_of_1_and_2(): u16 {
        let (a, b) = (1u16, 2u16);
        a + b
    }

    public fun log_multiple_invocations() {
        let i = 0u8;
        while (i < 3) {
            let sum = return_sum_of_1_and_2();
            debug::print(&("Invocation number: ")); // just to exercise logging
            debug::print(&i);
            debug::print(&(" Sum result: "));
            debug::print(&sum);
            i = i + 1;
        };
    }
}

//# run 0xCAFE::TestTupleAndLogging::return_sum_of_1_and_2

//# run 0xCAFE::TestTupleAndLogging::log_multiple_invocations

// Featurres:
// 6feddd8ab5c82b9a079f5e4c3ff513f6: Test that the function returns the sum of 1 and 2, verifying correct tuple creation and variable assignment.
// cf3f13457b85ef04d639f4adad79277b: Terminate compilation if serious diagnostics are encountered and reported
// 737856b5e405835319fb4a3052281bdf: Invoke the function multiple times to ensure logging is configured without errors.
