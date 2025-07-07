//# publish
module 0x1::TopLevelSpec {
    // Top-level spec block simulating a module or other spec definitions
    public fun top_level_spec() {
        // No implementation needed for this test
    }
}

//# run 0x1::TopLevelSpec::top_level_spec

//# publish
module 0x2::DebugLogging {
    use std::debug;

    // Function to log detailed debug information including bytecode dump names
    public fun log_debug_information(source_file: vector<u8>) {
        // Log the source file name (simulate bytecode dump name)
        debug::println(&string::utf8(&source_file));
        // Additional detailed debug info could be added here
    }
}

//# run 0x2::DebugLogging::log_debug_information --args "bytecode_dump_name.move"

//# publish
module 0x3::LiteralAddressSpec {
    // Declare a literal address specifier with a byte sequence
    public fun use_literal_address() {
        let addr: address = address { bytes: vector[0x12, 0x34, 0x56, 0x78] };
        debug::print(&addr);
    }
}

//# run 0x3::LiteralAddressSpec::use_literal_address

//# publish
module 0x4::InlineFunctionTest {
    // Attempt to define an inline function should be disallowed or tested
    // Note: Move does not support inline functions explicitly, so here we simulate the test
    // that no inline functions are present in scripts
    public fun caller() {
        // Call to an internal function
        inline_function();
    }

    fun inline_function() {
        // inline functions are not permitted; this is a placeholder
        debug::print(&"This is an inline function");
    }
}

//# run 0x4::InlineFunctionTest::caller

//# publish
module 0x5::VisibilityModifiers {
    // Functions with different visibility modifiers to control accessibility

    // Public function - accessible outside the module
    public fun public_func() {
        debug::print(&"Public function accessible");
    }

    // Friend function - accessible within the module and friend modules
    Friend fun friend_func() {
        debug::print(&"Friend function accessible");
    }

    // Private function - only accessible within this module
    private fun private_func() {
        debug::print(&"Private function");
    }

    // Runner function that tries to call all above
    public fun run_all() {
        public_func();
        friend_func();
        private_func();
    }
}

//# run 0x5::VisibilityModifiers::run_all

//# publish
module 0x6::DependencySharingTest {
    use 0x7::DependencyModule;

    // Test function to ensure same path sharing detection
    public fun test_shared_paths() {
        // Attempts to run dependency functions
        DependencyModule::some_function();

        // Simulate dependency file sharing detection
        // (In practice, the build system detects shared paths)
    }
}

//# run 0x6::DependencySharingTest::test_shared_paths

//# publish
module 0x7::DependencyModule {
    public fun some_function() {
        debug::print(&"Dependency module function called");
    }
}

//# run 0x7::DependencyModule::some_function