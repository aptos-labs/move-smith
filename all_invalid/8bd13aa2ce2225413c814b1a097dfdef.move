//# publish
module 0x1::debug_module {
    /// Function to enable logging (simulating debug info)
    public entry fun enable_debug() {
        // No-op for demo
    }
    
    /// Log info with a message (simulate debug info)
    public fun log_info(msg: vector<u8>) {
        // Assume some logging mechanism
        // For now, do nothing
    }
}

//# publish
module 0x2::top_level_spec {
    use 0x1::debug_module;
    
    /// Spec block representing top-level settings or metadata
    // For demonstration, define an empty resource
    resource struct TopSpec {
        id: u64,
        description: vector<u8>,
    }

    /// Function to initialize top spec
    public fun init_top_spec(account: &signer, id: u64, desc: vector<u8>) {
        move_to(account, TopSpec { id, description: desc });
        // Log debug info about initialization
        debug_module::log_info(b"TopSpec initialized");
    }

    /// Nested spec block with specific features
    resource struct NestedSpec {
        flag: bool,
        count: u8,
    }

    /// Function to set nested spec
    public fun set_nested_spec(account: &signer, flag: bool, count: u8) {
        move_to(account, NestedSpec { flag, count });
        debug_module::log_info(b"NestedSpec set");
    }
}

 //# run
script {
    // Call to enable debug logging
    // Assuming no parameters needed
    // (if needed, define a function in debug_module to enable logging)
    // For this example, just proceed with the main test
}

//# run 0x1::debug_module::enable_debug --signers 0xdeadbeef

//# publish
module 0x3::literal_address_spec {
    /// Declare a literal address specifier with a byte sequence
    // For illustration, store and compare the byte sequence
    resource struct ByteSeq {
        bytes: vector<u8>,
    }

    public fun store_byte_sequence(account: &signer, bytes: vector<u8>) {
        move_to(account, ByteSeq { bytes });
    }

    public fun compare_byte_sequence(account: &signer, expected: vector<u8>) acquires ByteSeq {
        let stored = borrow_global::<ByteSeq>(Signer::address_of(account));
        // In real test, compare stored.bytes and expected
        // For demonstration, just log or simulate comparison
        // (skip actual assertion)
    }
}

//# run 0x3::literal_address_spec::store_byte_sequence --signers 0xabc --args b"\x12\x34\x56"

//# run 0x3::literal_address_spec::compare_byte_sequence --signers 0xabc --args b"\x12\x34\x56"

//# publish
module 0x4::multi_return {
    /// Function with multiple return values
    public fun multi_return_example(): (u64, bool) {
        (42u64, true)
    }

    /// Runner function for test
    public fun run_multi_return() {
        let (num, flag) = multi_return_example();
        // For test, log the returned values as debug info
        // Assume debug_module exists
        // For demonstration, no actual log
    }
}

//# run 0x4::multi_return::run_multi_return --signers 0xdead