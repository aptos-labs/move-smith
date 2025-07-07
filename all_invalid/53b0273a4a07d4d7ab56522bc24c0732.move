
//# publish
module 0xCAFE::StringLength {
    use std::vector;

    // Function to determine length of string literal excluding escape characters
    public fun string_length(s: vector<u8>): u64 {
        let length: u64 = 0;
        let index: u64 = 0;
        let len = vector::length(&s);
        while (index < len) {
            // Check if current byte is escape character (e.g., b'\\' -> 92)
            if (vector::borrow(&s, index) == 92u8) {
                // Skip the next character as it is escape sequence
                index = index + 2;
            } else {
                index = index + 1;
                length = length + 1;
            }
        };
        length
    }
}


//# run 0xCAFE::StringLength::string_length --args ["b\"hello\\nworld\""]

// Note: We changed the --args argument to pass a JSON array of strings, which is supported by Move CLI.
// The string argument is now: ["b\"hello\\nworld\""]
// If the CLI expects a plain string, remove the quotes and pass as a string literal.
// But to avoid parsing issues with escape characters, passing as JSON array helps.



//# publish
module 0xCAFE::DeadCodeTest {
    spec {
        module: {
            name: "0xCAFE::DeadCodeTest",
            description: "Test module for dead code and specification",
        }
        functions: {
            pub fun test_dead_code() {
                // This test includes dead code after a conditional with a break.
                let result: u64 = 0;
                let condition = true;
                loop {
                    if (condition) {
                        result = 42;
                        break;
                    } else {
                        // Dead code that should not affect execution
                        result = 0;
                    }
                };
                result
            }
        }
    }

    // Runner function to invoke the test
    public fun run_test() {
        Self::test_dead_code()
    }
}


//# run 0xCAFE::DeadCodeTest::run_test