//# publish
module 0x1::DeprecationAPI {
    /// Deprecated function to simulate API deprecation warning.
    public fun old_api() {
        // implementation (can be empty)
    }
}

//# publish
module 0x2::Diagnostics {
    /// Emits a warning about a deprecated API usage.
    public fun warn_deprecated() {
        // simulate issuing a warning
        move_to_string() // dummy call to avoid syntax issues
    }

    /// Fires a diagnostic message (e.g., duplicated).
    public fun emit_diagnostic() {
        // simulate a diagnostic message
        move_to_string()
    }
}

//# publish
module 0x3::MainModule {
    use 0x1::DeprecationAPI;
    use 0x2::Diagnostics;

    // Configure environment: set env variable for deprecated API warnings
    // (simulated here; in actual test, environment variables are set outside the code)

    // Function to test referencing nested modules via access chains
    public fun test_module_access() {
        // Reference DeprecationAPI.old_api via module access chain
        DeprecationAPI::old_api();
    }

    // Function to test removal of duplicate diagnostics
    public fun test_remove_duplicate_diagnostics() {
        Diagnostics::emit_diagnostic();
        Diagnostics::emit_diagnostic(); // duplicate diagnostic
    }

    // Function to test issuing warning for deprecated API when environment is set
    public fun test_deprecated_warning() {
        // Simulate environment variable check
        // In actual tests, environment variable triggers warning in compiler
        // Here, we call the API to simulate the scenario
        DeprecationAPI::old_api();
        Diagnostics::warn_deprecated();
    }

    // Runner function to execute all tests
    public fun run_tests() {
        test_module_access();
        test_remove_duplicate_diagnostics();
        test_deprecated_warning();
    }
} //# run 0x3::MainModule::run_tests