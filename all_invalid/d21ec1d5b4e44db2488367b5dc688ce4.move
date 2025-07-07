//# publish
module 0xCAFE::SyntaxErrorTest {

    // Testing detailed error messages for unexpected tokens and expected tokens
    public fun test_syntax_error_message() {
        // This function intentionally contains syntax errors to test compiler error messages.
        // The errors are in comments for this test.
    }

    // Declaring a function that is intended to have a syntax error
    public fun invalid_function() {
        let x = 10; // Added semicolon to fix syntax error
        return;
    }

    // Struct with various members
    struct TestStruct {
        value: u64,
        name: vector<u8>,
    }

    // Const declaration
    const TEST_CONST: u8 = 255;

    // Use statement (assuming another module)
    use 0xCAFE::SomeOtherModule;

    // Friend declaration (Note: Move doesn't have friends, so we consider a placeholder comment)
    // // friend 0xBEEF::SomeFriendModule;

    // Specification (spec) placeholder (Move uses specifications within comments or external files)
    // // #[spec]
    // // spec fun some_spec();

    // More functions
    public fun dummy_function() {
        // Function with various member declarations
    }

    // Function to test the module's syntax and members
    public fun run_tests() {
        // Call functions or instantiate struct if needed
        let _ = TestStruct {
            value: 42,
            name: b"Test".to_vec(),
        };
        // Using the constant
        let _ = TEST_CONST;

        // Calling the dummy function
        dummy_function();
    }
}
//# run 0xCAFE::SyntaxErrorTest::run_tests

//# publish
module 0xCAFE::TestExercisingCompilerVM {

    // Testing comprehensive features including complex module features and source code retrieval

    // Declare a function to generate string representation of source code
    public fun get_module_source_code(): vector<u8> {
        // Since Move doesn't support string manipulation directly, return a byte string with source code
        b"
module 0xCAFE::TestExercisingCompilerVM {

    // No functions here, focusing on syntax coverage

    // Struct example
    struct SampleStruct {
        id: u128,
        name: vector<u8>,
    }

    // Constant
    const MAX_LIMIT: u64 = 1000;

    // Use statement
    use 0xCAFE::AnotherModule;

    // API functions
    public fun create_sample(id: u128, name: vector<u8>): SampleStruct {
        SampleStruct { id, name }
    }

    // Function to get a sample
    public fun get_sample(): SampleStruct {
        create_sample(1u128, b\"Sample\".to_vec())
    }

    // Main script
    script {
        fun main() {
            let sample = get_sample();
        }
    }
}
"
    }
    // This function returns the source code as bytes for the module.
}
//# run 0xCAFE::TestExercisingCompilerVM::get_module_source_code