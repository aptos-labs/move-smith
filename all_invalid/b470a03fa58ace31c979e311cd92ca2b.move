//# publish
module 0xCAFE::TokenModule {
    use std::option;
    use std::option::Option;

    struct Token has copy, drop, store, key {
        id: u64,
    }

    /// Creates a token with the given id.
    public fun create_token(id: u64): Token {
        Token { id }
    }

    /// A function that consumes an optional token if it matches the expected id.
    /// Returns whether the token was consumed (true) or not (false).
    public fun consume_optional_token_if_match(opt_token: &mut Option<Token>, expected_id: u64): bool {
        // Borrow the option for read & write
        let token_opt = *opt_token;

        // Match on the option
        if (option::is_some(&token_opt)) {
            // `option::borrow(&token_opt)` returns &Token, use copy on * to copy Token
            let token = copy *option::borrow(&token_opt);
            if (token.id == expected_id) {
                // If id matches, consume the token by setting option to none
                *opt_token = option::none<Token>();
                true
            } else {
                false
            }
        } else {
            false
        }
    }

    /// Runner function that demonstrates creation and consumption of tokens with references and explicit type annotations.
    public fun runner(): bool {
        let mut maybe_token: Option<Token> = option::some(Token { id: 42u64 });

        let consumed: bool = consume_optional_token_if_match(&mut maybe_token, 42u64);

        // Further use: Try to consume again, should be false as token was already consumed
        let consumed_again: bool = consume_optional_token_if_match(&mut maybe_token, 42u64);

        consumed && (!consumed_again)
    }
}
//# run 0xCAFE::TokenModule::runner

//# run
script {
    use std::option;
    use 0xCAFE::TokenModule;

    fun main() {
        // Create an optional token with id 100u64
        let mut token_opt: option::Option<TokenModule::Token> = option::some(TokenModule::Token { id: 100u64 });

        // Use explicit type annotation for bool
        let consumed: bool = TokenModule::consume_optional_token_if_match(&mut token_opt, 50u64);
        // This should be false, since id 100 != 50
        // Next try with correct id
        let consumed_correct: bool = TokenModule::consume_optional_token_if_match(&mut token_opt, 100u64);

        // After consumption, token_opt should be none
        let still_some: bool = option::is_some(&token_opt);

        // We expect: consumed == false, consumed_correct == true, still_some == false
        // No assertions needed per instructions, just let these values be computed
        let _: bool = consumed; 
        let _: bool = consumed_correct;
        let _: bool = still_some;
    }
}