//# publish
module 0x1::DiagnosticLabels {
    /// Function to test labels in diagnostic messages
    public fun label_test() {
        // This function intentionally contains something to be used as a label
        // for diagnostic purposes during parsing.
        // No runtime behavior needed.
    }
}

//# publish
module 0x2::KeysModule {
    /// Function to test optional address keys in modules
    public fun key_test() {
        // This function covers scenarios with module keys that include optional addresses.
    }
}

//# publish
module 0x3::LexicalTokenization {
    /// Function to test lexical analysis and tokenization handling
    public fun tokenize_test() {
        // This function is intentionally designed to include various move source code snippets
        // to exercise the parser's lexical analysis and tokenization.
        // For example, testing identifiers, keywords, literals, comments, and operators.
        let _x = 123; // literal int
        let _s = "string literal";
        let _b = true;
        // Using comments with special characters
        // comment with tokens: +, -, *, /, 🙂
        let _y = 45 + 5 - 2 * 3 / 1; // math expression
        // Symbols and identifiers
        let _operator = ==;
    }
}

//# run
0x1::DiagnosticLabels::label_test

//# run 0x2::KeysModule::key_test --signers 0xABC --args

//# run 0x3::LexicalTokenization::tokenize_test --signers 0xDEF