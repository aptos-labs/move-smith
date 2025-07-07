
//# publish
module 0xCAFE::WildcardTest {
    // A public function that returns true if the name matches a pattern, false otherwise
    public fun check_name_in_whitelist(name: vector<u8>): bool {
        // Example check: if the name is "allowed_name" or ends with "_module"
        if (name == b"allowed_name") {
            true
        } else if (is_suffix(name, b"_module")) {
            true
        } else {
            false
        }
    }

    // Helper function to check suffix
    public fun is_suffix(name: vector<u8>, suffix: vector<u8>): bool {
        let name_len = vector::length(&name);
        let suffix_len = vector::length(&suffix);
        if (name_len < suffix_len) {
            false
        } else {
            let start_index = name_len - suffix_len;
            let name_suffix = vector::slice(&name, start_index, suffix_len);
            vector::equals(&name_suffix, &suffix)
        }
    }

    // Empty struct for namespace purposes (Move does not support nested modules)
    struct M {}

    // Function to test access to names with wildcards - moved outside to top level
    public fun test_wildcard_access(name: vector<u8>): bool {
        check_name_in_whitelist(name)
    }
}


//# run
script {
    // Testing name checks with various inputs
    fun main() {
        // Allowed name
        let name1 = b"allowed_name";
        let result1 = 0xCAFE::WildcardTest::check_name_in_whitelist(name1);

        // Name ending with _module
        let name2 = b"test_module";
        let result2 = 0xCAFE::WildcardTest::check_name_in_whitelist(name2);

        // Name not matching the pattern
        let name3 = b"not_allowed";
        let result3 = 0xCAFE::WildcardTest::check_name_in_whitelist(name3);

        // Access via function (no nested modules)
        let result4 = 0xCAFE::WildcardTest::test_wildcard_access(b"allowed_name");
        let result5 = 0xCAFE::WildcardTest::test_wildcard_access(b"some_module");
    }
}


//# run 0xCAFE::WildcardTest::main