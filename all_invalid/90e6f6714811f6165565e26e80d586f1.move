//# publish
module 0x1::DiagnosticLabels {
    /// Function to demonstrate labeling in diagnostics
    public fun label_example() {
        // Example code that might generate diagnostic messages with labels
        // (In actual diagnostics, labels are attached to code snippets)
    }
}

//# publish
module 0x2::KeyModule {
    /// Module with optional address and key inclusion
    struct Key has copy, drop, store {
        value: u64,
        optional_addr: Option<Address>,
    }

    public fun create_key(val: u64, addr_opt: Option<Address>): Key {
        Key { value: val, optional_addr: addr_opt }
    }
}

//# publish
module 0x3::LexerTokenTest {
    /// Module to test lexical analysis and tokenization during parsing
    use 0x1::DiagnosticLabels;
    use 0x2::KeyModule;

    /// Function to test tokenization labels
    public fun tokenize_demo() {
        // Placeholder: In practice, this would trigger lexical analysis for move source
        let _dummy_token1 = 123;
        let _dummy_token2 = "token";
    }
}

//# publish
module 0x4::ConditionalLogic {
    /// Function to test `test` with conditional logic and variable reassignment
    public fun test(flag: bool): u64 {
        let mut counter = 0;
        if (flag) {
            counter = 10;
        } else {
            counter = 20;
        }
        // Reassign variable
        let counter = counter + 5;
        counter
    }
}

//# publish
module 0x5::SourceLocationAnnot {
    /// Module annotated with source location info
    // source_location: file "test.move", line 100, col 1
    module 0x5::LocationAnnot {
        // module name location: "LocationAnnot" at line 101
        public fun dummy() {}
    }
}

//# publish
module 0x6::Main {
    use 0x4::ConditionalLogic;
    use 0x3::LexerTokenTest;
    use 0x5::LocationAnnot;

    /// Runner function that invokes various tests
    public fun run_all() {
        // Call the tokenize demo to test lexical analysis
        // (Imagine this as testing parsing/tokenization)
        LexerTokenTest::tokenize_demo();

        // Test the `test` function with true flag
        let result_true = ConditionalLogic::test(true);
        // Test the `test` function with false flag
        let result_false = ConditionalLogic::test(false);
    }
}

//# run 0x6::Main::run_all --signers 0x0