
//# publish
module 0xBADD::FilterTest {

    // Module with multiple spec blocks, some associated with filtered members,
    // to verify only specified blocks are executed during testing.
//# publish
    module 0xBADD::FilteredMembersModule {
        // Active spec block (expected to run)
        spec {
            // Link to member 'active_func'
            // Only this spec block should execute when filtered
        }
        public fun active_func() {
            // Function body
        }
        // Filtered-out spec block (should be excluded in filtered test)
        spec {
            // Link to 'excluded_func'
        }
        public fun excluded_func() {
            // Function body
        }
    }

    // Another module with filtered spec blocks based on member inclusion
//# publish
    module 0xBADD::AnotherFiltered {
        spec {
            // Link only to 'main_special'
        }
        public fun main_special() {
            // Function body
        }
        spec {
            // Link to 'not_included_func'
        }
        public fun not_included_func() {
            // Function body
        }
    }

    // Script with various main function decorators and modifiers
    // to test execution influence
    
//# run 0xBADD::ComplexMainModifiers::entry_point --signers 0xDEAF

    
//# run 0xBADD::ComplexMainModifiers::custom_modifier --signers 0xDEAF

    
//# publish
    module 0xBADD::ComplexMainModifiers {
        // Decorator similar to // entry]
        // entry]
        public fun entry_point() {
            // Should execute normally
        }

        // Custom modifier influencing execution flow
        // For the purposes of this test, simulate a modifier effect
        public fun custom_modifier() {
            // Simulate a modifier behavior
            // e.g., setting a flag or altering state
        }
    }

    // Diagnostic testing: define functions that trigger varying severity diagnostics
    
//# publish
    module 0xBADD::DiagnosticsModule {
        // Generate a warning-level diagnostic (e.g., deprecated feature)
        public fun trigger_warning() {
            // Simulate warning
            // (No actual warning API, so just a placeholder comment)
            // Warning: deprecated usage
        }

        // Generate an error-level diagnostic
        public fun trigger_error() {
            // Simulate error
            // (No actual error API, placeholder comment)
            // Error: invalid token
        }

        // Generate a critical severity diagnostic (e.g., unsupported feature)
        public fun trigger_critical() {
            // Simulate critical error
            // (No actual error API, placeholder comment)
            // Critical: unsupported feature
        }
    }

    // Main script to orchestrate tests, including invocation of functions 
    // that trigger diagnostics and invoking modules with spec filters
    
//# run 0xBADD::MainTest::run_all_tests

    
//# publish
    module 0xBADD::MainTest {
        // Main function that calls filtered functions and diagnostics
        public fun run_all_tests() {
            // Call functions in filtered modules
            0xBADD::FilteredMembersModule::active_func();
            0xBADD::AnotherFiltered::main_special();

            // Functions that trigger diagnostics
            0xBADD::DiagnosticsModule::trigger_warning();
            0xBADD::DiagnosticsModule::trigger_error();
            0xBADD::DiagnosticsModule::trigger_critical();
        }
        
        // Additional functions with decorators/modifiers for testing
        // entry]
        public fun main_entry() {
            // Execute main logic
            // Invocations should trigger spec execution based on filter
            // and diagnostics
        }

        public fun main_with_modifier() {
            // Simulate a custom modifier affecting flow
        }
    }


// Featurres:
// 944c71e0a34ef5d7ebaf41b064209326: Exclude spec blocks associated with filtered-out members from the module.
// 7a46afc1aced5a83668e96b321e86c3c: Define the main function of the script with modifiers
// f48f01c31a1fbec319be6b03a383a9bf: Trigger compiler exit on diagnostics with severity higher than Warning.
