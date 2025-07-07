//# publish
module 0x1::DebugTest {

    use std::debug;

    /// Function to log debug info, including filename derived from source
    public fun log_debug_info(filename: &vector<u8>) {
        debug::publish_debug_message(&b"Debug info for file: "_ + filename);
        // Note: In real testing, the compiler should produce bytecode that dumps source-related info
        // Here, we simulate by printing filename.
    }

    /// Run this function to check debug info logging
    public fun run_debug_logging() {
        // Simulate source filename
        let filename = b"test_file.move";
        log_debug_info(&filename);
    }
}

//# run 0x1::DebugTest::run_debug_logging --signers 0x1

//# publish
module 0x2::control_flow_module {
    //! Module specifically designed to contain control flow constructs for testing

    /// Detect if an expression contains control flow (loops, returns, aborts)
    /// Since Move doesn't have reflection, we simulate detection by code structure.
    /// The following functions are designed to contain control flow for testing.

    // Function containing a loop
    public fun contains_loop() {
        let count = 0;
        while count < 3 {
            // ... do something
            // For testing, just increment
            let _ = count;
            // simulate increment
            // note: Move loops must modify variables, but for this test, we mark as control flow
        }
    }

    // Function with early return
    public fun contains_return(flag: bool): bool {
        if flag {
            return true; // testing return detection
        }
        return false;
    }

    // Function with abort (simulate redirection/termination)
    public fun contains_abort() {
        abort 0;
    }

    /// Runner function to invoke all control flow tests
    public fun run_control_flow_tests() {
        contains_loop();
        let res = contains_return(true);
        debug::print(&b"Return result: "_, &res);
        // Call abort function to test redirection
        contains_abort();
    }
}

//# run 0x2::control_flow_module::run_control_flow_tests --signers 0x2

//# publish
module 0x3::_illegal_naming {
    // Module name starting with underscore, should be disallowed by naming conventions

    // Dummy function
    public fun dummy() {}
}

//# publish
module 0x4::LiteralAddressTest {
    /// Declare a literal address specifier with a byte sequence
    /// For testing, interpret (0x1234) as bytes
    public fun address_literal_example() {
        // Simulate the address bytes; Move supports hex address literals but for test
        let addr_bytes: vector<u8> = vector[0x12, 0x34];
        debug::print(&b"Literal address bytes: "_, &addr_bytes);
    }

    /// Runner
    public fun run_literal_address() {
        address_literal_example();
    }
}

//# run 0x4::LiteralAddressTest::run_literal_address --signers 0x4

//# publish
module 0x5::NamingConventionsTest {
    // Enforce naming; module name does not start with '_'
    // (In actual compiler tests, names starting with '_' should be disallowed)
    // Here, just a placeholder for such logic.
    public fun run_naming_convention_check() {
        // No runtime code; the test is in compile time based on name
    }
}

// No run command for naming convention test, as it's compile-time check