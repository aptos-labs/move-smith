
//# publish
module 0xCAFE::MetaAttributesTest {
    use std::vector;

    // Example of annotating functions (simulate deprecated or custom attribute)
    // Since Move doesn't support attributes natively, we'll simulate via comments or naming.
    // For the purpose of this test, assume the compiler recognizes a custom attribute syntax as comments.
    // But in real Move, annotations are limited; this is purely for testing parser/compiler handling.

    // Simulate a deprecated attribute
    // // deprecated]
    public fun deprecated_func(): u64 {
        42
    }

    // Simulate another metadata attribute
    // // metadata("conditional_behavior")]
    public fun conditional_behavior_func(): u8 {
        7
    }

    // Function that displays diagnostics conditionally based on environment variable
    public fun diagnose_environment() {
        // In actual implementation, diagnostics may depend on env vars,
        // but here we simulate with a constant (assuming env check is handled elsewhere).
        // Use a dummy inline condition to emulate.
        let env_setting = if (false) { "NONE" } else { "OTHER" };
        if (env_setting == "NONE") {
            // Simulate color-only diagnostics output; in real tests, this affects output color formatting.
            // Here, we just ensure code for the branch exists.
            let _ = "Diagnostics in color-only mode";
        } else {
            let _ = "Diagnostics with full formatting";
        };
    }

    // Function that uses '&' to create references
    public fun reference_test(x: u8, y: u8): u8 {
        let ref_x: &u8 = &x;
        let ref_y: &u8 = &y;

        // Use references in expressions
        *ref_x + *ref_y
    }

    // Function that combines all above tests
    public fun run_all_tests() {
        let _ = deprecated_func();
        let _ = conditional_behavior_func();
        diagnose_environment();
        // test reference behavior
        let sum = reference_test(10u8, 20u8);
        sum
    }
}


//# run 0xCAFE::MetaAttributesTest::run_all_tests

// Featurres:
// a5c4bcfe72a96ce9ac6d7199f8fab616: Annotate functions with deprecated or other metadata attributes for conditional behavior.
// 064d9fdd5f44111051f10668210602d5: Display diagnostics with color-only if environment variable is set to 'NONE'.
// 0578162ed3b65022b1e11cb45203f19f: Use '&' to define references to values in types.
