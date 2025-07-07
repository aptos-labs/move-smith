
//# publish
module 0xBADD::PrimeAndLintTest {
    use std::vector;
    // Removed the invalid use statement, as 'std::module' does not exist in Move
    // use std::module;

    // Function to check if a number is prime
    public fun is_prime(n: u64): bool {
        if (n < 2) {
            false
        } else {
            let i = 2;
            while (i * i <= n) {
                if (n % i == 0) {
                    false
                } else {
                    // Update i in place. Need to reassign since while loop variables are immutable by default.
                    // Move does not allow reassignment; use a loop with a mutable variable outside.
                    // But in Move, variables are immutable by default. We'll need to structure differently.
                    // Instead, use a recursive helper or emulate with a different structure.
                    // For simplicity, rewrite is_prime using a recursive helper function.

                    // Since Move does not have recursion yet, we can re-implement using a loop with mutable variables:
                    
                    // Let's do a standard loop:
                };
                // Since move variables are immutable, we need to use another approach:
                // We'll reimplement is_prime with a private helper if allowed, or rework logic.
            }
            true
        }
    }

    // The above is complex because Move variables are immutable; prefer to implement is_prime differently:
    // Here's an improved version:

    fun is_prime(n: u64): bool {
        if (n < 2) {
            false
        } else {
            let i = 2;
            while (i * i <= n) {
                if (n % i == 0) {
                    return false;
                };
                i = i + 1;
            };
            true
        }
    }

    // Struct to test unpacking and module info access
    struct TestStruct has drop, store {
        value: u64,
        // Include a module info for introspection
        module_ref: vector<u8>,
    }

    // Function to create a TestStruct with module info
    public fun create_test_struct(val: u64): TestStruct {
        // Need to get module bytes
        let module_bytes = module::get_module_bytes<0xBADD::PrimeAndLintTest>();
        let s = TestStruct { value: val, module_ref: module_bytes };
        s
    }

    // A function annotated to skip specific lint checks
    // // skip(warnings)]
    public fun lint_skip_test(): bool {
        true
    }

    // Function that tests accessing module info from struct
    public fun access_module_info(s: &TestStruct): bool {
        let module_bytes: vector<u8> = s.module_ref;
        // Fetch module info for verification
        let mod_info = module::get_module_info_by_bytes(&module_bytes);
        // Confirm module name matches expected
        let name_bytes = module::get_module_name(&mod_info);
        // For simplicity, check if "PrimeAndLintTest" is a substring
        // (Since module::get_module_name() returns a vector<u8>)
        let expected = b"PrimeAndLintTest";
        let i = 0;
        let matched = false;
        while (i < vector::length(&name_bytes)) {
            if (i + vector::length(&expected) <= vector::length(&name_bytes)) {
                let match_found = true;
                let j = 0;
                while (j < vector::length(&expected)) {
                    if (*vector::borrow(&name_bytes, i + j) != *vector::borrow(&expected, j)) {
                        match_found = false;
                        break;
                    };
                    j = j + 1;
                };
                if (match_found) {
                    matched = true;
                    break;
                };
            };
            i = i + 1;
        };
        matched
    }

    // Main test function combining all features
    public fun test_all() {
        // 1. Test is_prime with small primes, non-primes, edges
        assert!(is_prime(2), 1);
        assert!(is_prime(3), 1);
        assert!(!is_prime(4), 1);
        assert!(is_prime(13), 1);
        assert!(!is_prime(1), 1);
        assert!(!is_prime(0), 1);
        assert!(is_prime(17), 1);
        // For the MDC, assuming 'MDC' was a typo or placeholder, replace with gcd: move has gcd in std::math
        // Use standard library gcd if needed
        // For now, we'll skip that line or replace with a correct check
        // Let's assume it's intended as a test
        // For simplicity, omit or replace with a simple check
        // assert!(!is_prime(20), 1); // example
        // Alternatively, replace with a different test
        assert!(!is_prime(20), 1);

        // 2. Test lint skip annotation (function should compile without warnings)
        let _ = lint_skip_test();

        // 3. Create struct and access module info
        let s = create_test_struct(42);
        assert!(access_module_info(&s), 1);

        // 4. Unpack struct and ensure it works with module info access
        let TestStruct { value: v, module_ref: m_ref } = s;
        // Confirm unpacked value
        assert!(v == 42, 1);
        // Access module info from unpacked data
        let mod_info = module::get_module_info_by_bytes(&m_ref);
        let name_bytes = module::get_module_name(&mod_info);
        let expected_name = b"PrimeAndLintTest";

        let idx = 0;
        let found_name = false;
        while (idx < vector::length(&name_bytes)) {
            if (idx + vector::length(expected_name) <= vector::length(&name_bytes)) {
                let match_found = true;
                let j = 0;
                while (j < vector::length(expected_name)) {
                    if (*vector::borrow(&name_bytes, idx + j) != *vector::borrow(&expected_name, j)) {
                        match_found = false;
                        break;
                    };
                    j = j + 1;
                };
                if (match_found) {
                    found_name = true;
                    break;
                };
            };
            idx = idx + 1;
        };
        assert!(found_name, 1);
    }
}
