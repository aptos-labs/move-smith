//# publish
module 0xCAFE::NativeWithCustomGeneric {
    use std::signer;
    use std::vector;

    // A dummy native function declaration with a single type parameter T
    native fun native_identity<T>(x: T): T;

    // A public function that calls the native function
    public fun call_native_identity<T>(x: T): T {
        native_identity<T>(x)
    }

    // Runner function to call native_identity with u64 for testing (no args needed)
    public fun runner() {
        let _res = native_identity<u64>(42u64);
    }
}
//# run 0xCAFE::NativeWithCustomGeneric::runner --signers 0xCAFE

//# publish
module 0xCAFE::SpecInlineExpressions {
    use std::vector;

    // Define a public function with an inline spec expression
    public fun even_check(x: u64): bool {
        // Inline spec expression (not in a spec block or context)
        spec is_even = (x % 2 == 0);

        // Return the result based on the spec expression defined in the function
        (x % 2 == 0)
    }

    // Runner function to call even_check with a value
    public fun runner() {
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
    /// The ability annotations allow copy and drop so boolean returns are clean.
    #[copy, drop]
    public enum Token {
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
    public fun runner() {
        let tokens = vector::empty<Token>();
        let tokens = vector::push_back(tokens, Token::A);
        let tokens = vector::push_back(tokens, Token::B);
        let mut stream = create_token_stream(tokens);
        let res1 = match_token(&mut stream, Token::A);
        let res2 = match_token(&mut stream, Token::C);
        let res3 = match_token(&mut stream, Token::B);
        // res1 should be true (matched A)
        // res2 should be false (expected C but got B)
        // res3 should be true (matched B after skipping the C fail)
        let _ = (res1, res2, res3);
    }
}
//# run 0xCAFE::TokenMatch::runner --signers 0xCAFE

// Featurres:
// 3ce7f9ec7dcf0f463d7ee246609ec231: Define named native functions with custom type parameters for generics.
// cd052ff7525df75a003fb0f4dba9a498: Write in-line specification expressions via the `spec` keyword, but not inside specification contexts (outer `spec` blocks only).
// 7c982b714106aa6537da23a750293a54: Return true if the current token matches the specified token; otherwise, return false without advancing.
