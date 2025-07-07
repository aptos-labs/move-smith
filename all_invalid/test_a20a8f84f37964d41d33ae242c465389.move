//# publish
module 0x42::TestFeatures {
    use std::bcs;
    use std::string::{Self};
    use std::vector;

    // Utility function to simulate an error
    public fun error() acquires self {
        abort 42;
    }
    
    // Utility function to check if a string is valid UTF-8
    public fun is_valid_utf8(bytes: vector<u8>): bool {
        // Using the std::string::utf8 function to validate
        // Note: In Move, invalid UTF-8 strings will abort, but for this test, we assume conversion always valid
        let result = string::utf8(&bytes);
        // If utf8 returns successfully, it's valid
        true
    }
    
    // Function to serialize keys and values, converting keys to UTF-8 strings
    public entry fun init_serialization() {
        let keys: vector<vector<u8>> = vector[vector[1u8, 2, 3], vector[65, 66, 67]]; // includes ASCII and non-ASCII bytes
        let values: vector<u64> = vector[10, 20, 30];

        let utf8_strings = vector::map(&keys, |key| {
            // Convert bytes to UTF-8 string
            // If invalid, this will abort, so we assume validity here
            string::utf8(key)
        });

        let serialized_values = vector::map(&values, |v| {
            bcs::to_bytes<u64>(v)
        });
    }
}

//# run 0x42::TestFeatures::init_serialization