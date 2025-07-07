
//# publish
module 0xCAFE::CombinedTests {
    use std::vector;
    use std::string;

    /// Calculate the greatest product of 4 consecutive digits in the vector
    public fun greatest_product_of_4_digits(digits: vector<u8>): u64 {
        let length = vector::length(&digits);
        if (length < 4) {
            0u64
        } else {
            let max_product = 0u64;
            let i = 0;
            while (i + 3 < length) {
                let d0 = (*vector::borrow(&digits, i)) as u64;
                let d1 = (*vector::borrow(&digits, i + 1)) as u64;
                let d2 = (*vector::borrow(&digits, i + 2)) as u64;
                let d3 = (*vector::borrow(&digits, i + 3)) as u64;
                let product = d0 * d1 * d2 * d3;
                if (product > max_product) {
                    max_product = product;
                };
                i = i + 1;
            };
            max_product
        }
    }

    /// Enum for TokenType simulating parser token start types
    public enum TokenType has copy, drop {
        Number,
        ByteString,
        Identifier,
        AtSymbol,
        Ampersand,
        Asterisk,
        Exclamation,
        Invalid,
    }

    /// Function to check if the token type is a valid parser start token
    public fun is_valid_parser_start(token: TokenType): bool {
        match token {
            TokenType::Number => true,
            TokenType::ByteString => true,
            TokenType::Identifier => true,
            TokenType::AtSymbol => true,
            TokenType::Ampersand => true,
            TokenType::Asterisk => true,
            TokenType::Exclamation => true,
            _ => false,
        }
    }

    /// Simulate parsing an address string.
    /// Return error code u64 1001 for invalid address formats.
    public fun parse_address(addr: vector<u8>): u64 {
        // Address must be exactly 32 bytes and only hex digits (0-9, a-f, A-F)
        if (vector::length(&addr) != 32) {
            return 1001u64;
        };

        let i = 0;
        while (i < 32) {
            let c = *vector::borrow(&addr, i);
            // Check c is 0-9, a-f or A-F ASCII codes
            let valid_digit = (c >= 48u8 && c <= 57u8) ||
                (c >= 65u8 && c <= 70u8) ||
                (c >= 97u8 && c <= 102u8);
            if (!valid_digit) {
                return 1001u64;
            };
            i = i + 1;
        };
        // Valid address
        0u64
    }

    /// Runner function that exercises greatest product, parser start token check, and address parser with invalid input
    public fun run_all_tests(): (u64, bool, u64) {
        // Test greatest_product_of_4_digits with diverse digit vectors

        // Vector with zeros (should handle zeros)
        let digits0 = vector[0u8,1u8,0u8,7u8,9u8,0u8,3u8,4u8]: vector<u8>;
        let r0 = greatest_product_of_4_digits(digits0);

        // Vector with repeated digit 9 (max digit)
        let digits1 = vector[9u8,9u8,9u8,9u8,9u8,9u8]: vector<u8>;
        let r1 = greatest_product_of_4_digits(digits1);

        // Vector shorter than 4 digits (should return 0)
        let digits2 = vector[2u8, 5u8]: vector<u8>;
        let r2 = greatest_product_of_4_digits(digits2);

        // Vector all ones (product should be 1)
        let digits3 = vector[1u8,1u8,1u8,1u8,1u8]: vector<u8>;
        let r3 = greatest_product_of_4_digits(digits3);

        // Sum results of all these to combine (just for test purpose)
        let product_sum = r0 + r1 + r2 + r3;

        // Test is_valid_parser_start function for each valid token
        let valid_tokens = vector[
            TokenType::Number, TokenType::ByteString, TokenType::Identifier,
            TokenType::AtSymbol, TokenType::Ampersand, TokenType::Asterisk,
            TokenType::Exclamation
        ];

        let all_valid_true = true;
        let len = vector::length(&valid_tokens);
        let idx = 0;
        while (idx < len) {
            let t = *vector::borrow(&valid_tokens, idx);
            if (!is_valid_parser_start(t)) {
                all_valid_true = false;
            };
            idx = idx + 1;
        };

        // Test parse_address with invalid addresses and confirm error code 1001

        // Invalid length (less than 32)
        let addr1 = vector[48u8, 49u8, 50u8]: vector<u8>; // "012"
        let err1 = parse_address(addr1);

        // Invalid characters (non-hex letters)
        let invalid_char = 103u8; // char 'g'
        let v = vector::empty<u8>();
        let i = 0;
        while (i < 32) {
            if (i == 9) {
                vector::push_back(&mut v, invalid_char);
            } else {
                vector::push_back(&mut v, 48u8);
            };
            i = i + 1;
        };
        let addr2 = v;
        let err2 = parse_address(addr2);

        // Valid address all '0's
        let addr3 = vector::empty<u8>();
        let i = 0;
        while (i < 32) {
            vector::push_back(&mut addr3, 48u8);
            i = i + 1;
        };
        let err3 = parse_address(addr3);

        // Return:
        // combined greatest product sums,
        // all parser starts detected as valid,
        // sum of error codes for invalid addresses (should be 1001+1001, ignoring valid addr 0)
        let err_sum = err1 + err2 + err3; // last is 0, adding

        (product_sum, all_valid_true, err_sum)
    }

    /// Integrated test function: receives digits vector and a token,
    /// runs greatest_product_of_4_digits and is_valid_parser_start,
    /// and parses an invalid address returns their combined result.
    public fun integrated_test(digits: vector<u8>, token: TokenType, invalid_addr: vector<u8>): (u64, bool, u64) {
        let product = greatest_product_of_4_digits(digits);
        let valid_start = is_valid_parser_start(token);
        let err_code = parse_address(invalid_addr);
        (product, valid_start, err_code)
    }

    /// Helper to create a vector<u8> from a u8 array literal (for testing)
    public fun vector_from_slice(s: vector<u8>): vector<u8> {
        let v = vector::empty<u8>();
        let len = vector::length(&s);
        let i = 0;
        while (i < len) {
            vector::push_back(&mut v, *vector::borrow(&s, i));
            i = i + 1;
        };
        v
    }
}
