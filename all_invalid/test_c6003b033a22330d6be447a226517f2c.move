//# publish
module 0xA11C::test_module {
    use std::bcs;
    use std::string::{Self};
    use std::vector;

    // Test case: Initialize with empty key-value vectors, convert keys to UTF-8 strings,
    // and serialize values with BCS without errors.
    public entry fun init() {
        // Empty vector of vector<u8>
        let keys: vector<vector<u8>> = vector[];
        // Empty vector of u64
        let values: vector<u64> = vector[];
        // Map over keys to convert to strings
        let string_keys = vector::map(&keys, |k| { string::utf8(k) });
        // Serialize values
        let serialized_values = vector::map(&values, |v| { bcs::to_bytes<u64>(&v) });
        // For testing, ignore the output; just ensure no errors occur
        // Optional: store or log to verify if needed
    }

    // Additional helper function to process non-empty vectors for variety
    public entry fun process_non_empty() {
        let keys: vector<vector<u8>> = vector[
            b"hello",
            b"world",
            b"move"
        ];
        let values: vector<u64> = vector[1, 2, 3];

        // Convert keys to strings
        let string_keys = vector::map(&keys, |k| { string::utf8(k) });
        // Serialize values
        let serialized_values = vector::map(&values, |v| { bcs::to_bytes<u64>(&v) });
    }
}

//# run 0xA11C::test_module::init
