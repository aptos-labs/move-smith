//# publish
module 0xCAFE::NativeWithCustomGeneric {
    // A dummy native function declaration with a single type parameter T
    native fun native_identity<T>(x: T): T;

    // A public function that calls the native function
    public fun call_native_identity<T>(x: T): T {
        native_identity<T>(x)
    }

    // Runner function to call native_identity with u64 for testing (no args needed)
    public fun runner(_signer: &signer) {
        let _res = native_identity<u64>(42u64);
    }
}
//# run 0xCAFE::NativeWithCustomGeneric::runner --signers 0xCAFE

//# publish
module 0xCAFE::SpecInlineExpressions {
    // Define a public function; "spec" keyword cannot be used as an inline expression this way,
    // so remove the `spec is_even = ...` line and keep the function returning the bool directly.
    public fun even_check(x: u64): bool {
        (x % 2 == 0)
    }

    // Runner function to call even_check with a value
    public fun runner(_signer: &signer) {
        let _ = even_check(2u64);
        let _ = even_check(3u64);
    }
}
//# run 0xCAFE::SpecInlineExpressions::runner --signers 0xCAFE

//# publish
module 0xCAFE::TokenMatch {
    use std::vector;
    use std::signer;

    /// Represents a simple token enum type.
    /// The ability annotations should be declared with `abilities` keyword and 
    /// the abilities inside parentheses (not Rust-style attributes).
    public enum Token has copy, drop {
        A,
        B,
        C,
    }

    /// A struct representing a token stream state, holds tokens and current position.
    public struct TokenStream has copy, drop, store {
        tokens: vector<Token>,
        index: u64,
    }

    public fun create_token_stream(tokens: vector<Token>): TokenStream {
        TokenStream { tokens, index: 0 }
    }

    /// Advances the stream if current token matches `expected`.
    /// Returns true if matched (and advances), false otherwise (without advancing).
    public fun match_token(ts: &mut TokenStream, expected: Token): bool {
        if (ts.index >= vector::length(&ts.tokens)) {
            false
        } else {
            let current = *vector::borrow(&ts.tokens, ts.index);
            if (current == expected) {
                ts.index = ts.index + 1;
                true
            } else {
                false
            }
        }
    }

    /// Runner: test match_token with known tokens, advancing properly on match.
    public fun runner(_signer: &signer) {
        let tokens = vector::empty<Token>();
        let tokens = vector::push_back(tokens, Token::A);
        let tokens = vector::push_back(tokens, Token::B);
        let mut stream = create_token_stream(tokens);
        let res1 = match_token(&mut stream, Token::A);
        let res2 = match_token(&mut stream, Token::C);
        let res3 = match_token(&mut stream, Token::B);
        let _ = (res1, res2, res3);
    }
}
//# run 0xCAFE::TokenMatch::runner --signers 0xCAFE