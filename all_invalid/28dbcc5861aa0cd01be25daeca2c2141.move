//# publish
module 0x1::TestModule {
    // This module tests multiple features as part of the transactional test.

    // Feature 1: Use module keys with optional address and module name.
    // For this, we define a module with a different namespace.
    module 0xABC::AddressedModule {
        // A simple stored resource to test key persistence.
        struct Data has key {
            value: u64,
        }

        public fun init_data(account: &signer, val: u64) {
            move_to(account, Data { value: val });
        }

        public fun get_data(account: &signer): u64 acquires Data {
            let data = borrow_global::<Data>(Signer::address_of(account));
            data.value
        }
    }

    // Feature 2: Include code snippets/identifiers in diagnostic messages.
    // We'll add a function with an intentional error (misspelled variable name)
    // with custom error message to simulate diagnostic inclusion.
    public fun faulty_function() {
        let x = 10;
        // Misuse identifier to generate an error.
        // In real compiler diagnostics, this would produce a message referencing 'x' or similar.
        // Since we can't produce actual compiler errors here, this is a placeholder.
        // In actual test, this should cause a compile error with diagnostic referencing a code snippet.
        // For illustration:
        error("Diagnostic message: Usage of variable x in faulty_function.");
    }

    // Feature 3: Handle lexical analysis and tokenization.
    // Simulate code snippets with various tokens.
    // We will include a function that contains string constants, comments, and various tokens.
    public fun parse_tokens() {
        // Token examples
        let a = 42; // number token
        // String literal
        let s = "move language tokens: keyword, identifier, literal, comment!";
        // Comment with tricky symbols
        // /* multi-line comment */
        // Tokens like parentheses:
        let _ = (a + 1);
        // Use various operators and punctuations.
        let b = a * 2 - 1 / 3;
        // Do nothing, just to include tokens.
    }

    // Runner function to execute the above functions sequentially.
    public fun run_all() {
        // This function can be called to exercise various code paths.
        // Initialize data in AddressedModule.
        //# run 0x1::TestModule::run_all
        // We will invoke init_data in the test script.
    }
}

//# run 0x1::TestModule::run_all --signers 0xA550 --args 

//# run 0xABC::AddressedModule::init_data --signers 0xA550 --args 100u64

// Additional script to invoke the faulty_function and parse_tokens for compilation/VM exercising.
// Despite 'faulty_function' not producing real errors, including it for completeness.

//# run 0x1::TestModule::faulty_function --signers 0xA550

//# run 0x1::TestModule::parse_tokens