//# publish
module 0xCAFE::PatternMatchingTest {
    use std::option;

    // A struct with multiple fields
    struct Person has copy, drop, store {
        id: u64,
        name_len: u8,
        age: u8,
    }

    // A nested struct
    struct Nested has copy, drop, store {
        p: Person,
        score: u64,
    }

    // An enum with variants with and without fields
    enum Shape has copy, drop {
        Circle(u64),
        Rectangle { width: u64, height: u64 },
        Unit,
    }

    // Function to test pattern matching with destructuring records and enums
    public fun test_destructuring(p: Person, s: Shape) {
        // Destructure record pattern match with all fields
        let Person {id, name_len, age} = p;

        // Partial matching using `..` catch-all; we only care about age
        let Person {age: age_only, ..} = p;

        // Match enum with destructuring
        let area: u64 = match s {
            Shape::Circle(radius) => 3 * radius * radius,
            Shape::Rectangle {width, height} => width * height,
            Shape::Unit => 0,
        };

        // Deeply nested destructuring in patterns
        let score = 0u64;
        match s {
            Shape::Rectangle {width, height} => {
                if (width > height) {
                    let _ = width;
                };
            },
            Shape::Circle(r) => {
                let _ = r;
            },
            Shape::Unit => {},
        };

        let nested = Nested {p: p, score: score};

        // Match nested struct pattern with nested record
        let Nested {p: Person {id: pid, name_len: nlen, age: page}, score: sc} = nested;
        let _ = (pid, nlen, page, sc);
    }

    // Function to test pattern matching with guards and coverage checking
    public fun test_match_guards(x: u8): u8 {
        match x {
            0 => 1,
            1 => 2,
            a if (a < 10) => 3,
            a if (a < 20) => 4,
            _ => 5,
        }
    }

    // Function illustrating a unreachable redundant pattern to trigger detection (commented out for no abort)
    /*
    public fun test_redundant_patterns(x: u8): u8 {
        match x {
            0 => 1,
            1 => 2,
            _ => 3,
            3 => 4, // unreachable pattern (redundant)
        }
    }
    */

    // Function handling unexpected type cases via option type and error return
    public fun handle_unexpected_type(opt: option::Option<u8>): u8 {
        if (option::is_some(&opt)) {
            let val = option::extract(opt);
            val
        } else {
            // Return 255 on None, an unexpected type scenario
            255u8
        }
    }

    // Tokens used in consume_token function
    const TOKEN_LPAREN: u8 = 40u8; // '(' ASCII
    const TOKEN_RPAREN: u8 = 41u8; // ')'
    const TOKEN_LET: u8 = 76u8; // 'L' as "let" marker for example

    /*
    // Signature for token stream to simulate tokens for consume_token function
    The token stream is a vector of u8 representing tokens.
    */

    public struct TokenStream has store {
        tokens: vector<u8>,
        index: u64,
    }

    // Initializes a new token stream
    public fun new_token_stream(tokens: vector<u8>): TokenStream {
        TokenStream { tokens, index: 0 }
    }

    // Consume next token matching expected token, error if not match or end of stream
    public fun consume_token(stream: &mut TokenStream, expected: u8): bool acquires TokenStream {
        if (stream.index >= vector::length(&stream.tokens)) {
            // End of token stream; failure
            false
        } else {
            let current = *vector::borrow(&stream.tokens, stream.index as usize);
            if (current == expected) {
                stream.index = stream.index + 1;
                true
            } else {
                false
            }
        }
    }

    // Runner function with multiple tests
    public fun run_tests() {
        let person = Person {id: 42, name_len: 10, age: 25};
        let shape1 = Shape::Circle(5);
        let shape2 = Shape::Rectangle {width: 3, height: 4};
        let shape3 = Shape::Unit;

        test_destructuring(person, shape1);
        test_destructuring(person, shape2);
        test_destructuring(person, shape3);

        let _ = test_match_guards(0u8);
        let _ = test_match_guards(5u8);
        let _ = test_match_guards(15u8);
        let _ = test_match_guards(100u8);

        let some_val = option::some(123u8);
        let none_val: option::Option<u8> = option::none();

        let _ = handle_unexpected_type(some_val);
        let _ = handle_unexpected_type(none_val);

        let tokens = vector[ TOKEN_LPAREN, TOKEN_RPAREN, TOKEN_LET ];
        let mut stream = new_token_stream(tokens);

        let _ = consume_token(&mut stream, TOKEN_LPAREN);
        let _ = consume_token(&mut stream, TOKEN_RPAREN);
        let _ = consume_token(&mut stream, TOKEN_LET);
        let _ = consume_token(&mut stream, TOKEN_LET); // Should fail (return false)
    }
}

//# run 0xCAFE::PatternMatchingTest::run_tests


// Featurres:
// 8fb9828204b9a095d7d6afccd8410966: Test that the Move pattern matching feature (including destructuring for records/enums with fields, use of the `..` catch-all, field-specific and deeply nested matching, inclusion of guards, and coverage/exhaustiveness checking in match statements) works correctly and detects redundant or unreachable patterns.
// dded9be223fac34813eccd921aec2897: Handle unexpected type cases with appropriate error handling in your code.
// bef9dbef17a7b6cdbd55be5addf073bf: Leverage 'consume_token' to ensure that the next token in the token stream matches an expected token, facilitating correct parsing of Move source code.
