//# publish
module 0xCAFE:TestModule {
    // Function to test multiple code blocks as expressions with independent scope
    public fun test_scopes_and_mutation(): (u64, bool, vector<u8>) {
        // First code block: variables initialized and mutated
        let result1 = {
            let a = 10;
            a = a + 5; // a is now 15
            a
        };

        // Second code block: boolean flag and mutation
        let result2 = {
            let flag = false;
            flag = !flag; // flag is now true
            flag
        };

        // Third code block: byte vector and mutation
        let result3 = {
            let bytes = b"hello".to_vec();
            bytes[0] = b'H'; // change first byte to 'H'
            bytes
        };
        (result1, result2, result3)
    }

    // Function with attributes with assign syntax and expected failure attributes
    #[test]
    #[expected_failure(expected_failure_reason = "Attribute with assign syntax not supported")]
    public fun test_attributes_assignment(): bool {
        // Simulate attribute assignment with value
        // Note: In Move, attributes with values are not common, but for testing, assume symbolic
        // Using dummy attribute syntax, actual Move does not support attribute values like this.
        true
    }

    // Function to test pragma properties with various boolean, numeric, byte string, and identifier values
    public fun set_pragma_properties() {
        // Set boolean pragma
        let _pragma_bool_true = true; // pragma property: enable_feature = true
        let _pragma_bool_false = false; // pragma property: debug_mode = false

        // Set numeric pragma
        let _pragma_num = 42; // pragma property: max_retries = 42u8

        // Set byte string pragma (using byte vector)
        let _pragma_bytes = b"TestPragma".to_vec(); // pragma property: signature = b"TestPragma"

        // Set identifier-like pragma (symbolic, since Move does not have strings)
        let _pragma_identifier = x"PRAGMA"; // pragma property: section = x"PRAGMA"
    }
}

// //# run 0xCAFE::TestModule::test_scopes_and_mutation

// Featurres:
// a6cc8bbcbbc7957f0e1f7ed586101b25: Test that multiple code blocks used as expressions in a single return statement each have their own independent scope and variable mutations.
// 5d8ca82e690a4416078b1ec313376cde: Use attributes with assign syntax to specify attributes with assigned values that signal expected failures.
// 5280e781f924b743805c827f2d2f3c75: Assign boolean (true/false), numeric, byte string, or identifier values to pragma properties.
