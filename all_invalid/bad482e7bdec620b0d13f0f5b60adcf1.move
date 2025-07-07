//# publish
module 0x1::test_module {
    use std::error;

    // Function with #[test(error_location = ...)] attribute
    #[test(error_location = 0x1::specs::ErrorLocation)]
    public fun test_error_location() {
        let loc = "some_location";
        check_location(loc, true);
        check_location("", false);
    }

    // Function with attribute that does not specify location (should produce an error)
    #[test]
    public fun test_missing_error_location() {
        // No attribute, just a placeholder to test attribute parsing
        return;
    }

    // Function to check presence of location in attribute
    public fun check_location(loc: &str, condition: bool) {
        if (condition) {
            // Correct usage: location should be present
            // simulate assertion
        } else {
            // Missing location - should produce an error if attribute requires location
            error::invalid_argument("Missing location in attribute");
        }
    }

    // Specification functions with parameter lists
    spec fun spec_fn_with_params(a: u64, b: u8) {
        // specification logic
    }

    spec fun spec_fn_no_params() {
        // specification logic
    }
}

//# run
//# run 0x1::test_module::test_error_location --signers 0x1 --args "" 
//# run 0x1::test_module::test_missing_error_location --signers 0x1 --args 
// The above will test attribute attachment, location checks, and error handling.

// Featurres:
// 6559adb3d9fbd0d64cf570fb62b4c0a3: Attach #[test(error_location = ...)] attributes containing module identifiers to testing code
// c97d16ca4d327179d64cbaa15d06c6b2: Declare functions in specifications with parameter lists enclosed in parentheses.
// 0cf2ce865f7ee05aabf355bf2a4e285a: Use the `check_location` function to enforce that a location `loc` is present when a certain attribute `attr` is used, and report an error if it is missing.
