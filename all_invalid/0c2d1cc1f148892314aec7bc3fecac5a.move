// This test covers top-level spec blocks, debug logging, literal address specifiers,
// multiple entries overriding previous settings, and nested struct operations.

//# publish
module 0xA550::TestModule {

    use std::debug;
    use std::string;

    // Spec block to define configuration (simulate top-level spec)
    // Using a doc comment to represent a "spec" concept.
    /// # spec
    /// name: feature_test
    /// enabled: true

    // Another spec block that sets a different configuration, overriding the previous
    /// # spec
    /// name: feature_test
    /// enabled: false

    // Struct with nested fields to test nested struct updates
    struct Container {
        id: u64,
        data: vector<u8>,
        nested: Nested,
    }

    struct Nested {
        counter: u64,
        label: string::String,
    }

    // Function to log debug info, including source file info and settings
    public fun log_debug_info(msg: string::String) {
        // Log the message with debug info
        debug::print(&msg);
        // Additionally log source filename (simulate bytecode dump name)
        // Placeholder since direct filename isn't available; simulate with a filename string
        debug::print(&string::utf8(b"source_file.mv"));
    }

    // Function to perform manipulations and return a sum, simulating test logic
    public fun compute_sum(val1: u64, val2: u64): u64 {
        // Log initial values
        debug::print(&string::utf8(b"Initial val1: "));
        debug::print(&core::string::from_u64(val1));
        debug::print(&string::utf8(b"Initial val2: "));
        debug::print(&core::string::from_u64(val2));

        // Create nested struct
        let nested_instance = Nested {
            counter: val1 + 10,
            label: string::String::from_utf8(b"NestedLabel"),
        };

        // Create container with nested struct
        let container = Container {
            id: val2 + 20,
            data: vector::empty<u8>(),
            nested: nested_instance,
        };

        // Perform nested struct update and arithmetic
        let nested_updated = Nested {
            counter: container.nested.counter + 5,
            label: string::String::from_utf8(b"UpdatedLabel"),
        };

        // Log debug info about nested struct
        debug::print(&string::utf8(b"Nested counter: "));
        debug::print(&core::string::from_u64(nested_updated.counter));
        debug::print(&string::utf8(b"Nested label: "));
        debug::print(&nested_updated.label);

        // Compute sum including manipulations
        val1 + val2 + nested_updated.counter + 100
    }

    // Runner function to execute the test
    public fun run_test() {
        // Log debug info at the start
        log_debug_info(string::String::from_utf8(b"Starting test execution"));

        let result = compute_sum(42, 58);
        // Log the final result
        debug::print(&string::utf8(b"Final sum result: "));
        debug::print(&core::string::from_u64(result));
    }
}

//# run 0xA550::TestModule::run_test