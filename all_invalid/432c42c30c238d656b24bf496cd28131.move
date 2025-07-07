
//# publish
module 0xFEED::ErrorMessages {
    use std::error;

    public fun trigger_error_message(code: u64): u64 acquires std::error::Error {
        // simulate an error with a detailed message
        error!({status: code, message: "Explicit error with detailed info"})
    }
}


//# publish
module 0xFEED::InliningOptimization {
    use 0xFEED::ErrorMessages;

    public fun should_inline_func(a: u8): u8 {
        // Inline this simple function
        a + 10
    }

    public fun call_inline_with_args(b: u8): u8 {
        // Call the inline function directly
        should_inline_func(b)
    }

    public fun test_inlining_error() {
        // Intentionally trigger an error with detailed message
        let _ = ErrorMessages::trigger_error_message(12345);
        // Call inline function to test inline optimization
        let result = call_inline_with_args(5u8);
        assert!(result == 15, 1001);
    }
}


//# publish
module 0xFACE::InterfaceSegregation {
    // Define separate interface-like modules to test directory-based separation
    // Primary interface module
    public fun interface_func1() {
        // no implementation, just a placeholder
    };
}

// separate into subfolder 'utils' for extra modules
// (simulate directory structure conceptually)
// Assume additional modules can be created here if needed


//# run 0xFEED::ErrorMessages::trigger_error_message --args 999u64
//

//# run 0xFEED::InliningOptimization::test_inlining_error

// Featurres:
// 5096a1acafda75408ede7e73f6a2359f: Provide Detailed Error Messages Including Error Status and Location
// 4625b3aabf3f1e50655d70fe22b574f2: Use the inlining process to optimize code by replacing calls to inline functions with their bodies.
// f32cf2c83fbd98e1388ad2242cc99f3e: Separate interface files into directories based on namespace or hash
