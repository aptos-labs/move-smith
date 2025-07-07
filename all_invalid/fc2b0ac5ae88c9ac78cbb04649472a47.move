//# publish
module 0xCAFE::MatchAndLoopTest {
    use std::signer;
    use std::debug;

    public fun match_test(x: u8): u8 {
        // Separate match arms with commas and an optional trailing comma
        match x {
            1 => 10,
            2 => 20,
            3 => {
                // Block body with trailing comma
                let y = 30;
                y
            },
            _ => 0,
        }
    }

    public fun while_loop_test(): u64 {
        let mut counter: u64 = 0;
        while (counter < 5) {
            counter = counter + 1;
        };
        // counter should be 5 here
        counter
    }

    public fun nested_while_test(): u64 {
        let mut outer: u64 = 0;
        while (outer < 3) {
            let mut inner: u64 = 0;
            while (inner < 2) {
                inner = inner + 1;
            };
            outer = outer + 1;
        };
        // outer should be 3 here
        outer
    }

    // A runner function to call all above functions to ensure they run
    public fun run_all(): (u8, u64, u64) {
        let m = match_test(3);
        let w = while_loop_test();
        let n = nested_while_test();
        (m, w, n)
    }
}

//# run 0xCAFE::MatchAndLoopTest::run_all

// Featurres:
// aea21dbc22d45e6f7964daaa7cfad30e: Separate match arms with commas, and optionally include commas between arms if the body is not a block.
// 5f91446db6e4b5867a7ed46720a31d65: Test that a while loop correctly increments a variable until the specified condition is met and that the final assertion verifies the loop's expected outcome.
// b0977166124a342053b03544cc9b5b39: Use 'while' loops with condition expressions and nested control sequences.
