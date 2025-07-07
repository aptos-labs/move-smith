
//# publish
module 0xCAFE::CheckAttr {
    use std::error;
    use std::string;
    use std::vector;

    // Error codes
    const E_MISSING_LOCATION: u64 = 1;

    /// Enforce that a location `loc` is present when a certain attribute `attr` is used,
    /// aborting if loc is empty and attr is true.
    public fun check_location(attr: bool, loc: vector<u8>) {
        // If attr is true, loc must not be empty
        if (attr) {
            let is_empty = vector::is_empty(&loc);
            assert!(!is_empty, E_MISSING_LOCATION);
        };
    }
}



//# run 0xCAFE::CheckAttr::check_location --args true Location



//# run 0xCAFE::CheckAttr::check_location --args false ""



//# run 0xCAFE::CheckAttr::check_location --args true ""



//# publish
module 0xCAFE::LexerAdvancer {
    use std::vector;

    /// Try to advance the lexer position by one if the next byte equals to `expected`.
    /// In this simplified example, the lexer input is a vector<u8> and lexer position is the index.
    /// Returns the new position if matched, else returns original position.
    public fun advance_if_match(input: &vector<u8>, pos: u64, expected: u8): u64 {
        if (pos < vector::length(input)) {
            let c = *vector::borrow(input, pos);
            if (c == expected) {
                pos + 1
            } else {
                pos
            }
        } else {
            pos
        }
    }
}



//# run 0xCAFE::LexerAdvancer::advance_if_match --args 1u8 2u8 3u8 0u64 1u8



//# run 0xCAFE::LexerAdvancer::advance_if_match --args 1u8 2u8 3u8 1u64 1u8



//# run 0xCAFE::LexerAdvancer::advance_if_match --args 1u8 2u8 3u8 2u64 3u8




//# publish
module 0xABCD::ModuleA {
    public fun hello(): u8 {
        42
    }
}



//# run 0xABCD::ModuleA::hello



//# publish
module 0x1234::ModuleB {
    use 0xABCD::ModuleA;

    public fun call_hello(): u8 {
        ModuleA::hello()
    }
}



//# run 0x1234::ModuleB::call_hello
