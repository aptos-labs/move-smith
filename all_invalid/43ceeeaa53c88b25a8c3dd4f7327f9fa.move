//# publish
module 0x1::TestModule {
    // Function to return a nested type chain as a string (simulated)
    public fun get_type_chain(): vector<string> {
        let chain = vector::empty<string>();
        vector::push_back(&mut chain, "0x1::Outer");
        vector::push_back(&mut chain, "Inner");
        vector::push_back(&mut chain, "Type");
        chain
    }

    // Function to simulate accessing a module type via chained syntax
    public fun access_chained_type(): bool {
        // Simulate navigating through chain (no actual code needed)
        // In real tests, this could involve calling functions or accessing published resources
        true
    }

    // Function to generate diagnostic notes with multiple notes attached
    public fun generate_diagnostic_notes(): (string, vector<string>) {
        let message = "Expected type mismatch detected.";
        let notes = vector::empty<string>();
        vector::push_back(&mut notes, "Note 1: Check if the module address is correct.");
        vector::push_back(&mut notes, "Note 2: Verify that the type chain is correctly formed.");
        (message, notes)
    }

    // Function to test lexical analysis and tokenization of Move source code
    public fun lex_and_tokenize(source_code: &vector<u8>): bool {
        // Placeholder for actual lexer and parser, simulate success
        true
    }
}
//# run 0x1::TestModule::access_chained_type --signers 0x1 --args
// This script tests accessing module types through chained syntax.

//# run 0x1::TestModule::generate_diagnostic_notes --signers 0x1
// This script retrieves diagnostic message with multiple notes attached.

//# run 0x1::TestModule::lex_and_tokenize --signers 0x1 --args b"module A { fun f() {} }".to_vec()
// This script tests lexical analysis and tokenization on sample source code.