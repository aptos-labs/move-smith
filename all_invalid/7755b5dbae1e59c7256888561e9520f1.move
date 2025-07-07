//# publish
module 0x1::DebugModule {
    // Function to print debug info, including bytecode dump names.
    public fun debug_log(name: vector<u8>) {
        // This is a placeholder for logging; in real tests, you could use Debug::print or similar.
        // For testing, this function can be a no-op or log to the console if supported.
        // Assume Debug::print is available:
        // Debug::print(&name);
        // For demonstration, we leave it empty.
    }
}

//# publish
module 0x2::SpecTest {
    use 0x1::DebugModule;

    // Spec block that can include functions and nested structures
    public fun top_level_spec() {
        // Log initialization
        DebugModule::debug_log(b"Top-level spec start");
        // Invoke nested spec
        nested_spec();
        DebugModule::debug_log(b"Top-level spec end");
    }

    // Nested spec as a function
    public fun nested_spec() {
        DebugModule::debug_log(b"Nested spec start");
        // Declare a literal address specifier with a byte sequence
        let addr_specifier = (0x1234u16);
        // Log the byte sequence name derived from source
        DebugModule::debug_log(b"bytecode_dump_name: nested_spec.move");
        // Call a runner to finalize or simulate further behavior
        // (In real tests, more complex behavior could be added here)
        DebugModule::debug_log(b"Nested spec end");
    }

    // Runner function to execute spec block
    public fun run_spec() {
        top_level_spec();
    }
}

 //# run 0x2::SpecTest::run_spec --signers 0x0