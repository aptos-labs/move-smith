//# publish
module 0xCAFE::InlineSpecTest {
    /// Spec functions must be declared with the `spec` keyword directly; `use std::spec;` is invalid.
    /// Also, `assert!` with a second argument is not valid syntax in spec blocks.
    /// We'll remove the invalid `use std::spec;` and fix these issues.

    // A spec function that is explicitly inlined
    spec inline fun inc(x: u64): u64 {
        x + 1
    }

    // A spec function with the same name but non-inlined, to test custom behavior
    spec fun inc(x: u64): u64 {
        x + 2
    }

    // Spec function to test summing of increments
    spec fun sum_inc(x: u64): u64 {
        inc(x) + inc(x)
    }

    // A public Move function that uses the inline spec function in an assert
    public fun test(x: u64): u64 {
        // Assert that inc inline works as expected for the input
        spec {
            // The correct assert syntax in spec is just:
            // assert!(condition);
            assert!(inc(x) == x + 1);
        };

        // Use the inline spec function via the public Move function
        let y = x + 1; // inc(x) inline increments by 1

        // Return sum of initial x + two increments (testing spec sum_inc)
        // In Move, spec functions cannot be called at runtime, so we simulate the behavior
        y + inc(x)
    }

    // Spec function using byte string literal for some raw data
    spec fun raw_bytes(): vector<u8> {
        b"Hello, spec bytes\n"
    }
}

//# run 0xCAFE::InlineSpecTest::test --args 10u64