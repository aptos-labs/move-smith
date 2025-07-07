// Transactional test script for Move compiler and VM
// Tests:
// 1. Using 'copy x' instead of 'copy(x)'
// 2. Using 'consume_token' to check tokens in the token stream
// 3. A function that returns 100 when a condition is true, regardless of else branch value

script {
    use std::debug;
    use std::vector;

    // A mock parser context and token stream for testing consume_token
    struct TokenStream has copy, drop {
        tokens: vector<u8>,
        cursor: u64,
    }

    // Initialize a token stream
    fun new_token_stream(tokens: vector<u8>): TokenStream {
        TokenStream { tokens, cursor: 0 }
    }

    // consume_token ensures the next token matches expected_token
    fun consume_token(stream: &mut TokenStream, expected_token: u8): bool acquires TokenStream {
        if (stream.cursor >= vector::length(&stream.tokens)) {
            return false;
        };
        let current = *vector::borrow(&stream.tokens, stream.cursor);
        // Move cursor forward if matched
        if (current == expected_token) {
            stream.cursor = stream.cursor + 1;
            true
        } else {
            false
        }
    }

    // Test function for copy expression with 'copy x' style instead of 'copy(x)'
    fun test_copy_style() acquires TokenStream {
        let x: u64 = 42;
        // Use 'copy x' instead of 'copy(x)'
        let val = copy x;
        debug::print(&vector::singleton(val));  // Should print 42
    }

    // Test function for consume_token
    fun test_consume_token() acquires TokenStream {
        // Tokens: [1, 2, 3]
        let mut stream = new_token_stream(vector::from_bytes(b"\x01\x02\x03"));

        // consume_token succeeds on 1
        let res1 = consume_token(&mut stream, 1);
        debug::print(&vector::singleton(if res1 { 1u8 } else { 0u8 })); // 1

        // consume_token fails on 4 (does not match 2)
        let res2 = consume_token(&mut stream, 4);
        debug::print(&vector::singleton(if res2 { 1u8 } else { 0u8 })); // 0

        // consume_token succeeds on 2 (because previous failed, cursor didn't advance; so for testing, advance manually)
        // To properly test, let's try consume_token(2) again
        let res3 = consume_token(&mut stream, 2);
        debug::print(&vector::singleton(if res3 { 1u8 } else { 0u8 })); // 1 or 0 based on cursor, test both cases

        // consume_token succeeds on 3
        let res4 = consume_token(&mut stream, 3);
        debug::print(&vector::singleton(if res4 { 1u8 } else { 0u8 })); // 1 or 0
    }

    // Test function that returns 100 when condition is true, regardless of else branch value
    fun test_return_100(cond: bool): u64 {
        if (cond) {
            // return 100 when condition is true
            100
        } else {
            // assign some other value but do NOT return it
            let _x = 999;
            // return 0 in else branch - the value is ignored, test verifies return 100 only when cond=true
            0
        }
    }

    fun main() {
        test_copy_style();

        test_consume_token();

        // Test return_100 with true: should return 100
        let r1 = test_return_100(true);
        debug::print(&vector::singleton(r1 as u8)); // 100 truncated to u8 is 100

        // Test return_100 with false: should return 0
        let r2 = test_return_100(false);
        debug::print(&vector::singleton(r2 as u8)); // expected output 0
    }
}

// Featurres:
// 770949bda97288c978694a33701f565c: Write 'copy x' instead of 'copy(x)' to perform a copy operation.
// bef9dbef17a7b6cdbd55be5addf073bf: Leverage 'consume_token' to ensure that the next token in the token stream matches an expected token, facilitating correct parsing of Move source code.
// a5d50289b47d654cefe150822aec7ef9: Test that the function returns 100 when the condition is true, regardless of the value assigned in the else branch.
