
//# publish
module 0xCAFE::CharacterRestrictionTest {
    use std::vector;

    // Function with multiple return values, using generated temporaries for proper handling
    public fun multi_return_example(a: u16, b: u16): (u16, u16, u16) {
        let sum = a + b;
        let product = a * b;
        let diff = if (a > b) { a - b } else { b - a };
        (sum, product, diff)
    }

    // Function to test multiple return and loop logic
    public fun test_loop_and_multiple_returns(target: u8): u8 {
        // Initialize counter
        let counter: u8 = 0;
        // While loop until counter reaches target
        while (counter < target) {
            counter = counter + 1;
        };
        // Use multiple return function
        let (_sum, _prod, diff) = multi_return_example(counter as u16, target as u16);
        // Final output depends on diff
        diff
    }

    // Function with complex source code characters (ensuring ASCII compliance)
    public fun verify_characters(): bool {
        // Just a placeholder to signify code is ASCII-safe
        true
    }
}


//# run 0xCAFE::CharacterRestrictionTest::test_loop_and_multiple_returns --args 10u8


// Featurres:
// 52caacd5962e45c47eacd4e52b39e090: Use only permitted ASCII characters in Move source files to avoid syntax errors.
// 39a5276d71bb4576631a14e3c7dab09f: Support functions with multiple return values by generating appropriate result temporaries and labels.
// 5f91446db6e4b5867a7ed46720a31d65: Test that a while loop correctly increments a variable until the specified condition is met and that the final assertion verifies the loop's expected outcome.
