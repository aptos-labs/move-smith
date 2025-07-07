//# publish
module 0xA550C0DE::TestModule {

    // Top-level spec block as a resource
    resource struct Spec {
        name: vector<u8>,
        details: vector<u8>,
    }

    // Function to initialize spec resource
    public fun init_spec(account: &signer, name: vector<u8>, details: vector<u8>) {
        move_to(account, Spec { name, details });
    }
    
    // Function to log debug info with bytecode dump name
    public fun log_debug_info(source_file: &vector<u8>) {
        // Assuming debug logging is enabled in the environment
        // and that we can access a debug function (pseudo-code)
        debug::print_str(&vector::concat(&[b"Debug: Bytecode dump for ", source_file]));
    }

    // Function to declare a literal address specifier with byte sequence
    public fun declare_address_specifier(addr_bytes: vector<u8>): address {
        // Converts a byte vector into an address
        // In actual code, this might involve parsing or direct conversion
        // For testing, assume addr_bytes is always 16 bytes
        // (0x1234) is a placeholder for a specific address
        address_from_bytes(addr_bytes)
    }

    fun address_from_bytes(bytes: vector<u8>): address {
        // Placeholder for converting bytes to address
        // In real implementation, perform proper conversion
        // Here, for test, return a fixed address
        0x1234_5678_9ABC_DEF0_1234_5678_9ABC_DEF0
    }

    // Function to parse environment variables for features/flags
    public fun parse_env_flags(env_var: vector<u8>): vector<bool> {
        // Dummy parsing to simulate feature flags
        // For testing, return a fixed vector of flags
        vector::from_elem<bool>(3, true)
    }

    // Access nested modules and types via chain
    public fun access_nested_module(account: &signer) {
        // Example of accessing nested module and type
        let nested_module_ref = 0xA550C0DE::OuterModule::InnerModule;
        // Assuming some function in nested module
        nested_module_ref::target_function(account);
    }

    // Define a schema target with function members
    resource struct SchemaTarget {
        // Members organize functions
        members: vector<fun()>,
    }

    // Function member inside schema target
    public fun schema_function() {
        // grouped function for schema
        debug::print(&b"Schema function executed");
    }

    // Function to create and invoke schema target functions
    public fun run_schema() {
        let schema = SchemaTarget {
            members: vector::empty<fun()>(),
        };
        // Add function members
        // (In real code would be stored and invoked properly)
        // For test, just directly call
        schema_function();
    }
}

//# run
script {
    // Initialize debug logging with detailed info
    // Log the bytecode dump for source file "test_move_code.move"
    // This exercises debug info logging
    0xA550C0DE::TestModule::log_debug_info(b"test_move_code.move");
}

//# run 0xA550C0DE::TestModule::init_spec --signers 0x1 --args b"TopSpec" b"Details about spec"
//# run 0xA550C0DE::TestModule::declare_address_specifier --args b"\x12\x34\x56\x78\x9A\xBC\xDE\xF0\x12\x34\x56\x78\x9A\xBC\xDE\xF0"
//# run 0xA550C0DE::TestModule::access_nested_module --signers 0x1
// Call a nesting module function to test module and type resolution
// Use dummy signer 0x1 for the test
//# run 0xA550C0DE::TestModule::run_schema