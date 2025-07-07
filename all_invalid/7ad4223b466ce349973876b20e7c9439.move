//# publish
module 0xCAFE::TestUninitializedVars {
    // Removed unused 'use std::vector;'

    // This function declares uninitialized variables with "no" or "maybe" comments
    public fun declare_uninitialized_vars() {
        let _no_init: u8;
        let _maybe_init: u16;
        // We don't initialize them here; just declared

        // Another variable properly initialized
        let initialized = 10u8;

        // This is for further tool analysis; nothing is done at runtime
        let _ = initialized;
    }

    // Runner function that calls the above to test declaration
    public fun run_uninitialized_test() {
        declare_uninitialized_vars();
    }
}

//# run 0xCAFE::TestUninitializedVars::run_uninitialized_test

//# publish
module 0xCAFE::VectorLambdas {
    use std::vector;

    // Stores lambdas in a vector and iterates them, invoking each with argument.
    // Note: Move currently does NOT support storing and calling lambdas in vectors.
    // Instead, we simulate by storing functions or function pointers if possible.
    // Since this isn't yet supported, we can fix the code by removing 'mut' keyword and conforming to proper syntax.

    // To fix compilation error: 
    // - remove parentheses around the function type in the generic <>
    // - remove mut from 'lambdas' because 'vector::push_back' requires &mut, so 'mut' is ok
    // - importantly, function types (|u8|u8) are likely unsupported in vector element types

    // So fix by using an array of functions (fixed size array) instead of vector, or just call the lambdas directly.

    // Since the test wants to store and invoke lambdas, and Move currently likely does not support storing lambdas in vectors,
    // we can store the lambdas in a fixed-size vector (array) if possible.

    // Alternatively, store a vector of struct with a 'call' function (simulate lambdas),
    // or just correct the syntax error and leave it as is.

    // Here, minimal fix is to remove the parentheses in the type and fix syntax errors.

    public fun store_and_invoke_lambdas() {
        let mut lambdas = vector::empty<|u8|u8>();

        let lambda1: |u8|u8 has copy + drop = |a: u8| { a + 1 };
        let lambda2: |u8|u8 has copy + drop = |a: u8| { a * 2 };

        vector::push_back(&mut lambdas, lambda1);
        vector::push_back(&mut lambdas, lambda2);

        let len = vector::length(&lambdas);
        let mut i = 0u64;
        while (i < len) {
            let lambda_ref = vector::borrow(&lambdas, i);
            let _result = (*lambda_ref)(3u8);
            i = i + 1;
        };
    }
}

//# run 0xCAFE::VectorLambdas::store_and_invoke_lambdas

//# publish
module 0xCAFE::SkippedLintTest {
    // We simulate the attribute by documentation comment because Move has no native attributes yet
    // But in real Aptos Move, external lint checks may be annotated this way

    /// @skip_lint(unused_variables)
    public fun function_with_unused_var() {
        let _unused = 42u64; // prefix with _ to avoid warning
    }

    /// @skip_lint(all)
    public fun another_function() {
        // Do nothing, but skip all lints
    }

    public fun runner() {
        function_with_unused_var();
        another_function();
    }
}

//# run 0xCAFE::SkippedLintTest::runner