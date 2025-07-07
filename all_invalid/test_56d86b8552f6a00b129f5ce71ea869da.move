//# publish
module 0x1::test_module {
    use std::bcs;
    use std::string::{Self};
    use std::vector;

    // Empty vectors for both keys and values
    const EMPTY_KEYS: vector<vector<u8>> = vector[];
    const EMPTY_STRINGS: vector<string> = vector[];
    const EMPTY_BCS_BYTES: vector<vector<u8>> = vector[];

    // A runner function to test init with empty vectors
    public entry fun run_init() {
        // Convert empty key vectors to UTF-8 strings
        let result_strings = vector::map(&EMPTY_KEYS, |key| { string::utf8(key) });
        // Convert empty values to BCS bytes
        let result_bcs = vector::map(&EMPTY_STRINGS, |s| { bcs::to_bytes<string>(&s) });

        // Convert empty vectors of BCS bytes
        let _ = vector::map(&EMPTY_BCS_BYTES, |bytes| { 
            // Attempt to deserialize back to string (should be empty)
            // Since no assertion is needed, just perform conversions
            // Placeholder: no operation here
        });
    }
}

//# run 0x1::test_module::run_init