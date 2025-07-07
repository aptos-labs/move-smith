//# publish
module 0xDEADBEEF::TestModule {
    /// Top-level spec block that defines some functions and resources
    // Spec for resource that will be tested
    resource struct TestResource {
        value: u64,
    }

    public fun initialize_resource(account: &signer, initial_value: u64) {
        move_to(account, TestResource { value: initial_value });
    }

    // Function that logs debug info about bytecode name derived from source file
    public fun log_debug_info() {
        // This is a placeholder for debug logic; in actual test, this can invoke debug logging
        // For simulation: print debug info
        // (In actual test framework, you might have an intrinsic or an environment call here)
        // Example: debug!( "Bytecode dump for source file: test_script.move" );
    }

    // Function that logs detailed info including bytecode dump names
    public fun log_bytecode_name() {
        // Log the source file name or bytecode info
        // For the purpose of this test, just a placeholder
        debug!( "Debug: Bytecode dump name derived from source: test_script.move" );
    }

    // Runner function to execute all the above functions
    public fun run_all() {
        log_debug_info();
        log_bytecode_name();
    }

    /// Documentation comment for the resource
    /// This resource is used to test resource modification and logging
    resource struct DocumentedResource {
        data: vector<u8>,
    }

    /// Run a function to modify the DocumentedResource
    public fun modify_resource(account: &signer, new_data: vector<u8>) {
        if (exists<DocumentedResource>(@0x1)) {
            let resource_ref = borrow_global_mut<DocumentedResource>(@0x1);
            resource_ref.data = new_data;
        }
    }
}

//# run 0xDEADBEEF::TestModule::run_all

/// Script to test various features including resource declaration, debugging, and specification
/// This script initializes resources, logs info, and modifies resources

//# run
script {
    use 0xDEADBEEF::TestModule;

    fun main(account: &signer) {
        // Initialize resource with a literal address specifier using byte sequence
        // (0x1234) as a literal address
        let addr: address = address { bytes: 0x1234 };
        // Note: In Move, addresses are fixed, but for test, treat as literal specifier

        // Initialize a resource for the account
        TestModule.initialize_resource(account, 42);

        // Log debug info including bytecode dump name
        TestModule.log_bytecode_name();

        // Modify a resource with new data
        TestModule.modify_resource(account, b"test data".to_vec());

        // Run the combined runner to execute debug functions
        TestModule.run_all();
    }
}