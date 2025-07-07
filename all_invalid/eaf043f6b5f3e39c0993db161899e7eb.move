//# publish
module 0xCAFE::FeatureTest {
    use std::vector;

    /// Function to test local variable declaration, initialization, and summation
    public fun local_vars_and_sum(): u64 {
        let a = 10u64;
        let b = 20u64;
        let c = 30u64;
        let sum = a + b + c;
        sum
    }

    /// Returns a vector of all built-in type names as bytestrings
    public fun all_type_names(): vector<vector<u8>> {
        // These are the built-in types in Aptos Move
        vector[
            b"bool",
            b"u8",
            b"u64",
            b"u128",
            b"address",
            b"signer",
            b"vector",
            b"struct",
            b"event_handle" // Just an example; no actual type handle, kept for demonstration
        ]
    }

    /// Function to abort with a given code
    public fun test_abort(code: u64) {
        abort code;
    }

    /// Runner function to call all_type_names
    public fun runner_all_type_names(): vector<vector<u8>> {
        all_type_names()
    }

    /// Runner to test abort (this will abort execution with code 777)
    // Note: This runner is just to trigger abort in test.
    // In a real scenario, this will cause the transaction to abort.
    public fun runner_abort() {
        test_abort(777u64);
    }
}

//# run 0xCAFE::FeatureTest::local_vars_and_sum

//# run 0xCAFE::FeatureTest::runner_all_type_names

//# run 0xCAFE::FeatureTest::runner_abort

// Featurres:
// 465eefaa6e81bf15308d01b6a6fa82e8: Test that local variable declaration, initialization, and summation work correctly within a function.
// 83167d7245798f4b191535799142c0f7: Use the 'all_type_names' function to access a set containing all the built-in type names defined in the Move compiler.
// 495c054e8bb1e34a7a3807d4b0278743: Abort execution with the `abort` expression, providing a value.
