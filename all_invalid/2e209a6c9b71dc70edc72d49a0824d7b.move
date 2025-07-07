//# publish
module 0x1::TestModule {
    /// A resource that holds a key with optional address and module name.
    struct Key has copy, drop, store {
        address_option: option address,
        module_name: vector<u8>,
    }

    /// Function to create a new key with optional address
    public fun create_key(addr_opt: option address, name: vector<u8>): Key {
        Key {
            address_option: addr_opt,
            module_name: name,
        }
    }

    /// Function to test diagnostic message with label
    public fun diagnostic_test(label: vector<u8>) {
        // Intentionally cause a parsing diagnostic message
        // e.g., invalid token to trigger an error message with label
        // (In actual test, we simulate with a dummy error)
        // Note: Move compiler doesn't support runtime errors, so this is illustrative
        // or can be left as an invalid expression to generate compiler diagnostics.
        let _dummy = 0xDEADBEEFu128; // Dummy line for parsing check
        // Using label in code comments or as part of debug info (not runtime but for test)
        // No runtime effect
        // To force diagnostic, we can use an invalid token like:
        // invalid_token // which will cause compile time error (but here just illustrative)
    }

    /// Function that includes code snippets in diagnostic messages (simulated)
    public fun labels_in_diagnostics() {
        // For demonstration, just a placeholder comment with labels
        // In real compiler diagnostics, labels can be incorporated in error messages
        // e.g., "Error at marker [label: CODE_SNIPPET_1]"
        // which is not directly possible in code but in diagnostics
        // So we include comments with labels to simulate
        // e.g.,
        // [label: code_block_start]
        // move { ... }
        // [label: code_block_end]
    }
}

//# run 0x1::TestModule::create_key --signers 0xA550 --args 0x1 option::some 0x2a0::ModuleName::NameBytes
//# run 0x1::TestModule::diagnostic_test --signers 0xA550 --args "label1"