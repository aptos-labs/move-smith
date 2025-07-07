//# publish
module 0xCAFE::TestExprListAndIndex {
    use std::vector;
    use std::string;

    // Convert string vector to vector of symbols (vector<u8>)
    public fun strings_to_symbols(strings: vector<string::String>): vector<vector<u8>> {
        let mut symbols = vector::empty<vector<u8>>();
        let len = vector::length(&strings);
        let mut i = 0;
        while (i < len) {
            let s = vector::borrow(&strings, i);
            vector::push_back(&mut symbols, string::utf8_bytes(s));
            i = i + 1;
        };
        symbols
    }

    // Use expression lists and index expressions, return first symbol's first byte or 0 if empty
    public fun first_byte_of_first_symbol(strings: vector<string::String>): u8 {
        let symbols = Self::strings_to_symbols(strings);
        if (vector::length(&symbols) == 0) {
            0
        } else {
            let first_sym = *vector::borrow(&symbols, 0);
            if (vector::length(&first_sym) == 0) {
                0
            } else {
                *vector::borrow(&first_sym, 0)
            }
        }
    }

    // Return a NumericalAddress formed from a vector of 16 u8 bytes (simulate spanned address)
    public fun make_spanned_address(bytes: vector<u8>): address {
        assert!(vector::length(&bytes) == 16, 999);
        let mut i = 0;
        let mut addr = 0u128;
        while (i < 16) {
            addr = addr << 8;
            let b = *vector::borrow(&bytes, i) as u128;
            addr = addr | b;
            i = i + 1;
        };
        // Interpretation: address is 128-bit, Aptos addresses are 16 bytes. Casting u128 to address must be done carefully.
        // Use unsafe cast (Move does not have native cast here), but for test simplicity, just cast u128 to address.
        // In Move on Aptos, address is 16 bytes fixed length, we return address(addr) by copying the u128 value.
        // Here just use `addr as address` by unsafe cast simulation:
        move_from_u128(addr)
    }

    // This helper function is private, fake cast u128 to address
    native fun move_from_u128(val: u128): address;

    // Runner function to test the above functions without arguments
    public fun runner(): u8 {
        let strs = vector::empty<string::String>();
        vector::push_back(&mut strs, string::utf8(b"test"));
        vector::push_back(&mut strs, string::utf8(b"symbol"));
        let first_byte = Self::first_byte_of_first_symbol(strs);

        let bytes = vector::empty<u8>();
        // Fill bytes with 16 values
        let mut i = 0;
        while (i < 16) {
            vector::push_back(&mut bytes, i as u8);
            i = i + 1;
        };
        let _addr = Self::make_spanned_address(bytes);

        first_byte
    }
}

//# run 0xCAFE::TestExprListAndIndex::runner

// Featurres:
// a8cef2c6ccfbd5577bce7d1c3b7c4960: Write expression lists and index expressions (array or vector access).
// 78af512b113f55770b2a635ce9a9d77c: Convert a list of strings into a list of symbols for usage in your Move code
// 23a9348afd2bf228c638cc8855a47381: Return a spanned (location-aware) NumericalAddress for further use in code analysis or compilation.
