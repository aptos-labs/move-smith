//# publish
module 0xCAFE::InteractionTest {
    use std::vector;
    use std::string;

    // Entry point for test scripts
    public fun run_tests() {
        // Test inside script: nested variable modification
//# run
        script_test_variable_scope();

        // Test internal functions are not callable externally (try to call should fail compile if attempted)
        // But for the test here, only call internal functions within module
        internal_aux_function();

        // Test pattern matching strings matching multiple tokens
        let pattern1 = "init*Var"; // Should match identifiers starting with "init" and ending with "Var"
        let pattern2 = "do*Work";
        let pattern3 = "match*Pattern";

        let name1 = "initializeVar";
        let name2 = "doSomeWork";
        let name3 = "matchPattern";

        assert!(matches_pattern(pattern1, name1), 0);
        assert!(matches_pattern(pattern2, name2), 0);
        assert!(matches_pattern(pattern3, name3), 0);
    }

    // Internal function that should only be used within this module
    fun internal_aux_function() {
        // Internal logic, does nothing specific
        let _ = 42;
    }

    // Helper function for pattern matching
    fun matches_pattern(pattern: &str, name: &str): bool {
        // Simple pattern matching: '*' matches any sequence
        // For this test, implement a naive pattern matching
        // Since no need for full regex, check prefix and suffix
        if (!contains(pattern, "*")) {
            return pattern == name;
        }
        let parts = split(pattern, "*");
        if (vector::length(&parts) == 2) {
            let prefix = &vector::borrow(&parts, 0);
            let suffix = &vector::borrow(&parts, 1);

            let prefix_str_opt = string::from_utf8(prefix);
            let suffix_str_opt = string::from_utf8(suffix);
            let name_str_opt = string::from_utf8(&string::to_bytes(name));

            if (prefix_str_opt.is_some() && suffix_str_opt.is_some() && name_str_opt.is_some()) {
                let p = prefix_str_opt.unwrap();
                let s = suffix_str_opt.unwrap();
                let n = name_str_opt.unwrap();
                return starts_with(&n, &p) && ends_with(&n, &s);
            };
        };
        false
    }

    fun contains(s: &str, pattern_char: &str): bool {
        let bytes = string::to_bytes(s);
        let c_bytes = string::to_bytes(pattern_char);
        let c_byte = *vector::borrow(&c_bytes, 0);
        for (b in &bytes) {
            if (*b == c_byte) {
                return true;
            }
        }
        false
    }

    fun split(s: &str, delimiter: &str): vector<&str> {
        let parts = vector::empty<&str>();
        let bytes = string::to_bytes(s);
        let delim_bytes = string::to_bytes(delimiter);
        let start = 0;
        let i = 0;
        while (i < vector::length(&bytes)) {
            if (i + vector::length(&delim_bytes) <= vector::length(&bytes)) {
                let window = &vector::slice(&bytes, i, i + vector::length(&delim_bytes));
                if (window == &delim_bytes) {
                    let part_str = string::substr(s, start, i);
                    vector::push_back(&mut parts, part_str);
                    i = i + vector::length(&delim_bytes);
                    continue;
                }
            };
            i = i + 1;
        };
        // Last part
        let last_part = string::substr(s, start, vector::length(&bytes));
        vector::push_back(&mut parts, last_part);
        parts
    }

    fun starts_with(s: &str, prefix: &str): bool {
        let s_bytes = string::to_bytes(s);
        let p_bytes = string::to_bytes(prefix);
        if (vector::length(&p_bytes) > vector::length(&s_bytes)) {
            false
        } else {
            let len_p = vector::length(&p_bytes);
            for (i in 0..len_p) {
                if (*vector::borrow(&s_bytes, i) != *vector::borrow(&p_bytes, i)) {
                    return false;
                }
            };
            true
        }
    }

    fun ends_with(s: &str, suffix: &str): bool {
        let s_bytes = string::to_bytes(s);
        let suf_bytes = string::to_bytes(suffix);
        if (vector::length(&suf_bytes) > vector::length(&s_bytes)) {
            false
        } else {
            let start_idx = vector::length(&s_bytes) - vector::length(&suf_bytes);
            for (i in 0..vector::length(&suf_bytes)) {
                if (*vector::borrow(&s_bytes, start_idx + i) != *vector::borrow(&suf_bytes, i)) {
                    return false;
                }
            };
            true
        }
    }

    // Script to test local variable scope within a script context
    public fun script_test_variable_scope() {
        let outer_var = 0u64;
        while (outer_var < 3) {
            let inner_var = outer_var + 10;
            // Shadowing outer_var
            let outer_var = outer_var + 1;
            // No explicit assertions, just perform operations
            let _ = inner_var;
            let _ = outer_var;
        };
        // after loop, outer_var should be 0 (original outer_var remains unchanged)
        assert!(outer_var == 0, 0);
    }
}
