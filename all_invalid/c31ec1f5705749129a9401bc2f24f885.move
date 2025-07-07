
//# publish
module 0xCAFE::DiagnosticsTest {
    use std::vector; // warning: unused alias, but keeping for test purposes

    // Testing compiler diagnostics: define intentional issues
    // in comments to simulate diagnostics logging
    // (Note: Actual diagnostics are captured by the test runner diagnostics, not in code)

    // A struct with invalid naming convention (should be flagged)
    // Corrected to proper naming: Starting with uppercase and snake_case
    struct InvalidStructName { // expected diagnostic: struct name should be snake_case
        field_one: u8,
    }

    // A function with invalid naming convention (should be flagged)
    // Corrected to snake_case
    public fun invalid_function_name(): u8 { // expected diagnostic: function name should be snake_case
        42
    }

    // A constant with invalid naming (should be flagged)
    // Corrected to snake_case
    const bad_const: u8 = 10; // expected diagnostic: constant name should be snake_case or uppercase

    // An annotated function that skips internal lint check
    // (simulate skipping a lint check, e.g., dead_code)
    // Use correct syntax for attribute (assuming the formatter and syntax)
    // allow(dead_code)]
    public fun skip_lint_function(): u8 {
        0
    }

    // Function with allowed naming convention
    public fun valid_function() {
        // no issues
    }

    // Function with attribute to skip specific external lint (simulate)
    // allow(non_snake_case)]
    public fun some_non_snake_case_function() {
        // no issues
    }

    // Define a struct with generic
    struct GenericStruct<T> has copy, drop {
        t_field: T,
    }

    // Function that uses generic struct, meant to trigger diagnostic if naming is wrong
    public fun test_generic_struct<T>(value: T): GenericStruct<T> {
        GenericStruct { t_field: value }
    }
}


//# run 0xCAFE::DiagnosticsTest::valid_function


//# run 0xCAFE::DiagnosticsTest::skip_lint_function


//# run 0xCAFE::DiagnosticsTest::test_generic_struct --args 20u8
