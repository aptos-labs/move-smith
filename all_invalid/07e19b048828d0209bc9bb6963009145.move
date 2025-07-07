//# publish
module 0xDEADBEEF::KeyModule {
    // Using an address and module name for keys
    resource struct Key {
        id: u64,
        label: vector<u8>,
    }

    public fun create_key(id: u64, label: vector<u8>): Key {
        Key { id, label }
    }
}

//# publish
module 0xFACEB00C::DiagnosticModule {
    // Code snippet identifiers as labels in diagnostic messages
    fun report_diag(label: vector<u8>, message: vector<u8>) {
        // Simulated diagnostic message output
        // In actual tests, this could log to stdout or be captured
        // Here, it's a placeholder to indicate where diagnostics occur
    }

    public fun test_labels() {
        report_diag(b"label1", b"Diagnostic message 1");
        report_diag(b"label2", b"Diagnostic message 2");
    }
}

//# publish
module 0xCAFEBABE::LexicalAnalysis {
    // Placeholder for code snippet that tests lexical analysis
    public fun test_lexical() {
        // Simulate tokenization logic
        let tokens = vector[
            b"fn",
            b"main",
            b"(",
            b")",
            b"{",
            b"let",
            b"x",
            b":",
            b"u64",
            b"=",
            b"42",
            b";",
            b"}",
        ];
        // This can be extended to verify token correctness
        // For now, just indicate the test runs
    }
}

//# publish
module 0xBAADF00D::PrecedenceTest {
    // Testing operator precedence in expression parsing
    public fun test_precedence() {
        // Example complex expression
        let expr1 = 1 + 2 * 3; // should parse as 1 + (2 * 3)
        let expr2 = (1 + 2) * 3; // parentheses override precedence
        // In actual tests, we'd verify parse trees or evaluation order
    }

    // Ensuring module member and alias name uniqueness
    // In Move, this can be simulated with multiple functions or constants
    public fun test_unique_names() {
        const A: u64 = 10;
        const B: u64 = 20;
        // Further, attempt conflicting aliases or redefinitions to see if compiler catches them
        // But here, we simply define distinct members
    }
}

// Now, include scripts to invoke or test these modules
//# run 0xDEADBEEF::KeyModule::create_key --signers 0xA, 0xB --args 1u64 &vector[b"label"]
//# run 0xFACEB00C::DiagnosticModule::test_labels
//# run 0xCAFEBABE::LexicalAnalysis::test_lexical
//# run 0xBAADF00D::PrecedenceTest::test_precedence
//# run 0xBAADF00D::PrecedenceTest::test_unique_names