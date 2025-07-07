//# publish
module 0xCAFE::TestUninitializedVars {
    use std::vector;

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

    // Defines the function type alias (u8) -> u8 for clarity
    // (Move does not support type aliases but this comment clarifies the intent)

    // Stores lambdas in a vector and iterates them, invoking each with argument
    public fun store_and_invoke_lambdas() {
        // Create vector to store lambdas with signature |u8|u8
        let mut lambdas = vector::empty<(|u8|u8)>();

        // Define lambda1: (u8) -> u8, returns input plus 1
        let lambda1: |u8|u8 has copy + drop = |a: u8| { a + 1 };

        // Define lambda2: (u8) -> u8, returns input times 2
        let lambda2: |u8|u8 has copy + drop = |a: u8| { a * 2 };

        // Push lambdas into the vector
        vector::push_back(&mut lambdas, lambda1);
        vector::push_back(&mut lambdas, lambda2);

        // Iterate over lambdas and invoke each with argument 3
        let len = vector::length(&lambdas);
        let mut i = 0u64;
        while (i < len) {
            let lambda_ref = vector::borrow(&lambdas, i as u64);
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
        let unused = 42u64; // normally lint complains unused var
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

// Featurres:
// be692128e21f595961c7e5e30f5a3f3c: Identify and list uninitialized variables labeled as 'no' or 'maybe' for further analysis.
// be132e2b495333820d8b02e55f4bcf08: Test that vectors can store and iterate over lambda functions, and that each lambda can be invoked with arguments during iteration.
// d0dda1e9fa5ca36f6c00a021b042a5ce: Annotate modules with attributes to selectively skip specified external lint checks on certain functions.
