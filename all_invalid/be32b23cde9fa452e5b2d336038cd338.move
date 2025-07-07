//# publish
module 0xCAFE::EnvAndSpec {
    use std::vector;
    use std::string;

    /// Returns the value of an environment variable as an optional vector<u8> (byte string)
    /// Returns vector[] if not found, to simplify
    native public fun get_env_var(name: vector<u8>): vector<u8>;

    /// Wrapper to get "MVC_EXP" environment variable
    public fun get_mvc_exp(): vector<u8> {
        get_env_var(b"MVC_EXP")
    }

    /// Wrapper to get "MOVE_COMPILER_EXP" environment variable
    public fun get_move_compiler_exp(): vector<u8> {
        get_env_var(b"MOVE_COMPILER_EXP")
    }

    /// A specification-only function declared with `spec fun`
    spec fun is_positive(x: u64): bool {
        x > 0
    }

    /// A native spec function stub (simulated here)
    native spec fun native_spec_function(x: u64): bool;

    /// A function to test the uniqueness of field IDs in a vector of u8 identifiers
    /// Returns true if all fields are unique
    public fun unique_fields(fields: vector<u8>): bool {
        let length = vector::length(&fields);
        let mut i = 0;
        while (i < length) {
            let mut j = i + 1;
            while (j < length) {
                let a = *vector::borrow(&fields, i);
                let b = *vector::borrow(&fields, j);
                assert!(a != b, 123); // should abort if duplicate field found
                j = j + 1;
            };
            i = i + 1;
        };
        true
    }

    /// Runner function that tries to call environment variable getters and unique_fields
    public fun runner() {
        let mvc = get_mvc_exp();
        let move_compiler = get_move_compiler_exp();

        // Check unique_fields with no duplicates
        let fields1 = vector[1u8, 2u8, 3u8];
        let _ = unique_fields(fields1);

        // Check unique_fields with duplicates (commented out to avoid abort)
        // let fields2 = vector[1u8, 2u8, 1u8];
        // let _ = unique_fields(fields2);

        // Call native spec function too (no op here)
        let _ = native_spec_function(42u64);
    }
}

//# run 0xCAFE::EnvAndSpec::runner

// Featurres:
// 4e4182339c369d854f1903c208e6f1b0: Access environmental variables 'MVC_EXP' and 'MOVE_COMPILER_EXP' to determine compiler experiment configurations.
// f5aa7ac54063febf350e6a0e16c6871d: Create specification functions with the `fun` or `native` keywords.
// a037d0d2552002b980dd77fd2443a8b6: Ensure each field in a set of fields is unique by its identifier.
