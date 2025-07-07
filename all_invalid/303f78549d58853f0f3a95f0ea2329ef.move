//# publish
module 0x1::TestModule {
    // Function to test cross-module access restriction
    public fun call_other_module() {
        // Attempt to call a function from another address (should fail if cross-account access is restricted)
        // This is a placeholder; actual test will be in transactional script
    }

    // Function with various type union and pipe syntax
    public fun test_type_union_and_pipe<T>() {
        // placeholder
    }

    // Function that can be used as a runner
    public fun run_tests() {
        // placeholder for internal test runner
    }
}

//# publish
module 0x2::HelperModule {
    public fun helper_function() {
        // dummy helper function
    }

    // Function to demonstrate error reporting for syntax errors in list
    public fun process_list(items: vector<u8>) {
        // placeholder
    }
}

//# run
script {
    // 1. Test cross-module access: attempt to call 0x2::HelperModule::helper_function from 0x1::TestModule (should fail)
    // Since cross-address calls are generally not permitted or require specific permissions, simulate by directly calling
    // but for test purposes, the compiler should flag an error if cross-module access is invalid.
    // Here, just document the intention.
}

//# run 0x1::TestModule::run_tests
// Inside the module, define the function to perform internal tests
//# run 0x1::TestModule::run_tests

// The detailed transactional script to test all features:

//# run
transaction {
    // 1. Cross-module call attempt - should trigger compiler error if cross-module calls are restricted
    // (simulate by calling a function not exported or invalid access)
    // Since Move enforces module boundaries, direct cross-module calls that are invalid will produce compile errors.
    // For testing, we attempt to call a module's function that should be inaccessible or simulate an invalid call.
    
    // Attempt to invoke helper_function from another module improperly (should produce an error)
    // Correct usage would be 0x2::HelperModule::helper_function(), but for test, purposely misuse
    // e.g., calling via an invalid address or method.
    // Note: in a real test, attempting to call cross module functions with wrong address or signature would produce errors.
}'
 
// 2. Type union and pipe syntax testing
//# run
transaction {
    // We define a dummy function call that exercises type union syntax with '|' and '||'
    // Example: passing union type as argument
    let value_1 = 10u8;
    let value_2 = 20u64;

    // Call test_type_union_and_pipe with union types
    // Assuming the function is designed to accept types with union syntax, simulate the call
    // For example, passing a value that can be u8 or u64 using union syntax
    // Note: This is more for testing syntax; actual implementation depends on the function details
    // The function is just a placeholder in the module
    // (In practice, we'd pass a union type; here, just calling with different types)
    // as move does not have union types, this is placeholder syntax for test
}

// 3. Error reporting with invalid list syntax
//# run
transaction {
    // Attempt to call process_list with a malformed list to produce syntax error
    // For example, missing comma or invalid token in list
    // e.g., passing list with unexpected token (simulate invalid syntax)
    
    // Invalid list syntax: missing comma
    // process_list(vec![1 2, 3]) -- missing comma between 1 and 2
    // This should trigger a syntax error or detailed compile error
}

// 4. Enforce minimum Move version
//# run
transaction {
    // Include a move_stdlib version check (simulate minimum version requirement)
    // Move does not have direct version check at runtime, but can simulate with compiler directives
    // For the test, we attempt to compile with an older version, expecting an error message
    // Alternatively, include a dummy version check
}

// 5. List syntax error: unexpected tokens
//# run
transaction {
    // Example: passing an unexpected token in list
    // e.g., vec![1, 2,, 3] -- double comma
    // Or misformatted list: vec![1, 2, "unexpected"]
    // The Move compiler should report syntax error with details
}

// 6. Parsing lambda variable bindings
//# run
transaction {
    // Test variable bindings in lambda parameters with list of typed variables
    // For example, define a lambda with list of bindings like: | (x: u8, y: u64) | ...
    // Move's current syntax may not support lambdas like this directly, but assume testing the syntax
    // Or parse variable bindings within transaction script
    let lambda_func = |(x: u8, y: u64)| {
        // dummy
        x as u64 + y
    };
    // Call lambda to ensure parsing succeeded
    let result = lambda_func( (5u8, 10u64) );
}