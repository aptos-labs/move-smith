script {
    use std::debug;
    use std::string;

    fun format_state(addr: address, val_num: u64, val_bool: bool, val_bytes: vector<u8>): string::String {
        let num_str = string::utf8(b"Number: ");
        let bool_str = string::utf8(b", Bool: ");
        let bytes_str = string::utf8(b", Bytes: 0x");
        let val_num_str = string::utf8(debug::u64_to_bytes(val_num));
        let val_bool_str = if (val_bool) {
            string::utf8(b"true")
        } else {
            string::utf8(b"false")
        };
        // Format bytes as hex string
        let hex_chars = string::utf8(b"0123456789abcdef");
        let len = vector::length(&val_bytes);
        let mut hex_bytes = string::new();
        let mut i = 0;
        while (i < len) {
            let b = *vector::borrow(&val_bytes, i);
            let hi = b >> 4;
            let lo = b & 0xf;
            hex_bytes = string::concat(&hex_bytes, &string::slice(&hex_chars, hi as u64, hi as u64 + 1));
            hex_bytes = string::concat(&hex_bytes, &string::slice(&hex_chars, lo as u64, lo as u64 + 1));
            i = i + 1;
        }
        let state_str = string::utf8(b"addr: ");
        let addr_str = string::utf8(debug::address_to_bytes(addr));
        // Compose full state string
        let full_state = string::concat(&state_str, &addr_str);
        let full_state = string::concat(&full_state, &num_str);
        let full_state = string::concat(&full_state, &val_num_str);
        let full_state = string::concat(&full_state, &bool_str);
        let full_state = string::concat(&full_state, &val_bool_str);
        let full_state = string::concat(&full_state, &bytes_str);
        string::concat(&full_state, &hex_bytes)
    }

    fun main() {
        // -- Initialize literals --
        let addr = @0x1;
        let num_literal: u64 = 1234567890;
        let bool_literal = true;
        let bytes_literal = vector::from_utf8(b"aptos");

        // Format initial state before code offset
        let state_before = format_state(addr, num_literal, bool_literal, bytes_literal);
        debug::print(&string::utf8(b"State before offset: "));
        debug::print(&state_before);

        // -- Code offset start --

        // Use literals in expressions (numbers, booleans, byte strings)
        let computed_num = num_literal + 42;
        let computed_bool = (bool_literal && false) || true;
        // Bytes concatenation
        let suffix_bytes = vector::from_utf8(b"_vm");
        let mut combined_bytes = vector::empty<u8>();
        // Add all bytes from bytes_literal
        let len_base = vector::length(&bytes_literal);
        let mut i = 0;
        while (i < len_base) {
            combined_bytes = vector::push_back(combined_bytes, *vector::borrow(&bytes_literal, i));
            i = i + 1;
        }
        // Add all bytes from suffix_bytes
        let len_suf = vector::length(&suffix_bytes);
        let mut j = 0;
        while (j < len_suf) {
            combined_bytes = vector::push_back(combined_bytes, *vector::borrow(&suffix_bytes, j));
            j = j + 1;
        }

        // Format state after code offset
        let state_after = format_state(addr, computed_num, computed_bool, combined_bytes);
        debug::print(&string::utf8(b"State after offset: "));
        debug::print(&state_after);

        // -- Code offset end --

        // Return the computed_num as the final expression, without trailing semicolon (allowed)
        computed_num
    }
}

// Featurres:
// d52e9087944003edc064087a8ad86564: Use literals in expressions, including numbers, booleans, and byte strings.
// 43de0db466755c92c60ddc4728051400: Format the initialized state information before and after a given code offset into a human-readable string.
// 4b1e2b46aabc7fb4cadc6b955a2b1035: Write code blocks where the final expression is allowed without a trailing semicolon to return its value.
