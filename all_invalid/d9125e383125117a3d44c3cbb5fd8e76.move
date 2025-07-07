//# publish
module 0xCAFE::FeatureTest {
    use std::vector;
    use std::string;

    // 1. Verify parser handles decimal literals with underscores, ensuring correctness
    public fun test_decimal_literals() {
        let _valid1 = 1_234u64; // underscores should be ignored
        let _valid2 = 12_34u64;
        // The line with double underscores is invalid syntax and should be removed or corrected
        // let _invalid = 12__34u64; // invalid in Move, so commented out
        let _valid3 = 0u64;
        let _valid4 = 999_999_999u64;
        // Just assigning to test parser; in real compile time, invalid literals are rejected
        // For testing, we assume generator ignores underscores
        // No runtime assertion needed
    }

    // 2. Set up logging based on environment variables
    // This code is conceptual; environment variables and file logging handling are outside Move,
    // but simulate ability to handle env variable values
    public fun log_setup(env_log_path: vector<u8>) {
        // Suppose env_log_path is a variable read from environment, passed to this function
        // For demonstration, pretend to log different behaviors based on env variable
        if (vector::length(&env_log_path) > 0) {
            // Log to the specified file path (simulation)
            // Since Move cannot access file system directly, just simulate the selection
            // No actual file I/O, just a placeholder comment
        } else {
            // Default log handling
        };
    }

    // 3. Validate address assignment strings, parsing strings with exactly one '='
    public fun parse_address_string(address_str: vector<u8>) {
        let len = vector::length(&address_str);
        let eq_count: u8 = 0; // need to initialize mut variable
        let i: u64 = 0; // index as u64 for iteration (size_t compatible)
        while (i < len) {
            if (vector::borrow(&address_str, i) == b'=' ) {
                eq_count = eq_count + 1;
            }
            i = i + 1;
        }
        // Check for exactly one '='
        if (eq_count != 1) {
            // Invalid address string, would reject during compilation or raise error
        } else {
            // Parse the address string accordingly
            // For simulation, do nothing
        };
    }

    // 4. Annotate structs with different abilities and verify correctness
    struct CopyDropStruct has copy, drop {
        a: u8,
        b: bool,
    }

    struct StoreKeyStruct has store, key {
        key1: address,
        key2: u64,
    }

    public fun verify_struct_abilities() {
        let copy_drop = CopyDropStruct { a: 1u8, b: true };
        // copy drop struct supports copy
        let copy_clone = copy copy_drop;
        // verify clone (if needed)
        let store_key = StoreKeyStruct { key1: @0xCAFE, key2: 12345 };
        // store key supports storing in global storage
    }

    // 5. Variable shadowing in if-else branches
    public fun variable_shadowing(flag: bool): u8 {
        let x = 10u8;
        if (flag) {
            let x = 20u8; // shadows outer x
            // inner x used only inside this block
        } else {
            let x = 30u8; // shadows outer x
            // inner x used only inside this block
        };
        // The outer x remains unchanged; return it to verify no conflicts
        x
    }

    // Additional function to run all tests
    public fun run_all_tests() {
        // Call the functions to exercise scenarios
        test_decimal_literals();
        let env_path: vector<u8> = b"/var/log/app.log";
        log_setup(env_path);
        parse_address_string(b"0xCAF=deadbeef");
        parse_address_string(b"bad=address=string"); // invalid count, should be rejected logically
        verify_struct_abilities();
        let shadowed_value_1 = variable_shadowing(true);
        let shadowed_value_2 = variable_shadowing(false);
        // Use shadowed_value_* for assertions if needed
        // For now, just run; assertions are not included as per instructions
    }
}
