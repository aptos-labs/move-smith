// This transactional test exercises:
// 1: Skip lint checks
// 2: Function types with '|' notation
// 3: Deprecated module usage diagnostic

// Using 0xCAFE as the test address

//# publish
module 0xCAFE::LintSkippedModule {
    // Removed unused 'use std::signer;' to silence unused alias warning
    
    // Skip a lint check on the whole function
    #[lint::skip(unused_variables)]
    public fun lint_skipped_function(_unused: u64) {
        // some unused variables which normally triggers lints
        let _x = 42u64;
        let _y = 24u64;
    }

    // Test function type with | notation: function param is u64, returns u64
    public fun apply_function(f: |u64| u64, x: u64): u64 {
        f(x)
    }

    // A simple function we will use as function param
    public fun double(x: u64): u64 {
        x * 2
    }

    // To test deprecated module usage, simulate by calling deprecated module in Move std
    // Aptos std has deprecated some modules like 'aptos_framework::coin'
    // We'll simulate deprecated function usage via an explicit call annotated as deprecated.
    // For demonstration, we'll create a deprecated module and call it here.

    // Run a runner function that invokes all above
    public fun runner() {
        lint_skipped_function(1);
        let doubled = apply_function(double, 21);
        // Use unused doubled to avoid unused variable lint
        let _ = doubled;
        
        deprecated::use_me();
    }
}

//# publish
#[deprecated]
module 0xCAFE::deprecated {
    public fun use_me() {
        // empty function to represent deprecated usage
    }
}

//# run 0xCAFE::LintSkippedModule::runner --signers 0xCAFE

//# run
script {
    use 0xCAFE::LintSkippedModule;

    fun main() {
        // Run the runner function from the module
        LintSkippedModule::runner();
    }
}