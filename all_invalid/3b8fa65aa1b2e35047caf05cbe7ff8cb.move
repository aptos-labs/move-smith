//# publish
module 0xA55A::TestFeatureModule {
    use std::debug;
    use std::address;

    // Top-level spec block, representing a custom data structure or spec
    public fun feature_spec(name: vector<u8>) {
        debug::print(&name);
    }

    // Function to log detailed debug info with bytecode dump name
    public fun log_debug_info(source_file: vector<u8>) {
        // Assuming the source file name is derived from the source file name (simulate)
        debug::print(&source_file);
        debug::print(&b"Debug info dump"_);
    }

    // Function to demonstrate literal address specifier
    public fun address_specifier() {
        let addr: address = address::from_bytes(b"\x12\x34");
        debug::print(&addr);
    }

    // Function to declare and use constant within the module
    public fun use_constant() {
        const MY_CONST: u64 = 12345;
        debug::print(&MY_CONST);
    }

    // Runner function for this module
    public fun run_module() {
        feature_spec(b"TopLevelSpec");
        log_debug_info(b"source_file.move");
        address_specifier();
        use_constant();
    }
}

//# run 0xA55A::TestFeatureModule::run_module

//# publish
module 0xA55A::Main {
    use 0xA55A::TestFeatureModule;

    // Top-level spec block for main module
    public fun main_spec() {
        // Call runner in imported module
        TestFeatureModule::run_module();
    }

    // Function to test inclusion of spec blocks, logging, address literals, and constants
    public fun execute_tests() {
        main_spec();
    }

    // Runner function for the main module
    public fun run() {
        execute_tests();
    }
}

//# run 0xA55A::Main::run