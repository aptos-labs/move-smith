
//# publish
module 0xCAFE::TokenConsumption {
    use std::string;
    use std::vector;

    /// Enum to simulate simple tokens for testing
    enum Token has copy, drop, store {
        LeftBracket,
        RightBracket,
        Comma,
        Number(u64),
        Identifier(vector<u8>),
    }

    /// Consume a token from the list and ensure it is the expected token
    public fun consume_token(tokens: &mut vector<Token>, expected: Token): bool {
        // If empty tokens, fail fast with return false
        if (vector::is_empty(tokens)) {
            return false;
        };
        let first = *vector::borrow(tokens, 0);
        if (!token_equals(first, expected)) {
            return false;
        };
        // Remove the first token
        vector::remove(tokens, 0);
        true
    }

    /// Helper function to compare tokens
    public fun token_equals(token1: Token, token2: Token): bool {
        match token1 {
            Token::LeftBracket => matches!(token2, Token::LeftBracket),
            Token::RightBracket => matches!(token2, Token::RightBracket),
            Token::Comma => matches!(token2, Token::Comma),
            Token::Number(n1) => {
                match token2 {
                    Token::Number(n2) => n1 == n2,
                    _ => false,
                }
            },
            Token::Identifier(id1) => {
                match token2 {
                    Token::Identifier(id2) => string::utf8_equal(&id1, &id2),
                    _ => false,
                }
            },
        }
    }

    /// Parse a list of numbers surrounded by brackets and separated by commas
    /// List format: [Number, Number, Number]
    public fun parse_number_list(tokens: &mut vector<Token>): bool {
        // Require starting LeftBracket
        if (!consume_token(tokens, Token::LeftBracket)) {
            return false;
        };

        // At least one number expected, then zero or more: comma + number
        if (vector::is_empty(tokens)) {
            return false;
        };

        // Parse first number
        if (!match_number_token_and_consume(tokens)) {
            return false;
        };

        // Parse zero or more ", Number"
        loop {
            if (!vector::is_empty(tokens)) {
                if (consume_token(tokens, Token::Comma)) {
                    if (!match_number_token_and_consume(tokens)) {
                        return false;
                    };
                } else {
                    break;
                };
            } else {
                break;
            };
        };

        // Require ending RightBracket
        consume_token(tokens, Token::RightBracket)
    }

    /// Helper function to check if the next token is Number and consume it
    fun match_number_token_and_consume(tokens: &mut vector<Token>): bool {
        if (vector::is_empty(tokens)) {
            return false;
        };
        let first = *vector::borrow(tokens, 0);
        match first {
            Token::Number(_n) => {
                vector::remove(tokens, 0);
                true
            },
            _ => false,
        }
    }

    /// Function to detect invalid number literals outside u64
    /// Return true if number literal fits within 64 bits; false otherwise
    public fun validate_num_literal(num_str: vector<u8>): bool {
        // We simulate by attempting to parse to u64 via manual comparison
        // We only accept numeric ASCII (digits 0-9)
        let limit_str = b"18446744073709551615";
        let len_num = vector::length(&num_str);
        let len_limit = vector::length(&limit_str);

        if (len_num < len_limit) {
            return true;
        } else if (len_num > len_limit) {
            return false;
        } else {
            let i = 0;
            while(i < len_num) {
                let c1 = *vector::borrow(&num_str, i);
                let c2 = *vector::borrow(&limit_str, i);
                if (c1 < c2) {
                    return true;
                } else if (c1 > c2) {
                    return false;
                };
                i = i + 1;
            };
            // Equal strings
            true
        }
    }

    /// Runner that tests consuming tokens and parse_number_list
    public fun runner() {
        // Construct: [Number(1), Comma, Number(2), Comma, Number(3)]
        let tokens = vector[
            Token::LeftBracket,
            Token::Number(1),
            Token::Comma,
            Token::Number(2),
            Token::Comma,
            Token::Number(3),
            Token::RightBracket,
        ];
        let success = parse_number_list(&mut tokens);
        // after successful parse, tokens should be empty
        assert!(success, 1);
        assert!(vector::is_empty(&tokens), 2);

        // Test invalid parse - no closing bracket
        let tokens_no_end = vector[
            Token::LeftBracket,
            Token::Number(10),
            Token::Comma,
            Token::Number(20),
        ];
        let success2 = parse_number_list(&mut tokens_no_end);
        assert!(!success2, 3);

        // Test consume_token with expected mismatch
        let tokens_mismatch = vector[
            Token::LeftBracket,
            Token::Number(7),
            Token::RightBracket,
        ];
        let got_false = !consume_token(&mut tokens_mismatch, Token::Comma);
        assert!(got_false, 4);

        // Test validate_num_literal with valid number
        let valid_num = b"18446744073709551615";
        let res_valid = validate_num_literal(valid_num);
        assert!(res_valid, 5);

        // Test validate_num_literal with too large number
        let invalid_num = b"18446744073709551616";
        let res_invalid = validate_num_literal(invalid_num);
        assert!(!res_invalid, 6);

        // Test validate_num_literal with smaller number
        let smaller_num = b"1234567890";
        let res_smaller = validate_num_literal(smaller_num);
        assert!(res_smaller, 7);
    }
}


//# run 0xCAFE::TokenConsumption::runner


// Featurres:
// bef9dbef17a7b6cdbd55be5addf073bf: Leverage 'consume_token' to ensure that the next token in the token stream matches an expected token, facilitating correct parsing of Move source code.
// ed9c2f1bfc799d0f11d5ae37c6155865: Require specific starting and ending tokens to delimit lists.
// 8250fd61cad637f83ab612055c98c71a: Handle invalid number literals that are too large to fit into the specified type
