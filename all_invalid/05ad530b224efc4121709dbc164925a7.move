//# publish
module 0xCAFE::TokenTest {
    use std::signer;
    use std::vector;

    /// Public function that returns a static u64 value
    public fun get_static_value(): u64 {
        42
    }

    /// Friend function visible to friend modules (in this case self only for demonstration)
    friend fun friend_increment(val: u64): u64 {
        val + 1
    }

    /// Function that uses a built-in Move function `vector::length`
    public fun vector_length(v: vector<u8>): u64 {
        vector::length(&v)
    }

    /// Function that verifies if the next byte in the vector matches the expected byte.
    /// Returns true if match otherwise abort.
    /// We simulate "token" verification by expecting a token byte.
    public fun verify_next_token(tokens: &vector<u8>, idx: u64, expected: u8): bool acquires signer {
        let len = vector::length(tokens);
        assert!(idx < len, 1);
        let tok = *vector::borrow(tokens, idx);
        if (tok == expected) {
            true
        } else {
            // abort with error if next token does not match expected
            abort 42;
        }
    }

    /// Runner function to exercise all above public and friend functions
    public fun runner() {
        let v = vector::empty<u8>();
        let v = vector::push_back(v, 0x10);
        let len = vector_length(v);
        assert!(len == 1, 2);
        let val = get_static_value();
        let incremented = friend_increment(val);
        assert!(incremented == 43, 3);

        // verify token with correct expected token (should succeed)
        let tokens = vector::push_back(vector::empty<u8>(), 0x10);
        let _ = verify_next_token(&tokens, 0, 0x10);

        // If uncommented, this would abort:
        // let _ = verify_next_token(&tokens, 0, 0x20);
    }
}
//# run 0xCAFE::TokenTest::runner

//# run
script 0xCAFE::ScriptTest {
    use 0xCAFE::TokenTest;
    use std::vector;

    fun main() {
        // Call get_static_value public function
        let val: u64 = TokenTest::get_static_value();
        assert!(val == 42, 10);

        // Call friend_increment via a script (not possible because friend, commented out)
        // let inc = TokenTest::friend_increment(val); // friend function not visible outside module so compile error

        // Prepare vector of tokens and check vector_length built-in usage
        let mut tokens = vector::empty<u8>();
        tokens = vector::push_back(tokens, 0xAA);
        tokens = vector::push_back(tokens, 0xBB);
        let length = TokenTest::vector_length(tokens);
        assert!(length == 2, 11);

        // Verify next token matches expected (first token is 0xAA)
        let is_match = TokenTest::verify_next_token(&tokens, 0, 0xAA);
        assert!(is_match, 12);

        // Try with wrong expected token => commented out to avoid abort
        // let fail = TokenTest::verify_next_token(&tokens, 1, 0xAA);
    }
}

// Featurres:
// 56fc777be547f1e9a24bebd1c4d82575: Include externally visible functions marked as `public` or `friend` in the module output.
// 963722aa5004492ad0f4ff6e2a8d272a: Call built-in functions using their predefined names in Move code
// 55af3530873ace811d033ac6e8aa6034: Verify that the next token matches an expected token
