
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


//# run 0xCAFE::StringLength::string_length --args "b\"hello\\nworld\""





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
        test_dead_code()
    }
}


//# run 0xCAFE::DeadCodeTest::run_test


// Featurres:
// 0cd736f620b0c78ec962304f1ef2d84e: Use this function to determine the length of a string literal excluding escape characters.
// e51a13f151c79b9b3b0d4ad12d73a0c0: Test that dead code in the else branch after a conditional with a loop and break does not affect execution or cause errors.
// d43b5a0d688d38535489b7863763334a: Include Move specifications (spec blocks) in modules.
