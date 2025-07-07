//# publish
module 0x1::source_location_test {
    use std::error;
    use std::vector;

    // Struct to hold source location info
    struct SourceLocation has copy, drop, store {
        file_name: vector<u8>,
        line_number: u64,
        column_number: u64,
    }

    // Function to simulate retrieval of error source location
    public fun get_source_location_for_error(error_code: u64): Option<SourceLocation> {
        // For testing purposes, return a dummy source location for a specific error code
        if (error_code == 42) {
            SourceLocation {
                file_name: vector::empty<u8>(),
                line_number: 42,
                column_number: 7,
            }
            // wrap in Some
            return Option::some<SourceLocation>(move SourceLocation {
                file_name: vector::empty(),
                line_number: 42,
                column_number: 7,
            });
        }
        // For other errors, no source location available
        Option::none<SourceLocation>()
    }

    // Runner function to trigger an error intentionally to test source location retrieval
    public fun run_source_location_test() {
        // Intentionally cause an error with code 42
        let _error_code = 42;
        // Simulate error handling that would retrieve source location
        let source_loc_opt = get_source_location_for_error(_error_code);
        // The actual retrieval and logging is simulated here
        // (In real tests, this part would interact with VM error handling)
    }
}

//# run 0x1::source_location_test::run_source_location_test --signers 0x1

//# publish
module 0x1::script_contexts {
    use std::error;
    use std::vector;
    use 0x1::source_location_test;

    // Structured context for script processing
    public fun script_context_flow() {
        // Begin context (could include setup, validation, etc.)
        // Here, we simply call the test function
        source_location_test::run_source_location_test();
        // End context
    }
}

//# run 0x1::script_contexts::script_context_flow --signers 0x1

//# publish
module 0x1::dependency_management {
    use std::vector;
    
    /// Simulates the removal of intersecting dependency files if sources are allowed to shadow dependencies.
    /// Note: Move does not have a native file dependency management, so this is conceptual.
    public fun remove_shadows_in_dependencies(dependencies: vector<vector<u8>>, allowed_shadows: bool) {
        // Placeholder logic to demonstrate the idea
        if (allowed_shadows) {
            let _ = vector::filter(&mut dependencies, |dep| {
                // Dummy predicate: remove dependencies that intersect with some criteria
                true // No actual filtering since Move doesn't support file system operations
            });
        }
        // Otherwise, do nothing
    }
}

//# run 0x1::dependency_management::remove_shadows_in_dependencies --args  vec::<vector<u8>>{b"dep1", b"dep2"} true --signers 0x1