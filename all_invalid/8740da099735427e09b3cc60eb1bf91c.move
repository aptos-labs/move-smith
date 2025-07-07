//# publish
module 0x1::DiagnosticTest {
    /// Function to be called for testing diagnostics with code snippets in messages
    public fun report_with_label(label: vector<u8>) {
        // Imagine this macro prints diagnostics with embedded source snippets
        // For the purpose of testing, it just aborts with label details
        // (In actual implementation, diagnostics would include code snippets)
        abort 1;
    }

    /// Function to demonstrate parsing and tokenization handling
    public fun parse_and_tokenize() {
        // Sample code snippets to simulate tokenization and parsing diagnostics
        let _ = { let x = 42; }; // Placeholder for parsing code
        // Intentionally parsing incomplete code to trigger diagnostic labels
        // e.g., missing semicolon or invalid token
        abort 1;
    }

    /// Runner function to execute all tests
    public fun run_tests() {
        report_with_label(b"Feature 1: Module keys included");
        report_with_label(b"Feature 2: Diagnostic message with code snippet");
        report_with_label(b"Feature 3: Lexical analysis and tokenization");
        parse_and_tokenize();
    }
}

//# run 0x1::DiagnosticTest::run_tests