//# publish
module 0xDEADFACE::KeyModule {
    /// A simple resource to hold a key value, optional address
    struct Key has key {
        value: u64,
    }

    /// Publish a key resource under a signer
    public fun publish_key(account: &signer, key_value: u64) {
        move_to(account, Key { value: key_value });
    }

    /// Function that uses an optional address in the module key
    public fun get_module_key_label(): vector<u8> {
        // Diagnostic message snippet: "Module key label: <address>"
        let label = b"Module key label: 0xDEADFACE";
        label
    }
}

//# run 0x1::0xDEADFACE::publish_key --signers 0x1 --args 42u64
//# run 0x1::KeyModule::get_module_key_label
// Inside the compiler, ensure the label "Module key label: 0xDEADFACE" appears in diagnostics

//# publish
module 0xFACE::LexerAnalyzer {
    /// Function to test lexical analysis diagnostics
    public fun lex_test(): bool {
        // Diagnostic message snippet: "Lexical analysis token: IDENTIFIER 'move'"
        let token_str = "move";
        // Simulate tokenization process
        if (token_str == "move") {
            // pass
            true
        } else {
            false
        }
    }
}

//# run 0x1::LexerAnalyzer::lex_test --signers 0x1
// Expect diagnostic message containing: "Lexical analysis token: IDENTIFIER 'move'"

//# publish
module 0xBEEF::InliningTest {
    import 0xBEEF::Helper;

    // Helper inline function to be inlined
    public fun inline_helper(x: u64): u64 {
        // Diagnostic message snippet: "Inlining helper function"
        x + 10
    }

    // Runner function that calls the inline function
    public fun run_inline(): u64 {
        let result = inline_helper(5);
        result
    }

    // Function that calls the inlined helper (simulate inlining)
    public fun inline_and_run(): u64 {
        // Inline expansion: replace call to inline_helper(5) with its body
        5 + 10
    }
}

//# run 0xBEEF::InliningTest::run_inline --signers 0xBEEF
//# run 0xBEEF::InliningTest::inline_and_run
// Verify that the inlining process replaces the call with its body