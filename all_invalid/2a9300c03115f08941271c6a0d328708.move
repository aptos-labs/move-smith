//# publish
module 0x1::TestModule {
    use std::signer;

    // Setup logging function for testing
    public fun setup_logging_for_testing() {
        // Dummy logging setup, in real scenario could configure logs
        // For the purpose of test, this can be a no-op
        // or print a message if needed
        // No actual log setup in Move
    }

    // Runner function to invoke setup_logging_for_testing
    public fun run_setup_logging() {
        Self::setup_logging_for_testing();
    }
}

//# run 0x1::TestModule::run_setup_logging

//# publish
module 0x2::AnonymousFunctions {
    // Function that accepts a lambda and calls it
    public fun call_lambda<F: copy + func()>(f: &F) {
        f();
    }

    // Function that returns an anonymous lambda which prints a message (simulate print with a comment)
    public fun get_anonymous_lambda(): &fun() {
        // Return a reference to an inline lambda function
        // In Move, function pointers can be used, but anonymous functions are limited.
        // To simulate, define a dummy function and pass its reference
        public fun lambda_function() {
            // simulate print
        }
        &lambda_function
    }

    // Runner to test defining and calling anonymous functions
    public fun run_anonymous_functions() {
        // Define an anonymous lambda as a local function
        let anon_lambda = &move || {
            // simulate logging
        };

        // Call the lambda via call_lambda
        Self::call_lambda(anon_lambda);
    }
}

//# run 0x2::AnonymousFunctions::run_anonymous_functions

//# publish
module 0x3::CyclicDependencyAvoidance {
    // This module depends only on std and other modules, not creating cycles
    // Define a simple utility function
    public fun helper_function() {
        // no-op
    }
}

//# run 0x3::CyclicDependencyAvoidance::helper_function