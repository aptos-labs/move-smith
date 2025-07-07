
//# publish
module 0xCAFE::TestAnnotations {
    public fun dummy() {}

    // Function to test reachability annotations
    public fun test_reachability(): bool {
        // The following line is marked as reachable with annotation
        // @reachable
        let x = 1;
        // The following line is marked as unreachable
        // @unreachable
        let y = 2; // This should be unreachable if annotation works correctly
        x == 1
    }

    // Struct and enum for testing extraction function
    struct E {
        variant1: u8,
        variant2: u8,
        variant3: u8,
    }

    // Function to extract last u8 from enum variants
    public fun extract_last_u8(e: E): u8 {
        match e {
            E { variant1: v, .. } => v,
            E { variant2: v, .. } => v,
            E { variant3: v, .. } => v,
        }
    }

    // Function to test the while loop with false condition
    public fun test_while_zero_iteration(): (u64, u64) {
        let counter = 0;
        let value = 100;
        while false {
            value = value + 1;
            counter = counter + 1;
        };
        (counter, value)
    }

    // Function to run all tests
    public fun run_all_tests(): (bool, u8, (u64, u64)) {
        let reach = Self::test_reachability();
        let e1 = E { variant1: 10, variant2: 20, variant3: 30 };
        let extracted1 = Self::extract_last_u8(e1);
        let e2 = E { variant1: 40, variant2: 50, variant3: 60 };
        let extracted2 = Self::extract_last_u8(e2);
        let result = Self::test_while_zero_iteration();
        (reach, extracted1, result)
    }
}


//# run
0xCAFE::TestAnnotations::run_all_tests

// Featurres:
// 04fcf5f4f848bf65c559426416360ed1: Use annotations to determine the reachability status of code at a specific offset.
// 51cf5acfd94ca60fc9bc9ae924d26101: Test that a while loop with a false condition does not execute and the variable retains its initial value.
// ec2a061fa34f1b9ea6a20a399496d748: Test that the extract_last_u8 function correctly matches and extracts the appropriate u8 value from each variant of the E enum.
