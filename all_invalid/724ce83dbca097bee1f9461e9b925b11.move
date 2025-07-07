//# publish
module 0x1::test_module {
    // Spec block with a function
    public fun spec_with_function() {
        // This is a placeholder for a spec block that could contain assertions or tests
    }

    // Log debug info with bytecode dump name derived from source filename
    public fun log_debug_dump() {
        // Debugging: Log source filename or bytecode info if debug enabled
        // (In actual test environment, this would trigger debug logs)
    }

    // Declare a literal address specifier with a byte sequence
    public fun declare_byte_seq() {
        let address: vector<u8> = vector::empty<u8>();
        // Push a byte value (e.g., 0x12) to the address vector
        vector::push_back(&mut address, 0x12u8);
        // Push another byte (e.g., 0x34)
        vector::push_back(&mut address, 0x34u8);
        // Example: create a literal address with the byte sequence
        let addr_literal: vector<u8> = address;
        // Use addr_literal in some way
        // (Placeholder: no operation)
    }

    // Create dereference and unary expressions with sub-expressions
    public fun deref_and_unary() {
        let value: u64 = 42;
        // Create an address (simulate pointer)
        let ptr: &u64 = &value;
        // Dereference the pointer
        let deref_value: u64 = *ptr;
        // Unary negation of the dereferenced value
        let neg_value: u64 = 0 - deref_value;
    }

    // Runner function to execute all above functions
    public fun run_all() {
        spec_with_function();
        log_debug_dump();
        declare_byte_seq();
        deref_and_unary();
    }
}

//# run 0x1::test_module::run_all