//# publish
module 0x1::DebugLogging {
    /// Function to log debug info with detailed bytecode dump name.
    public fun enable_debug_logging() {
        // This function would enable debug logging in a real scenario.
        // Placeholder for enabling debug logs.
    }
}

/// Top-level spec block demonstrating inclusion of spec functions.
module 0x2::TopLevelSpec {
    public fun run_all() {
        // Call nested spec functions or perform setup.
        // Placeholder for sequential spec execution.
    }
}

//# run 0x2::TopLevelSpec::run_all

//# publish
module 0x3::DebugSpec {
    use 0x1::DebugLogging;

    /// Spec block that includes debug logging with detailed info.
    public fun debug_feature() {
        DebugLogging::enable_debug_logging();
        // Additional debug-related setup could go here.
    }
}

//# run 0x3::DebugSpec::debug_feature --signers 0xDEADBEEF

//# publish
module 0x4::LiteralAddressSpec {
    /// Declare a literal address with a specific byte sequence.
    public fun get_literal_address(): address {
        // Using the literal address '(0x1234)'.
        (0x1234)
    }
}

//# run 0x4::LiteralAddressSpec::get_literal_address --signers 0xBADDCAFE

//# publish
module 0x5::VerifyOnlyCode {
    // This module is only relevant during verification, not during execution.

    #[verify_only]
    public fun verify_mode_function() {
        // Function logic intended only for verification.
        // Actual runtime code should ignore this during execution.
    }
}

/// Spec block to ensure verify_only attribute doesn't interfere.
module 0x6::VerifyTest {
    use 0x5::VerifyOnlyCode;

    public fun run_verify() {
        VerifyOnlyCode::verify_mode_function();
    }
}

//# run 0x6::VerifyTest::run_verify --signers 0xBABE