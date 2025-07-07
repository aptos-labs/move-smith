
//# publish
module 0xCAFE::DiagnosticsTest {
    use std::vector;

    // Testing compiler diagnostics: define intentional issues
    // in comments to simulate diagnostics logging
    // (Note: Actual diagnostics are captured by the test runner diagnostics, not in code)

    // A struct with invalid naming convention (should be flagged)
    struct invalid_struct_name { // expected diagnostic: struct name should be snake_case
        field_one: u8,
    }

    // A function with invalid naming convention (should be flagged)
    public fun InvalidFunctionName(): u8 { // expected diagnostic: function name should be snake_case
        42
    }

    // A constant with invalid naming (should be flagged)
    const BAD_CONST: u8 = 10; // expected diagnostic: constant name should be snake_case or uppercase

    // An annotated function that skips internal lint check
    // (simulate skipping a lint check, e.g., dead_code)
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
    public fun SomeNonSnakeCaseFunction() {
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


// Featurres:
// b81ec7d4fec8c34fc7478d659cac559c: View detailed compiler diagnostics associated with your Move source files
// d0dda1e9fa5ca36f6c00a021b042a5ce: Annotate modules with attributes to selectively skip specified external lint checks on certain functions.
// edf5d2f4ab13be32218327e2a68ddf57: Name module members (such as functions, structs, or constants) according to allowed naming conventions
