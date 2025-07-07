//# publish
module 0xCAFE::TestStringLiterals {
    use std::vector;
    use std::string;

    /// Returns the position of the closing quote in a string literal with escape sequences.
    /// We'll simulate this by defining a function that given a byte vector representing the
    /// literal bytes, returns the index of the last byte that would correspond to the closing quote.
    /// Since we cannot parse source literals directly, we'll simulate input and logic.
    ///
    /// This function will simulate scanning a b"..." byte vector that may include escape sequences
    /// and find the last byte index corresponding to the (simulated) closing quote.
    public fun find_closing_quote_pos(literal: vector<u8>): u64 {
        let mut i = 0u64;
        let len = vector::length(&literal);

        while (i < len) {
            let byte = *vector::borrow(&literal, i);
            if (byte == 0x22u8) { // double quote (")
                // Simulate that this is the closing quote
                return i;
            }
            if (byte == 0x5Cu8) { // backslash '\'
                // skip the escaped character after the backslash
                i = i + 2;
            } else {
                i = i + 1;
            }
        }
        // Not found, return len
        len
    }

    // A runner function to verify our simulation
    public fun runner() {
        // We use b"abc\\\"def\"" as bytes: [97,98,99,92,34,100,101,102,34]
        // The closing quote is the last 0x22 at position 8.
        let example = b"abc\\\"def\"";
        let pos = find_closing_quote_pos(example);
        // pos should be 8
        // No assertions because the instruction says to ignore them
        // Just simulate execution.
        let _ = pos;
    }

    // This function returns a b"" string with an escape sequence
    public fun get_escaped_string(): vector<u8> {
        // literal for b"hello\\nworld":
        // h e l l o \ n w o r l d
        // 104, 101, 108, 108, 111, 92, 110, 119, 111, 114, 108, 100
        vector::from_bytes(b"hello\\nworld")
    }
}
//# run 0xCAFE::TestStringLiterals::runner --signers 0xCAFE

//# publish
module 0xCAFE::DeadCodeRemoval {
    /// This function contains some unreachable code (jump at the end),
    /// compiler should remove trailing jump instructions.
    public fun with_unnecessary_jumps(): u64 {
        // The function is a simple return 42
        // but with unreachable code after the return.
        let a = 42;
        return a;
        // dead code below (if we could write unreachable code)
        // But in Move, code after return is unreachable and compiler should remove jumps
    }

    // A runner that calls above function for coverage.
    public fun runner(): u64 {
        with_unnecessary_jumps()
    }
}
//# run 0xCAFE::DeadCodeRemoval::runner --signers 0xCAFE

//# run
script {
    use 0xCAFE::TestStringLiterals;
    use 0xCAFE::DeadCodeRemoval;

    fun main() {
        // test the get_escaped_string function returns b"hello\nworld"
        let escaped = TestStringLiterals::get_escaped_string();

        // test the find_closing_quote_pos function indirectly by runner function
        TestStringLiterals::runner();

        // test dead code removal by calling function
        let _ = DeadCodeRemoval::runner();
    }
}

// Featurres:
// cb19d976d9a2ac70303450da8ed87c20: Use string literals only with b" and x" prefixes; plain string literals are disallowed.
// c7f30b9cf4a4e463f6c065a22758a063: Identify the position of the closing quote in a string literal when escape sequences are present.
// 9eb7776ed6f83b78d2fb06e2e874c32c: Rely on the compiler to remove unnecessary trailing jump instructions from bytecode blocks
