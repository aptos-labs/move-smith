//# publish
module 0xCAFE::LoopInvariants {
    /// A function that sums numbers from 1 to n using a loop with loop invariants.
    public fun sum(n: u64): u64 {
        let mut i = 1;
        let mut sum = 0;

        // Invariants:
        //  1 <= i <= n + 1
        // sum == (i - 1) * i / 2
        loop {
            // loop invariant (informal in comments, Move does not have built-in invariant syntax)
            assert!(i <= n + 1, 1);
            assert!(sum == (i - 1) * i / 2, 2);

            if (i > n) {
                break;
            }
            sum = sum + i;
            i = i + 1;
        }
        sum
    }
}

//# run 0xCAFE::LoopInvariants::sum --args 10u64

//# publish
module 0xCAFE::AddressParser {
    use std::string;
    use std::error;
    use std::signer;

    /// Optional: a function that tries to parse an address string "0x..." and returns address or abort
    public fun from_string(addr_str: &string::String): address {
        // The string must start with '0x' and followed by exactly 16 hex chars (Aptos standard)
        let addr_len = string::utf8_length(addr_str);

        // The minimal length is 2 + 16 = 18
        if (addr_len != 18) {
            abort 1;
        }
        let prefix = string::sub_string(addr_str, 0, 2);
        if (prefix != *"0x") {
            abort 2;
        }
        // Check each character is hex digit
        let mut i = 2;
        while (i < 18) {
            let c = string::sub_string(addr_str, i, i + 1);
            let b = byte_from_char(&c);
            if (!(is_hex_digit(b))) {
                abort 3;
            }
            i = i + 1;
        }
        vector_to_address(string::utf8_bytes(addr_str, 2, 18))
    }

    // Converts a UTF8 string of length 16 hex chars into an address
    fun vector_to_address(vec: vector<u8>): address {
        // address is 16 bytes, vec must be 16 bytes with hex ASCII, need to convert hex ASCII to u8 byte array
        let mut addr_bytes = vector::empty<u8>();
        let mut idx = 0;
        while (idx < 16) {
            let high_char = vector::borrow(&vec, idx);
            let low_char = vector::borrow(&vec, idx + 1);
            let high_nibble = hex_char_to_nibble(*high_char);
            let low_nibble = hex_char_to_nibble(*low_char);
            let byte_val = (high_nibble << 4u8) | low_nibble;
            vector::push_back(&mut addr_bytes, byte_val);
            idx = idx + 2;
        }
        *address::from_bytes(&addr_bytes)
    }

    fun byte_from_char(s: &string::String): u8 {
        let b = string::byte_at(s, 0);
        b
    }

    fun is_hex_digit(b: u8): bool {
        (b >= 48 && b <= 57)  // '0'..'9'
        || (b >= 65 && b <= 70) // 'A'..'F'
        || (b >= 97 && b <= 102) // 'a'..'f'
    }

    fun hex_char_to_nibble(b: u8): u8 {
        if (b >= 48 && b <= 57) {
            b - 48
        } else if (b >= 65 && b <= 70) {
            b - 65 + 10
        } else if (b >= 97 && b <= 102) {
            b - 97 + 10
        } else {
            abort 100 // invalid hex char
        }
    }
}

//# run 0xCAFE::AddressParser::from_string --args '0x0123456789ABCDEF0123456789ABCDEF'

//# run 0xCAFE::AddressParser::from_string --args '0xINVALIDADDRESS!!!' 

//# publish
module 0xCAFE::ApplyWithExcept {
    use std::vector;
    use std::string;

    /// Function simulating applying list of patterns except for some blacklist patterns.
    /// Patterns and except_patterns are list of strings.
    public fun apply_patterns(patterns: vector<string::String>, except_patterns: vector<string::String>): vector<string::String> {
        let mut results = vector::empty<string::String>();
        let mut i = 0;
        while (i < vector::length(&patterns)) {
            let current = vector::borrow(&patterns, i);
            if (!contains(&except_patterns, current)) {
                vector::push_back(&mut results, *current);
            }
            i = i + 1;
        }
        results
    }

    fun contains(vec: &vector<string::String>, val: &string::String): bool {
        let mut i = 0;
        while (i < vector::length(vec)) {
            if (*(vector::borrow(vec, i)) == *val) {
                return true;
            }
            i = i + 1;
        }
        false
    }
}

//# run 0xCAFE::ApplyWithExcept::apply_patterns --args ["pattern1", "pattern2", "pattern3"] ["pattern2"]

//# run
script {
    use 0xCAFE::LoopInvariants;
    use 0xCAFE::AddressParser;
    use 0xCAFE::ApplyWithExcept;
    use std::vector;
    use std::string;

    fun main() {
        // Test sum function
        let s = LoopInvariants::sum(5);
        // No assertions needed

        // Test address parser with valid and invalid strings
        let _valid_addr = AddressParser::from_string(string::utf8(b"0x0123456789ABCDEF01234567"));
        // This will abort (invalid string)
        // let _invalid_addr = AddressParser::from_string(string::utf8(b"0xGHIJKLMNOPQRSTUVWX"));

        // Test apply_patterns with except
        let pats = vector::empty<string::String>();
        vector::push_back(&mut pats, string::utf8(b"alpha"));
        vector::push_back(&mut pats, string::utf8(b"beta"));
        vector::push_back(&mut pats, string::utf8(b"gamma"));

        let excepts = vector::empty<string::String>();
        vector::push_back(&mut excepts, string::utf8(b"beta"));

        let res = ApplyWithExcept::apply_patterns(pats, excepts);
    }
}

// Featurres:
// 82a0a59b494fa982d851f402af597651: Include loop invariants within loops to ensure certain conditions hold throughout loop execution.
// 7ab92ea5d2863d23fcaea5a943233566: Handle invalid address string inputs by generating a diagnostic error.
// e22221b32e33aa69eef00d30b5419f3e: Optionally exclude specific patterns from an 'apply' by adding 'except <patterns>' in the same syntax.
