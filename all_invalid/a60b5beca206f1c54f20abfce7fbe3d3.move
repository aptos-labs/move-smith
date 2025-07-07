//# publish
module 0x1::LoopTest {
    // Runner function that uses a while loop to count from 0 to 5 and asserts the count
    public fun run_while_loop(): bool {
        let mut count = 0;
        while (count < 5) {
            count = count + 1;
        };
        // Assert count is 5
        assert!(count == 5, 1);
        true
    }
}

//# run 0x1::LoopTest::run_while_loop

//# publish
module 0x1::TokenParser {
    use std::signer;

    /// Returns true if current token matches the specified token,
    /// otherwise returns false without advancing.
    public fun token_matches(current_token: u8, expected_token: u8): bool {
        if (current_token == expected_token) {
            true
        } else {
            false
        }
    }

    /// Consumes a specific token during parsing.
    /// The "parser" token is passed in and must match the expected token to be consumed.
    public fun consume_token(current_token: u8, expected_token: u8): bool {
        assert!(current_token == expected_token, 1);
        // here consuming token means just verifying match and returning true
        true
    }

    /// Runner function that tests token_matches and consume_token
    public fun run_parser_tests(): bool {
        // Test token_matches with match
        let matched = token_matches(10, 10);
        assert!(matched == true, 2);

        // Test token_matches with no match
        let not_matched = token_matches(10, 5);
        assert!(not_matched == false, 3);

        // Test consume_token success
        let consumed = consume_token(7, 7);
        assert!(consumed == true, 4);

        true
    }
}

//# run 0x1::TokenParser::run_parser_tests