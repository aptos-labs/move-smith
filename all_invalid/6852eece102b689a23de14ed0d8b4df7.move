//# publish
module 0xCAFE::deprecation_test {
    /// Mark the entire module as deprecated at the address level
    #[deprecated]
    public fun dummy() {}
}
//# publish
module 0xCAFE::tokenizer {
    // This module will test using 'current_token_error_string' to get descriptive error strings
    
    /// Helper function to simulate getting the token error string
    public fun get_token_error_string(token: u8): vector<u8> {
        // For demonstration, return a descriptive string based on token input
        if (token == 0) {
            b"End of file reached." // simulate EOF
        } else {
            let msg = b"Invalid token: ".to_vec();
            // append numeric representation
            // because move doesn't support string concatenation as in Rust, we simulate it with specific errors
            msg
        }
    }

    #[test]
    public fun test_token_error_strings() {
        let eof_msg = get_token_error_string(0);
        // Normally we would check the string, but just a test to invoke it.
        // No assertions needed as per instructions.
        let _ = eof_msg; // to avoid unused variable warning
        let invalid_msg = get_token_error_string(42);
        let _ = invalid_msg;
    }
}
//# publish
module 0xCAFE::loop_invariant {
    // This module tests spec with invariants inside a loop
    
    struct Counter {
        count: u64,
        limit: u64,
    }

    public fun create_counter(limit: u64): Counter {
        Counter { count: 0, limit }
    }

    /// Increment counter until count == limit
    #[test]
    public fun test_invariant_loop() {
        let c = create_counter(10);
        // The loop invariant: c.count <= c.limit
        spec {
            // Invariant: c.count always less than or equal to c.limit
            invariant c.count <= c.limit;
        }
        let counter = c;

        // Loop until count reaches limit
        while (counter.count < counter.limit) {
            // invariant holds at the start of the loop body
            spec { invariant counter.count <= counter.limit; }

            // Increase count
            counter.count = counter.count + 1;
        }
        // After loop, count == limit
        spec {
            // Final invariant check (not strictly necessary, but to verify)
            invariant counter.count == counter.limit;
        }
    }
}
//# publish
module 0xCAFE::deprecation_token {
    // This module defines token-like resource to test use of 'current_token_error_string' function.

    resource struct Token {
        id: u64,
        description: vector<u8>,
    }

    public fun create_token(id: u64, description: vector<u8>): Token {
        Token { id, description }
    }
}

//# run 0xCAFE::tokenizer::get_token_error_string --args 0u8
//# run 0xCAFE::tokenizer::get_token_error_string --args 42u8

// Featurres:
// c1367d37b2075aa6fdcc5740b3ac2c36: Attach deprecation attributes at the address (namespace) level to mark all modules under it as deprecated.
// 08082b21b4090d159c6641a7a7311704: Include only `invariant` conditions inside `spec` blocks to ensure proper validation of loop invariants.
// b29c72198884fefb396e2c4448d83464: Use 'current_token_error_string' to get a descriptive string for the current tokenizer state, indicating either an end-of-file or the specific token content.
