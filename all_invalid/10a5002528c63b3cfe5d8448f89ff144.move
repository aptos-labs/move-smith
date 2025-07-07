//# publish
module 0xAABBCC::TestModule {
    use std::debug;
    use std::signer;
    use std::vector;

    // Spec block: Top-level spec
    public fun top_level_spec() {
        // No-op: placeholder for top-level spec
    }

    // Function to log debug info with detailed bytecode dump name
    public fun log_debug_info(source_name: vector<u8>) {
        // Enable debug logging
        debug::print(&source_name);
    }

    // Example of a declared address specifier with literal byte sequence
    // (0x1234) as an address
    fun get_literal_address(): address {
        address (0x1234)
    }

    // Struct with type parameters
    struct MyStruct<T, U> {
        field1: T,
        field2: U,
    }

    // Function to create an instance of MyStruct
    public fun create_struct<T, U>(val1: T, val2: U): MyStruct<T, U> {
        // Move values into the struct
        let s = MyStruct { field1: move(val1), field2: move(val2) };
        s
    }

    // Runner function to execute multiple tests
    public fun run_tests() {
        // Log debug info with a name derived from source file (simulate)
        log_debug_info(b"source_move_test.move");
        
        // Declare a literal address specifier
        let addr = get_literal_address();

        // Declare variables
        let val_u8: u8 = 42;
        let val_u64: u64 = 9000;

        // Copy and move expressions
        let copy_u8 = val_u8; // Copy
        let move_u8 = move(val_u8); // Move from val_u8; val_u8 now invalid (compile-time)

        // Since using move, reinitialize val_u8
        let val_u8 = 42;

        // Create a struct instance with type parameters
        let my_struct = create_struct<u8, u64>(move(val_u8), move(val_u64));

        // Additional debug print
        debug::print(&b"Struct created successfully"[..]);
    }
}

// //# run 0xAABBCC::TestModule::run_tests