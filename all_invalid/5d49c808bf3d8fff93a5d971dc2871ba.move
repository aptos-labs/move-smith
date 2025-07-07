//# publish
module 0xABC::Diagnostics {
    /// A resource to hold diagnostic labels and messages.
    struct DiagnosticLabels {
        labels: vector<vector<u8>>,
        messages: vector<vector<u8>>,
    }

    /// Initialize the diagnostics storage.
    public fun init(account: &signer) {
        move_to(account, DiagnosticLabels {
            labels: vector::empty(),
            messages: vector::empty(),
        });
    }

    /// Add a label with an associated message.
    public fun add_label(account: &signer, label: vector<u8>, message: vector<u8>) acquires DiagnosticLabels {
        let diag = borrow_global_mut<DiagnosticLabels>(signer::address_of(account));
        diag.labels = vector::push_back(&mut diag.labels, label);
        diag.messages = vector::push_back(&mut diag.messages, message);
    }

    /// Retrieve labels (for testing).
    public fun get_labels(account: &signer): vector<vector<u8>> acquires DiagnosticLabels {
        let diag = borrow_global<DiagnosticLabels>(signer::address_of(account));
        diag.labels
    }

    /// Retrieve messages (for testing).
    public fun get_messages(account: &signer): vector<vector<u8>> acquires DiagnosticLabels {
        let diag = borrow_global<DiagnosticLabels>(signer::address_of(account));
        diag.messages
    }
}

//# publish
module 0xDEF::LexicalAnalyser {
    /// An enum representing different token types.
    enum TokenType {
        Identifier,
        Keyword,
        Symbol,
        Literal,
        EOF,
    }

    /// A struct to hold token information.
    struct Token {
        token_type: TokenType,
        lexeme: vector<u8>,
        position: u64,
    }

    /// A simple lexer that tokenizes a Move source code string.
    public fun tokenize(source: vector<u8>): vector<Token> {
        let tokens: vector<Token> = vector::empty();
        let length = vector:: length(&source);
        let index = 0;

        while (index < length) {
            let ch = *vector::borrow(&source, index);
            // Simple rule: distinguish identifier, keyword, symbol, literal.
            if (ch >= 65 && ch <= 90 || ch >= 97 && ch <= 122 || ch >= 48 && ch <= 57) {
                // Accumulate identifier or literal.
                let start = index;
                while (index < length) {
                    let c = *vector::borrow(&source, index);
                    if (c >= 65 && c <= 90 || c >= 97 && c <= 122 || c >= 48 && c <= 57) {
                        index = index + 1;
                    } else {
                        break;
                    }
                }
                let lexeme = vector::subsequence(&source, start, index);
                // For simplicity, treat 'move' as keyword.
                if (vector::equals(&lexeme, b"move")) {
                    vector::push_back(&mut tokens, Token { token_type: TokenType::Keyword, lexeme, position: start });
                } else {
                    vector::push_back(&mut tokens, Token { token_type: TokenType::Identifier, lexeme, position: start });
                }
            } else if (ch == 123 || ch == 125 || ch == 58 || ch == 59 || ch == 42) {
                // Symbols: { } : ; *
                let symbol_char = ch;
                let lexeme = vector::singleton(symbol_char);
                vector::push_back(&mut tokens, Token { token_type: TokenType::Symbol, lexeme, position: index });
                index = index + 1;
            } else if (ch >= 48 && ch <= 57) {
                // Numeric literal
                let start = index;
                while (index < length) {
                    let c = *vector::borrow(&source, index);
                    if (c >= 48 && c <= 57) {
                        index = index + 1;
                    } else {
                        break;
                    }
                }
                let lexeme = vector::subsequence(&source, start, index);
                vector::push_back(&mut tokens, Token { token_type: TokenType::Literal, lexeme, position: start });
            } else {
                // Skip whitespace or unrecognized characters.
                index = index + 1;
            }
        }
        // Append EOF token
        vector::push_back(&mut tokens, Token { token_type: TokenType::EOF, lexeme: vector::empty(), position: length });
        tokens
    }
}

//# publish
module 0x1234::FeatureTest {
    use 0xABC::Diagnostics;
    use 0xDEF::LexicalAnalyser;

    // Helper to convert string literal to vector<u8>
    fun str_to_bytes(s: &vector<u8>): vector<u8> {
        s
    }

    // Runner function to perform all tests
    public fun run_tests(account: &signer) {
        // 1. Test module keys with optional address and module name
        Diagnostics::init(account);

        // Add a label with module key info
        Diagnostics::add_label(
            account,
            vector::empty(), // empty label for demonstration
            vector::append(b"Module key test: 0x1234::FeatureTest", b"")
        );

        // 2. Diagnostic message with identifiers in labels
        Diagnostics::add_label(
            account,
            str_to_bytes(b"label1"),
            str_to_bytes(b"Diagnostic message with label1 identifier")
        );

        // 3. Lexical analysis and tokenization
        let source_code = vector::concat(
            b"use 0xABC::Diagnostics;\n",
            b"fun test() {\n",
            b"    // sample comment\n",
            b" move {assert(true);} // move block\n",
            b"}"
        );

        let tokens = LexicalAnalyser::tokenize(source_code);

        // For demonstration, add a label that contains token types (simulate diagnostic)
        let token_types_str = vector::empty();
        let len = vector::length(&tokens);
        let mut i = 0;
        while (i < len) {
            let token = *vector::borrow(&tokens, i);
            let label_content = match token.token_type {
                LexicalAnalyser::TokenType::Identifier => b"Identifier",
                LexicalAnalyser::TokenType::Keyword => b"Keyword",
                LexicalAnalyser::TokenType::Symbol => b"Symbol",
                LexicalAnalyser::TokenType::Literal => b"Literal",
                LexicalAnalyser::TokenType::EOF => b"EOF",
            };
            // Add a diagnostic label for each token type
            Diagnostics::add_label(
                account,
                label_content,
                vector::append(b"Token at position ", &vector::to_bytes(&[token.position as u8]))
            );
            i = i + 1;
        }
    }
}

//# run 0x1234::FeatureTest::run_tests --signers 0x1234