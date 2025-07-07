//# publish
module 0x1::TestModule {
    public fun caller() {
        // Empty function for testing cross-module calls within the same address
    }
}

//# publish
module 0x2::OtherModule {
    public fun caller() {
        // Empty function for testing cross-module calls within another address
    }
}

//# publish
module 0x1::TypeUnionDemo {
    use 0x1::TestModule;
    use 0x2::OtherModule;

    // Function to test calling functions from same address domain
    public fun call_same_address() {
        TestModule::caller();
    }

    // Function to test calling functions from different address domain -- should cause error
    public fun call_different_address() {
        // Intentional error: calling cross-domain module function
        // Should fail validation or produce an error
        // Commented out to prevent compilation error here
        // 0x2::OtherModule::caller();
        // Instead, simulate an invalid call with explicit type check
        // In practice, this should be commented or left to cause compile-time error
    }

    // Function to test function signatures with union types
    public fun test_union_types(
        val1: | u8, u16 || u32,
        val2: | bool, vector<u8> || string
    ) {
        // Dummy implementation
    }

    // Function to intentionally cause type specification errors
    public fun report_spec_error() {
        // Example of invalid type union syntax
        // Should cause compile-time or validation error
        // e.g., use '|' after primitive types in a wrong way
        // move to test error reporting
        let _err_type: | u8; // Missing second type
        let _invalid_union: | u8 ||; // Invalid syntax, missing second type
        // Or overly complex invalid union
        let _complex_invalid: | u8 || u16 ||; // Trailing '||' without second type
    }

    // Runner function to execute tests
    public fun run_all_tests() {
        call_same_address();
        // call_different_address(); // Uncomment to test cross-domain call error
        test_union_types(123u8, true);
        report_spec_error();
    }
}

//# run 0x1::TypeUnionDemo::run_all_tests --signers 0x1