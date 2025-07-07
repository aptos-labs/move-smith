
//# publish
module 0xDEAD::TestNegativeAbort {
    use std::signer;

    // Function to test abort with an unsigned underflow (simulate "negative" abort)
    public fun test_abort_negative(a: u64) {
        // Intentionally abort with a value that underflows
        let result = if (a == 0) {
            abort 1;
        } else {
            // When a > 0, subtract 1 to simulate negative in signed context, but unsigned wraps around
            let _ = a - 1;
        };
        result
    }

    // Function with custom token type
    struct Token has copy, store, drop {
        id: u64,
        name: vector<u8>
    }

    // Function to create and match tokens
    public fun create_token(id: u64, name: vector<u8>): Token {
        Token { id, name }
    }

    // Recognize and process token during parsing (simulate a match scenario)
    public fun match_token(token: &Token): u8 {
        if (token.id == 42) {
            1
        } else if (vector::length(&token.name) > 0) {
            2
        } else {
            3
        }
    }

    // Function to set warning environment variable for deprecated API detection
    public fun check_deprecated_warning(env_var: u64) {
        if (env_var != 0) {
            // Simulate issuing a warning (no actual warning mechanism in Move, just a comment)
            // Assume compiler logs warning when env var is set
            // e.g., set env: DEPRECATED_API_WARN=1
        };
    }

    // Function to demonstrate deprecated API usage (simulate warning)
    public fun use_deprecated_api() {
        // Call deprecated API (simulated)
        // e.g., let _ = std::old_api::deprecated_function();
        // Should trigger warning if environment is set
    }
}

// Run the test for abort with negative value (unsigned underflow)


//# run 0xDEAD::TestNegativeAbort::test_abort_negative --args 0u64

// Run the token creation and matching


//# run 0xDEAD::TestNegativeAbort::create_token --args 42u64 "TokenName"


//# run 0xDEAD::TestNegativeAbort::match_token --args 0xDEAD::TestNegativeAbort::create_token --type-args () --signers 0x1 --args 0 --args 0 --args 0

// Set environment variable for warning - assume the test environment sets env var accordingly


//# run 0xDEAD::TestNegativeAbort::check_deprecated_warning --args 1u64

// Use deprecated API to check warning trigger


//# run 0xDEAD::TestNegativeAbort::use_deprecated_api
