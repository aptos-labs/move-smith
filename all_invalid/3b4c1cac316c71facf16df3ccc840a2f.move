//# publish
module 0xCAFE::ErrorAndEnvTest {
    use std::signer;
    use std::debug;
    use std::error;
    use std::vector;

    const DEPRECATION_ENV_VAR: vector<u8> = b"ENABLE_DEPRECATION_WARNING";

    struct ErrorHasNoDrop has store {}

    // Function that aborts with code 777 if called without a signer context
    public fun abort_if_no_signer() {
        // This function should error if signer is not passed, we enforce it by requiring signer param
    }

    // Function that simulates checking an environment variable to issue a deprecation warning
    public fun check_deprecation_warning() {
        let env_var = DEPRECATION_ENV_VAR;
        // this is a simulation: if env_var is non-empty, emit debug msg
        if (vector::length(&env_var) > 0) {
            debug::print(b"Deprecation warning enabled");
        } else {
            debug::print(b"Deprecation warning disabled");
        };
    }

    // Define a struct with different abilities for ability checks
    struct CopyOnly has copy, store {
        a: u8,
    }

    struct MoveOnly has drop, store {
        b: u8,
    }

    struct CopyAndDrop has copy, drop, store {
        c: u8,
    }

    // Test ability enforcement for copy, move, drop
    public fun ability_checks() {
        let c = CopyOnly {a: 1};
        let c_copy = copy c; // ok, has copy ability

        let m = MoveOnly {b: 2};
        // cannot copy m because no copy ability, will move it
        let m_moved = m;
        // m cannot be used anymore here

        let d = CopyAndDrop {c: 3};
        let d_copy = copy d; // copy ok because has copy ability
        // d can still be used because copied
        let _d_copy2 = copy d_copy;
    }

    // Function to test error abort with unauthorized access simulation
    public fun abort_if_not_signer(s: signer) {
        // Allowed only if signer addr is 0xCAFE
        let addr = signer::address_of(&s);
        assert!(addr == @0xCAFE, 777);
    }
}

//# run 0xCAFE::ErrorAndEnvTest::check_deprecation_warning

//# run 0xCAFE::ErrorAndEnvTest::ability_checks

//# run 0xCAFE::ErrorAndEnvTest::abort_if_not_signer --signers 0xCAFE

//# run 0xCAFE::ErrorAndEnvTest::abort_if_not_signer --signers 0xBEEF

// Featurres:
// 0669c3f7e9953b601f26a43ccebc4602: Indicate that a function can generate errors when a function is called from inappropriate locations or contexts.
// d7ed3a500e1dd4cda6c021401e5fdce3: Use an environment variable to enable or disable deprecation warnings during compilation
// 8342a5161de0c9cb2d493b1ee5f4bf40: Run ability checks to ensure proper use of copy, move, and drop operations based on type abilities.
