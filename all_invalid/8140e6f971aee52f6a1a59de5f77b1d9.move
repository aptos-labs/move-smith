//# publish
module 0xCAFE::CheckerNames {
    // This module simulates external checkers with getter functions.

    // A vector of checker names implemented as a constant vector<u8> vector of bytes for names
    const CHECKER_NAMES_0: vector<u8> = b"CheckerA";
    const CHECKER_NAMES_1: vector<u8> = b"CheckerB";
    const CHECKER_NAMES_2: vector<u8> = b"CheckerC";

    // Returns a vector of all checker names as vector<vector<u8>>
    public fun get_all_checker_names(): vector<vector<u8>> {
        let names = vector::empty<vector<u8>>();
        vector::push_back(&mut (copy names), copy (CHECKER_NAMES_0));
        let names = vector::empty<vector<u8>>();
        vector::push_back(&mut names, CHECKER_NAMES_0);
        vector::push_back(&mut names, CHECKER_NAMES_1);
        vector::push_back(&mut names, CHECKER_NAMES_2);
        names
    }
}

//# publish
module 0xCAFE::VerificationAttributes {
    // This module tests custom verification attributes usage

    #[verify(noskip)]
    public fun must_verify() {
        // Do nothing, just a stub for a function forced to verify
    }

    #[verify(ignore)]
    public fun ignored_verification() {
        // This function should be skipped during verification
    }

    #[verify(precondition = "x > 0", postcondition = "result > x")]
    public fun pre_post_conditions_example(x: u8): u8 {
        // A simple function to test pre and post verification attributes
        x + 1
    }
}

//# publish
module 0xCAFE::LoopControlTest {
    // This module tests nested loops, multiple breaks, continues, and variable updates

    public fun complex_loop_test(initial: u8): u8 {
        let mut counter = 0u8;
        let mut sum = initial;

        while (counter < 5) {
            if (counter == 2) {
                counter = counter + 1;
                continue;
            };
            let mut inner = 0u8;

            loop {
                if (inner == 3) {
                    break;
                };

                if (inner == 1) {
                    inner = inner + 1;
                    continue;
                };

                sum = sum + counter + inner;
                inner = inner + 1;
            };

            if (sum > 50) {
                break;
            };

            counter = counter + 1;
        };

        sum
    }
}

//# run 0xCAFE::CheckerNames::get_all_checker_names

//# run 0xCAFE::VerificationAttributes::must_verify

//# run 0xCAFE::VerificationAttributes::ignored_verification

//# run 0xCAFE::VerificationAttributes::pre_post_conditions_example --args 10u8

//# run 0xCAFE::LoopControlTest::complex_loop_test --args 5u8

// Featurres:
// 8f07e2cb8f8ac36fec0ca05e1cbe59aa: Retrieve the set of all existing checker names from external checkers.
// 5e57bd5da0005044c3de25974ad77f2f: Use custom verification attributes to control verification and analysis for code elements.
// 802f80faa85da9b54168540bf1cea833: Test that nested loops with multiple break and continue statements, along with variable updates, correctly influence control flow and final assertions.
