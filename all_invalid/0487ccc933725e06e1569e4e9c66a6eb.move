//# publish
module 0x1::TestModule {
    // Public resource and functions for testing
    resource struct DataHolder {
        value: u64,
    }

    // Function that processes conditionally based on access
    public fun process_data(is_public: bool, data_value: u64): bool {
        if (is_public) {
            // Public process
            true
        } else {
            // Private process
            false
        }
    }

    // Function demonstrating address condition
    public fun process_address(addr: address): bool {
        if (addr == @0x1) {
            true
        } else {
            false
        }
    }

    // Function using pattern matching with '..' to destructure
    public fun match_range(value: u64) : bool {
        match value {
            0..=10 => true,
            11..=20 => true,
            _ => false,
        }
    }

    // Function that utilizes module identifiers with different access types
    public fun test_module_access(): bool {
        // Accessing a public function within the same module
        process_data(true, 42) && process_address(@0x1) && match_range(5)
    }
}

//# run 0x1::TestModule::test_module_access --signers 0x1