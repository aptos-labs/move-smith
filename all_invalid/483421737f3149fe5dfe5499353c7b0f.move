//# publish
module 0x1::TestModule {
    use std::debug;
    use std::vector;

    // Spec block with top-level functions to define behavior
    // (In Move, simulate spec blocks with functions)
    public fun spec_function() {
        debug::print("[Spec]: Top-level spec function invoked");
    }

    // Function to log detailed debug info with bytecode dump name
    public fun log_debug(name: &str) {
        debug::print(&name);
    }

    // Declare a literal address specifier with byte sequence (0x1234)
    /// Byte sequence representing the address (0x1234)
    const BYTE_SEQ: vector<u8> = vector::empty<u8>();

    // Function to initialize BYTE_SEQ with specific bytes
    public fun init_byte_seq() {
        vector::push_back(&mut BYTE_SEQ, 0x12);
        vector::push_back(&mut BYTE_SEQ, 0x34);
    }

    // Function to demonstrate pattern matching with bindings and condition
    public fun pattern_match_example(value: u64): u8 {
        match value {
            0 => 0,
            v if v > 10 => 1,
            v => {
                debug::print(&("Matched value: ".to_owned() + &v.to_string()));
                2
            }
        }
    }

    // Struct with type parameter
    struct Container<T> {
        field: T,
    }

    // Function that creates a Container with a generic type
    public fun create_container<T>(value: T): Container<T> {
        debug::print("Creating container");
        Container { field: value }
    }

    // Function that demonstrates detailed debug info: dump names
    public fun dump_name(name: &str) {
        // Simulate bytecode dump name printed for debugging
        debug::print(&format!("bytecode_dump_{}.mv", name));
    }

    // Runner function to test all features together
    public fun run_all_tests() {
        // Log top-level spec
        spec_function();

        // Log debug info with bytecode dump name
        dump_name("test_source");

        // Initialize byte sequence
        init_byte_seq();

        // Log the byte sequence
        debug::print(&format!("Byte sequence: {:?}", &BYTE_SEQ));

        // Test pattern matching
        let match_result1 = pattern_match_example(0);
        debug::print(&format!("Match result for 0: {}", match_result1));

        let match_result2 = pattern_match_example(20);
        debug::print(&format!("Match result for 20: {}", match_result2));

        let match_result3 = pattern_match_example(5);
        debug::print(&format!("Match result for 5: {}", match_result3));

        // Test creating a container with u64
        let container_u64 = create_container(42u64);
        debug::print(&format!("Container field: {}", container_u64.field));
    }
}

//# run
// Call the runner function to execute all tests
//# run 0x1::TestModule::run_all_tests