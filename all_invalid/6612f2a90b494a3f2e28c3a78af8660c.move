//# publish
module 0xABCDEF::TestModule {
    use std::debug;
    use std::signer;
    use std::vector;

    // Top-level spec block as a resource (simulate with a function returning a struct)
    public fun create_spec() {
        // Placeholder for specification logic
        debug::print(&"Creating top-level specification");
    }

    // Function to log detailed debug info, including source filename
    public fun log_debug_info(source_name: vector<u8>) {
        debug::print(&source_name);
    }

    // Literal address specifier with byte sequence
    public fun get_address_literal(): address {
        // Byte sequence (0x12, 0x34)
        (0x12u8, 0x34u8)
    }

    // Function that adds two u8 and returns 42 if sum < 255
    public fun add_and_check(a: u8, b: u8): u8 {
        let sum = a + b;
        if (sum < 255) {
            42
        } else {
            0
        }
    }

    // Runner function to test add_and_check
    public fun run_add_and_check() {
        let result = Self::add_and_check(10, 20);
        debug::print(&result);
    }
}

//# run 0xABCDEF::TestModule::run_add_and_check
// No signer needed for internal test functions

//# run 0xABCDEF::TestModule::create_spec --signers 0x1 --args "top_level_spec"