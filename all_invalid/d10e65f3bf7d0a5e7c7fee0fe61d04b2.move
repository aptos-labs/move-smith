//# publish
module 0xABC::KeyModule {
    // Module to test optional address in module keys
    public fun get_identifier() : vector<u8> {
        let identifier = b"KeyModuleIdentifier";
        identifier
    }
}

//# publish
module 0xDEF::DiagnosticModule {
    // Module to test diagnostic messages and labels
    public fun report_diagnostic() {
        // Placeholder for diagnostic message with label
        let label = "DIAG_LABEL_1";
        // Emulate a diagnostic message (actual message logging is done off-chain)
        // Diagnostics here are simulated via comments to indicate intention
        // e.g., emit diagnostics with label: "Diagnostic: Error at label DIAG_LABEL_1"
        // For testing, this function can be called to ensure diagnostic mechanism
        return;
    }
}

//# publish
module 0x123::ParsingModule {
    // Module to test lexical analysis and tokenization
    public fun tokenize_source(source_code: vector<u8>) {
        // Dummy function to trigger parsing and tokenization
        // Real parser tokens are tested during compilation; here we simulate usage
        // For the test, assume source_code is passed as bytes
        return;
    }
}

//# publish
module 0x456::ExpressionModule {
    // Module to test parentheses in match expressions
    public fun match_with_parentheses(val: u64): u64 {
        match (val + 1) {
            0 => 10,
            1 => 20,
            _ => 30,
        }
    }
}

// Run the publish commands to compile and publish modules
//# publish
module 0xABC::KeyModule {}

//# publish
module 0xDEF::DiagnosticModule {}

//# publish
module 0x123::ParsingModule {}

//# publish
module 0x456::ExpressionModule {}

// Test script to invoke functions and test features
//# run
script {
    // Invoke get_identifier to test module keys with optional address
    let key_id = 0xABC::KeyModule::get_identifier();
    // (no assertions; just to compile and run)
}

// Test diagnostic message label
//# run 0xDEF::DiagnosticModule::report_diagnostic

// Test lexical analysis and tokenization by passing source code bytes
//# run 0x123::ParsingModule::tokenize_source --args "fn main() { return; }" as bytes

// Test parentheses in match expression
//# run 0x456::ExpressionModule::match_with_parentheses --args 0u64