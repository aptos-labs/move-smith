
//# publish
module 0xDEAD::TestModuleCopyAttribute {
    use std::vector;

    // Attribute with an incorrect attribute name 'copyable' (should be 'copy' or 'drop' etc.)
    // Testing that the compiler correctly identifies attribute formatting.
    // Note: This attribute usage is intentionally malformed to test diagnostics.
    struct InvalidAttrStruct has copyable, store, key {
        a: u8,
    }

    // Correct attribute usage (for control) with 'copy'
    struct CorrectAttrStruct has copy, store, key {
        b: u8,
    }

    // Inline function to test inline annotation
    public inline fun inlined_fun(x: u8): u8 {
        x + 1
    }

    // Function to test the environment variable for diagnostics (simulate environment detection)
    public fun check_env_and_display(diagnostic_flag: bool) {
        // If diagnostic_flag is false, simulate color-only diagnostics
        if (!diagnostic_flag) {
            // Assume diagnostics are rendered in color-only mode
            // The actual display isn't tested here but this flag would control the output in real environment
            // No code needed, just a placeholder
        }
        true
    }

    // Function marked for inline, to test inlining suggestion
    public inline fun suggest_inlining(x: u8): u8 {
        x + 2
    }

    // Function to instantiate and instantiate correct struct
    public fun run_tests() {
        let _ = InvalidAttrStruct {a: 10}; // intentionally trigger attribute format
        let _ = CorrectAttrStruct {b: 20};

        // Call the inlined function
        let val1 = inlined_fun(5);
        // Call the inlining suggestion function
        let val2 = suggest_inlining(7);

        // Check environment variable (simulate diagnosis display)
        let _ = check_env_and_display(false);
        (val1, val2)
    }
}


//# run 0xDEAD::TestModuleCopyAttribute::run_tests


// Featurres:
// eb61d58394c0d3888fa37794844b7def: Ensure 'copyable' attribute is properly formatted as ': copyable'.
// 064d9fdd5f44111051f10668210602d5: Display diagnostics with color-only if environment variable is set to 'NONE'.
// 0c909f7846db87c27a23716fc9e4e66b: Use inline annotation to suggest inlining Move functions.
