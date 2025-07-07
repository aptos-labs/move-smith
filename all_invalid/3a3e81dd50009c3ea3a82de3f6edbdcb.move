//# publish
module 0xABC::KeyModule {
    /// Storage for a key, stored at a specific address or default
    struct Key has key {
        value: u64,
        label: vector<u8>;
    }

    /// Initialize a key with optional label
    public fun init(owner: &signer, val: u64, label: vector<u8>) {
        move_to(owner, Key { value: val, label });
    }

    /// Get the key's label
    public fun get_label(addr: address): vector<u8> {
        borrow_global<Key>(addr).label
    }

    /// Set a new label for a key
    public fun set_label(owner: &signer, new_label: vector<u8>) {
        let key_ref = borrow_global_mut<Key>(Signer::address_of(owner));
        key_ref.label = new_label;
    }
}

//# run 0x1::KeyModule::init --signers 0x1 --args 42u64 0x64656D6F63617465u8 *label_bytes*

//# publish
module 0xDEADBEEF::Diagnostics {
    /// Perform a diagnostic message with label embedding
    public fun report_diagnostic(msg_id: u64, label: vector<u8>) {
        // Emulate embedding label info into a message
        // (In actual diagnostics, this could include more complex logic)
        if (Vector::len(&label) == 0) {
            // Label is empty
            Diagnostics::print(&Vector::borrow(&b"Diagnostic".to_vec()));
        } else {
            Diagnostics::print(&label);
        }
        // Diagnostic message identifier
        Diagnostics::print(&Vector::serialize(&msg_id));
    }

    /// Simple print function (stub)
    public fun print(msg: &vector<u8>) {
        // Placeholder for actual diagnostic output
        // For test purpose, do nothing
    }
}

//# run 0xDEADBEEF::Diagnostics::report_diagnostic --args 100u64 0x73686F7274u8
//# run 0xDEADBEEF::Diagnostics::report_diagnostic --args 101u64 0x0u8

//# publish
module 0xBADA55::ParserTest {
    /// Function to simulate lexical analysis and tokenization
    public fun analyze_source(source_code: vector<u8>) {
        // Dummy lexing: Check for certain identifiers or syntax patterns
        // For illustration, just parse for "module" keyword
        let source_str = String::utf8(&source_code);
        if (contains_keyword(&source_str, "module")) {
            // Diagnostic: found module keyword
            Diagnostics::print(&Vector::serialize(&b"LexicalAnalysis: module keyword found"));
        } else {
            Diagnostics::print(&Vector::serialize(&b"LexicalAnalysis: no module keyword"));
        }
    }

    /// Helper function to simulate keyword detection
    fun contains_keyword(source: &string, keyword: &string): bool {
        // Simple substring check
        let src_bytes = String::as_bytes(source);
        let kw_bytes = String::as_bytes(keyword);
        // Naive substring check
        let len_src = Vector::::length(&src_bytes);
        let len_kw = Vector::::length(&kw_bytes);
        if (len_kw > len_src) return false;
        let mut i = 0;
        while (i <= len_src - len_kw) {
            let mut match_found = true;
            let mut j = 0;
            while (j < len_kw) {
                if (Vector::borrow(&src_bytes, i + j) != Vector::borrow(&kw_bytes, j)) {
                    match_found = false;
                    break;
                }
                j = j + 1;
            }
            if (match_found) {
                return true;
            }
            i = i + 1;
        }
        false
    }

    /// Function to handle tokenization process
    public fun tokenize_source(source_code: vector<u8>) {
        // For testing, simulate tokenization by splitting source into tokens
        let source_str = String::utf8(&source_code);
        // For simplicity, just call analyze_source
        analyze_source(source_code);
    }
}

//# run 0xBADA55::ParserTest::analyze_source --args 0x76657273696f6e 0x636f6465u8

//# publish
module 0x0::MoveParserSimulator {
    /// Entry point to simulate parsing and diagnostics
    public fun parse_and_diagnose(source_code: vector<u8>) {
        // Run lexical analysis
        ParserTest::analyze_source(source_code);
        // Run tokenization
        ParserTest::tokenize_source(source_code);
    }
}

//# run 0x0::MoveParserSimulator::parse_and_diagnose --args 0x6d6f7665 0x73656e646572u8 0x7374617274u8