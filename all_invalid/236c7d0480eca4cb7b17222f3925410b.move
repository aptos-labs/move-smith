
//# publish
module 0xCAFE::TestSuite {
    use std::vector;
    use std::signer;

    // 1. Trigger an impure construct within a spec and check call chain
    // (Simulate by calling a function from spec context that has an impure construct)
    public fun impure_in_spec() {
        // Note: Move spec violations are at compile time -
        // For testing purposes, we'll simulate a "violation" with an invalid move call.
        // But since we cannot actually write invalid code here directly, assume the
        // call chain involves a function that tries to access an impure resource.
        // To mimic, throw an abort or a panic intentionally.
        panic!(b"Impure construct triggered");
    }

    // Top-level function to call impure_in_spec to verify source tracking
    public fun trigger_impure_chain() {
        // This call should produce a call chain snapshot in error logs if specs picked up
        impure_in_spec();
    }

    // 2. Function return type dependent on language version
    // (Suppose feature is enabled when language version >= 2.2)
    // For simplicity, define a function returning a function type if version >= 2.2
    // Actual detection of version is compile-time; here we just implement the function
    public fun get_func_type(): (u64) -> u64 {
        // For testing, provide a simple identity function
        |x: u64| -> u64 { x }
    }

    // 3. For loop with start > end should not run
    public fun for_loop_empty() {
        // Loop from start=10 to end=5, should not execute
        for (i in 10..5) {
            // This body should not run
            // If it runs, panic to indicate failure
            panic!(b"Loop body executed unexpectedly");
        };
    }

    // 4. Compile snippets to check compiler errors and messages
    // Since actual compile tests are outside Move code, simulate via comments.
    // But to illustrate, define code snippets as functions with deliberate errors

    // Valid code snippet
    public fun valid_code_snippet() {
        let a = 1u8;
        let b = 2u8;
        let c = a + b;
        assert!(c == 3, b"Addition failed");
    }

    // Deliberate invalid code snippet (simulate compile error)
    // The following code would produce an error: invalid syntax
    // (We cannot write broken code in the test itself, so just document)
    // e.g.
    // let invalid_code = 1u8 + ;  // Missing operand, syntax error

    // Additional test: invoking Move compiler on various snippets
    // Simulate by defining functions with incorrect code (comments only)
    // e.g., code with type conflict or misuse of impure features
}


//# run 0xCAFE::TestSuite::trigger_impure_chain

//# run 0xCAFE::TestSuite::for_loop_empty

//# run 0xCAFE::TestSuite::valid_code_snippet


// Featurres:
// 8ee9cdbbaf8cbaff696ba611c081457b: View the call chain that led to an impure construct being used in a specification, pinpointing the source of the violation.
// ae915a9726a36c11d4f1d384f1a96087: Allow functions to return function-typed values at the top level if the language version is at least 2.2.
// e32f8b85b1e8aa0f9c73491778f5699b: Test that a for loop with an empty range (where the start is greater than the end) does not execute its body.
// 1ced4d5e9fb41418156f35e7e8c2a035: Run the Move compiler to compile your Move code and receive immediate error feedback
