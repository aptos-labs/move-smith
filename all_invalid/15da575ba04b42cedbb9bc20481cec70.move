//# publish
module 0xCAFE::InlineSpecTest {
    use std::spec;

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
            assert!(inc(x) == x + 1, 100);
        };

        // Use the inline spec function via the public Move function
        let y = x + 1; // inc(x) inline increments by 1

        // Return sum of initial x + two increments (testing spec sum_inc)
        // In Move, spec functions cannot be called, so we simulate the behavior
        y + inc(x)
    }

    // Spec function using byte string literal for some raw data
    spec fun raw_bytes(): vector<u8> {
        b"Hello, spec bytes\n"
    }
}

//# run 0xCAFE::InlineSpecTest::test --args 10u64

// Featurres:
// 40854de5189921590f64e406ad9e8af4: Provide both inlined and non-inlined versions of specification functions, enabling customized specification behavior for inlining.
// 18a0a3ccca635e19e8dceadd6be8dd5c: Test that the inline function `inc` correctly increments a u64 value and that the `test` function accurately sums the initial value with two increments of that value.
// 68446115fc1cac3f386e6fac7d015d92: Use byte string literals starting with 'b"' for raw byte data.
