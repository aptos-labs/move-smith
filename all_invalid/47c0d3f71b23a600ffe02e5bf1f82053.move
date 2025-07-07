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
            // Append the token number by converting to a vector of u8
            // Since Move doesn't support string concatenation, simulate with a fixed message
            // Alternatively, just return the fixed invalid message
            msg
        }
    }

    #[test]
    public fun test_token_error_strings() {
        let eof_msg = get_token_error_string(0);
        // No assertions needed as per instructions
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
            // Invariant: c.count <= c.limit
            invariant c.count <= c.limit;
        }
        let mut counter = c;

        // Loop until count reaches limit
        while (counter.count < counter.limit) {
            // invariant holds at the start of the loop body
            spec { invariant counter.count <= counter.limit; }

            // Increase count
            counter.count = counter.count + 1;
        }
        // After loop, count == limit
        spec {
            // Final invariant check
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