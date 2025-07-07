//# publish
module 0xCAFE::TokenProcessor {
    use std::signer;
    use std::vector::{push_back, length, empty};
    use std::string::{utf8, String};

    public struct TokenStream has store {
        tokens: vector<u8>,
        pos: u64,
    }

    public fun new(tokens: vector<u8>): TokenStream {
        TokenStream { tokens, pos: 0 }
    }

    // Return true if current token matches `token` without advancing position, else false
    public fun peek_token(token_stream: &TokenStream, token: u8): bool {
        let tokens = &token_stream.tokens;
        if length(tokens) > token_stream.pos {
            let current = *vector::borrow(tokens, token_stream.pos as u64);
            current == token
        } else {
            false
        }
    }

    // Consume token if it matches, return (true, TokenStream) else (false, original TokenStream)
    public fun consume_token(mut token_stream: TokenStream, token: u8): (bool, TokenStream) {
        if peek_token(&token_stream, token) {
            let new_pos = token_stream.pos + 1;
            let new_stream = TokenStream { tokens: token_stream.tokens, pos: new_pos };
            (true, new_stream)
        } else {
            (false, token_stream)
        }
    }

    // Block expression that sequences multiple expressions and returns true if any token is 42u8 ('*')
    public fun sequence_and_check_star(token_stream: TokenStream): bool {
        {
            let (found_star, ts1) = consume_token(token_stream, 42u8);
            if (found_star) {
                true
            } else {
                let (found_plus, ts2) = consume_token(ts1, 43u8);
                if (found_plus) {
                    {
                        let (found_star_again, _ts3) = consume_token(ts2, 42u8);
                        found_star_again
                    }
                } else {
                    false
                };
            };
        }
    }

    // Runner function for testing: create tokens and test peek_token and sequence_and_check_star
    public fun runner() {
        let tokens = vector[10u8, 42u8, 43u8, 42u8, 99u8];
        let ts = new(tokens);

        let p1 = peek_token(&ts, 10u8);
        let p2 = peek_token(&ts, 42u8);

        let res = sequence_and_check_star(ts);

        // Just consume to avoid unused variable warnings
        let _ = (p1, p2, res);
    }
}

//# run 0xCAFE::TokenProcessor::runner

// Featurres:
// 263616b9c4308e5aaf87b451b8c5f099: Combine importing a module and specific members in 'use' statements.
// 59a0654b9ff419f728f6feae26386fa8: Create block expressions that sequence multiple expressions.
// 7c982b714106aa6537da23a750293a54: Return true if the current token matches the specified token; otherwise, return false without advancing.
