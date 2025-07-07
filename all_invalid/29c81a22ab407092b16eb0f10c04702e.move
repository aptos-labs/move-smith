//# publish
module 0xA11::LexicalAnalysisTest {
    /// A simple key token structure for module keys
    struct ModuleKey has copy, drop, store {
        address: address,
        name: vector<u8>,
    }

    /// Function to create a module key with explicit address
    public fun create_module_key_with_address(addr: address, name: vector<u8>): ModuleKey {
        ModuleKey { address: addr, name }
    }

    /// Function to create a module key with optional address (simulate optional address)
    public fun create_module_key_optional(addr_option: option<address>, name: vector<u8>): vector<u8> {
        // Represent optional address as bytes: 0x01 for Some, 0x00 for None
        let mut key_bytes = vector::empty<u8>();
        match addr_option {
            option::some(addr) => {
                vector::push(&mut key_bytes, 0x01);
                vector::append(&mut key_bytes, bcs::to_bytes(&addr));
            },
            option::none() => {
                vector::push(&mut key_bytes, 0x00);
            }
        };
        // Append name for identification
        vector::append(&mut key_bytes, &name);
        key_bytes
    }

    /// Function to generate diagnostic message including identifiers
    public fun diag_message(label: &vector<u8>, code: &vector<u8>) {
        // Use move std debug::print to output diagnostic
        debug::print(&label);
        debug::print(&code);
    }

    /// Simulate code snippet display (diagnostics)
    public fun show_code_snippet(identifier: &vector<u8>, code_snippet: &vector<u8>) {
        // Concatenate identifier and code snippet
        let mut msg = vector::empty<u8>();
        vector::append(&mut msg, identifier);
        vector::push(&mut msg, b':');
        vector::push(&mut msg, b' ');
        vector::append(&mut msg, code_snippet);
        diag_message(&msg, &msg);
    }
}

//# publish
module 0xBEEF::LexTestModule {
    /// A function to test tokenization diagnostics with labels for token types
    public fun tokenize_and_diagnose(source_code: vector<u8>) {
        // Dummy tokenizer simulation: identify tokens as bytes
        // For testing, create labels for different token types
        let labels: vector<vector<u8>> = vector::empty();

        let i = 0;
        while (i < vector::length(&source_code)) {
            let byte = *vector::borrow(&source_code, i);
            if (byte >= 65 && byte <= 90) {
                // Uppercase letter: symbol token
                let symbol_label = b"Symbol".to_vec();
                // Show diagnostic
                let code_snippet = vector::slice(&source_code, i, 1);
                LexicalAnalysisTest::show_code_snippet(&symbol_label, &code_snippet);
            } else if (byte >= 48 && byte <= 57) {
                // Digit token
                let digit_label = b"Digit".to_vec();
                let code_snippet = vector::slice(&source_code, i, 1);
                LexicalAnalysisTest::show_code_snippet(&digit_label, &code_snippet);
            } else {
                // Other token (e.g., punctuation)
                let punct_label = b"Punctuation".to_vec();
                let code_snippet = vector::slice(&source_code, i, 1);
                LexicalAnalysisTest::show_code_snippet(&punct_label, &code_snippet);
            }
            i = i + 1;
        }
    }
}

//# run 0xA11::LexicalAnalysisTest::create_module_key_with_address --args 0xC0FFEE, b"TestModule"
//# run 0xA11::LexicalAnalysisTest::create_module_key_optional --args 0x1, b"OptionalAddr"
//# run 0xA11::LexicalAnalysisTest::create_module_key_optional --args None, b"NoAddr"

//# run 0xBEEF::LexTestModule::tokenize_and_diagnose --args b"abc123!@#"
//# run 0xBEEF::LexTestModule::tokenize_and_diagnose --args b"XYZ789;."
