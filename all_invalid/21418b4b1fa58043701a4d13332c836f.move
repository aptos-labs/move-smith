//# publish
module 0x1::test_module {
    /// Top-level spec block: a function with a spec.
    public fun spec_block_example() {
        // Example spec: no-op
    }

    /// Log debug info including bytecode dump name (simulated via emit! macro).
    public fun log_debug_info() {
        // Emulating debug info logging, in real code this might be via debug module.
        // Here, just a placeholder for the logic.
        // Note: In actual Move, logging is limited; for test purposes, assume debug macro.
        // Assume debug! macro is used (if enabled).
        debug!(b"Debug info: dump name = error_source_source_file.move");
    }

    /// Declare a literal address specifier with a byte sequence.
    public fun declare_address_specifier() {
        // Using a byte sequence to represent an address.
        let addr_bytes: vector<u8> = vector::empty<u8>();
        vector::push_back(&mut addr_bytes, 0x12);
        vector::push_back(&mut addr_bytes, 0x34);
        // Store or process the address as needed (here, just a placeholder).
    }

    /// Define an inline function.
    public inline fun inline_function() {
        // Inline function body.
    }

    /// Define a native function.
    native public fun native_function();

    /// A runner function to call other functions.
    public fun run_all() {
        spec_block_example();
        log_debug_info();
        declare_address_specifier();
        inline_function();
        native_function();
    }
}

//# run 0x1::test_module::run_all --signers 0x1

//# publish
module 0x2::nested_module {
    use 0x1::test_module;

    /// Define a native function, to be called from outside.
    native public fun native_in_nested();

    /// A function to call the native function.
    public fun call_native_in_nested() {
        native_in_nested();
    }
}

//# run 0x2::nested_module::call_native_in_nested --signers 0x2
