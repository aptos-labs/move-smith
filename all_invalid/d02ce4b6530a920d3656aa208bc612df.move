//# publish
module 0x123::ModuleA {
    use std::debug;

    // A resource with a key containing an optional address and module name
    struct DataKey has key {
        id: u64,
        optional_addr: option address,
        module_name: vector<u8>,
    }

    // Store a DataKey resource
    public fun store_data_key(account: &signer, id: u64, addr_option: option address, module_name: vector<u8>) {
        let key = DataKey { id, optional_addr: addr_option, module_name };
        move_to(account, key);
    }

    // Retrieve a DataKey resource
    public fun get_data_key(addr: address): &DataKey acquires DataKey {
        let key_ref = borrow_global<DataKey>(addr);
        debug::print("[diagnostic:DataKey] Retrieving DataKey resource");
        key_ref
    }

    // Runner function to test storing and retrieving DataKey
    public fun run_tests() {
        let signer_addr = @0x1;
        // Store a DataKey with optional address Some(addr)
        store_data_key(&signer_addr, 42, some(@0x2), b"ModuleA".to_vec());
        // Retrieve and debug print
        let key_ref = get_data_key(@0x1);
        debug::print("[diagnostic:KeyRetrieved] DataKey with id: ", &key_ref.id);
    }
}

//# run 0x1::ModuleA::run_tests --signers 0x1

//# publish
module 0x456::Diagnostics {
    use std::debug;

    // Diagnostic message with labels
    public fun emit_label(label: &vector<u8>) {
        debug::print("[diagnostic:label] ", label);
    }
}

//# run 0x1::Diagnostics::emit_label --args b"LexicalAnalysis" 

//# publish
module 0x789::TokenHandling {
    use std::debug;

    // Function to simulate tokenization process
    public fun tokenize_source(source: &vector<u8>) {
        // For illustration, just print diagnostic with source snippet
        debug::print("[diagnostic:Tokenize] Source snippet: ", source);
        // Simulate lexical analysis diagnostic message
        emit_token_labels();
    }

    public fun emit_token_labels() {
        debug::print("[diagnostic:LexicalTokens] Token labels generated during parsing");
    }

    // Runner function for tokenization test
    public fun run_tokenization(source: vector<u8>) {
        tokenize_source(&source);
    }
}

//# run 0x789::TokenHandling::run_tokenization --args b"let x = 10;\" 