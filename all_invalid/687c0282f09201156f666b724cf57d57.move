//# publish
module 0xCAFE::NameRules {
    /// Checks if the name is restricted (example rule: must not contain "bad" in any case)
    public fun is_restricted_name(name: &vector<u8>): bool {
        let lower_name = to_lower(name);
        contains(&lower_name, b"bad")
    }

    /// Converts a vector<u8> to lowercase vector<u8>
    fun to_lower(name: &vector<u8>): vector<u8> {
        let mut res = vector::empty<u8>();
        let mut i = 0;
        while (i < vector::length(name)) {
            let c = *vector::borrow(name, i);
            let lower_c = if (c >= 65 && c <= 90) { c + 32 } else { c };
            vector::push_back(&mut res, lower_c);
            i = i + 1;
        };
        res
    }

    /// Returns true if needle is a substring of haystack
    fun contains(haystack: &vector<u8>, needle: &vector<u8>): bool {
        let hay_len = vector::length(haystack);
        let needle_len = vector::length(needle);
        if (needle_len == 0) {
            return true;
        }
        if (needle_len > hay_len) {
            return false;
        }
        let mut i = 0;
        while (i <= hay_len - needle_len) {
            let mut j = 0;
            let mut matched = true;
            while (j < needle_len) {
                if (*vector::borrow(haystack, i + j) != *vector::borrow(needle, j)) {
                    matched = false;
                    break;
                };
                j = j + 1;
            };
            if (matched) {
                return true;
            };
            i = i + 1;
        };
        false
    }

    /// Runner function that tests some names internally
    public fun runner() {
        let good_name = b"HelloWorld";
        let bad_name = b"bAdName123";
        let _ = is_restricted_name(&vector::singleton_vec(*good_name)); // actually a wrapper test
        let _ = is_restricted_name(&vector::from_bytes(good_name));
        let _ = is_restricted_name(&vector::from_bytes(b"BADtest"));
        let _ = is_restricted_name(&vector::from_bytes(b"allgood"));
        let _ = is_restricted_name(&vector::from_bytes(b"something_bAd_here"));
    }
}
//# run 0xCAFE::NameRules::runner --signers 0xCAFE

// To test the import with aliasing and usage of >>, define another module using it below

//# publish
module 0xCAFE::UseAliasAndRightShift {
    use 0xCAFE::NameRules as NR;

    /// A function that calls the is_restricted_name from NR module,
    /// and uses >> type right shift in a dummy vector type to test syntax parsing.
    public fun test_alias_and_right_shift() {
        let name1 = b"cleanname";
        let bad_name = b"VerybAdrisky";
        // Test call via alias
        let restricted_1 = NR::is_restricted_name(&vector::from_bytes(name1));
        let restricted_2 = NR::is_restricted_name(&vector::from_bytes(bad_name));

        // Dummy usage of >> syntax in a nested vector type to parse correctly
        let _vec_vec_u8: vector<vector<u8>> = vector::empty<vector<u8>>();
        let _dummy = _vec_vec_u8;
        // Just used to force compilation, no functional effect
        let _ = restricted_1;
        let _ = restricted_2;
    }

}
//# run 0xCAFE::UseAliasAndRightShift::test_alias_and_right_shift --signers 0xCAFE


//# run
script {
    use 0xCAFE::NameRules as NR;
    use 0xCAFE::UseAliasAndRightShift as UA;

    fun main() {
        // Test names
        let names = vector::empty<vector<u8>>();
        vector::push_back(&mut names, vector::from_bytes(b"AllowedName"));
        vector::push_back(&mut names, vector::from_bytes(b"bAdStuff"));
        vector::push_back(&mut names, vector::from_bytes(b"JustFine"));
        vector::push_back(&mut names, vector::from_bytes(b"VeryBADNameHere"));

        let mut i = 0;
        while (i < vector::length(&names)) {
            let name = *vector::borrow(&names, i);
            let restricted = NR::is_restricted_name(&name);
            // no assertion needed, just call handles
            i = i + 1;
        };

        // Run the alias & right shift test function
        UA::test_alias_and_right_shift();
    }
}

// Featurres:
// 183ecf11e40cd8fa5b885c8dfa839e08: Import modules or items using an alias with the 'use' statement in your Move code.
// a24d6ae34aa30c8a1af15e003c11b649: Use the '>>' syntax to specify nested or right-shift parsing in Move code.
// 226b9262c80c22b9c116a0f73ef262da: Use the function to check if a name adheres to restricted naming rules in different cases.
