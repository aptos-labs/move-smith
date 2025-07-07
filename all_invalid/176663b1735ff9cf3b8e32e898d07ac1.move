
//# publish
module 0xCAFE::FunctionPurenessChecker {
    use std::vector;

    // Dummy function to simulate function purity check
    public fun check_purity() { /* implementation */ }
}


//# publish
module 0xCAFE::Symbol {
    use std::vector;

    struct Symbol {
        value: vector<u8>,
    }

    public fun from(s: &vector<u8>): Symbol {
        // Use the provided byte vector directly instead of string
        Symbol { value: copy s }
    }
}



//# publish
module 0xCAFE::TestModule {
    use std::vector;
    use 0xCAFE::FunctionPurenessChecker;
    use 0xCAFE::Symbol;

    // Function to verify function purity
    public fun verify_pure_function() {
        FunctionPurenessChecker::check_purity();
    }

    // Function to check no tail jump
    public fun check_no_tail_jump(): bool {
        // dummy code to represent control flow without tail jump
        let x = 1;
        if (x > 0) {
            return true;
        } else {
            return false;
        }
    }

    // Function to convert vector of string references to vector of Symbol instances
    public fun convert_strings_to_symbols(strings: vector<vector<u8>>): vector<Symbol::Symbol> {
        let symbols = vector::empty<Symbol::Symbol>();
        let len = vector::length(&strings);
        let i = 0;
        while (i < len) {
            let s_ref = &vector::borrow(&strings, i);
            let symbol = Symbol::from(s_ref);
            vector::push_back(&mut symbols, symbol);
            i = i + 1;
        }
        symbols
    }
}


//# run 0xCAFE::TestModule::verify_pure_function --signers 0xCAFE


//# run 0xCAFE::TestModule::check_no_tail_jump --signers 0xCAFE


//# run 0xCAFE::TestModule::convert_strings_to_symbols --signers 0xCAFE --args b"hello" b"world"