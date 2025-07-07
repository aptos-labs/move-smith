
//# publish
module 0xDEAD::TestModule {
    use std::signer;
    use std::vector;

    // Define enum Data with pattern matching
    enum Data has copy, drop {
        V1,
        V2(u32, u32),
        V3 {
            y: u32
        }
    }

    // Internal function to check Data variant pattern matching
    fun get_x_data(d: Data): u32 {
        match (d) {
            Data::V1 => 1,
            Data::V2(a, b) => a,
            Data::V3 { y } => abort  // Should abort if called on V3 variant
        }
    }

    // Function to check if Data is V2
    fun is_v2(d: Data): bool {
        match (d) {
            Data::V2(_, _) => true,
            _ => false,
        }
    }

    // Function to check if Data is V1
    fun is_v1(d: Data): bool {
        match (d) {
            Data::V1 => true,
            _ => false,
        }
    }

    // Script entry point to test pattern matching and Enum handling
    public fun exercise_pattern_matching(d: Data): u32 {
        get_x_data(d)
    }

    // Function: Entry point to run a variety of tests
    public fun script_test(s: signer) {
        // Test with Data::V1
        let data_v1 = Data::V1;
        let val1 = get_x_data(data_v1);
        // Test with Data::V2
        let data_v2 = Data::V2(42, 100);
        let val2 = get_x_data(data_v2);
        // Test with Data::V3
        let data_v3 = Data::V3 { y: 55 };

        // Call pattern matching
        let _ = exercise_pattern_matching(data_v1);
        let _ = exercise_pattern_matching(data_v2);
        // The next call should abort, since get_x_data aborts on V3
        let _ = exercise_pattern_matching(data_v3);
    }

    // Function with local variable and while loop with shadowing
    public fun shadow_variable_test() {
        let outer_var = 10u64;
        let counter = 0u64;
        while (counter < 3) {
            let shadow_var = outer_var + counter; // Shadow inner variable
            // shadow_var should be outer_var + counter
            // We only need to perform an internal check to ensure variable values
            let _ = shadow_var;
            counter = counter + 1;
        };
        // Outer variable remains unchanged
        outer_var
    }

    // Internal function, only accessible inside the module
    fun internal_function(x: u64): u64 {
        x + 1
    }

    // Entry point to test internal function access
    public fun test_internal_function() {
        let res = internal_function(42);
        res
    }

    // Specification function: core invariant for Data variants
    spec fun data_variant_invariant(d: Data): bool {
        match (d) {
            Data::V1 => true,
            Data::V2(a, b) => a + b > 0,
            Data::V3 { y } => y < 1000,
        }
    }

    // Verification function to check our invariants
    public fun verify_data_invariants(d: Data): bool {
        data_variant_invariant(d)
    }
}


//# run 0xDEAD::TestModule::script_test --signers 0xCAFEBABE


//# run 0xDEAD::TestModule::shadow_variable_test


//# run 0xDEAD::TestModule::test_internal_function


// Featurres:
// b70ccb6e356eebb5b3735f5f76cd5273: Write script entry points in Move modules
// 0b62e2b6ef6d21801ee5807769ee6a3e: Test that local variable assignments inside and outside a while loop are handled correctly and that variable shadowing does not affect values across loop iterations.
// 63d45d364eac9afd0006b4525c93f85c: Use 'internal' visibility to restrict access within the module or package.
// 5a6b0789494b663480d623ed03e6360e: Test that the `Data` enum correctly returns the `x` value for both `V1` and `V2` variants and the `y` value when present, aborting when the variant is `V1`.
// 0b6f2742d8864af5077463340b1d65fc: Define specification functions (spec fun) to encapsulate logic used in specifications and verification conditions.
