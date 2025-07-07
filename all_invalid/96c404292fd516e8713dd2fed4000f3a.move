
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

    // A public module to test name access features
    public module NestedModule {
        // Function to test access to names with wildcards
        public fun test_wildcard_access(name: vector<u8>): bool {
            check_name_in_whitelist(name)
        }
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

        // Access via nested module
        let result4 = 0xCAFE::WildcardTest::NestedModule::test_wildcard_access(b"allowed_name");
        let result5 = 0xCAFE::WildcardTest::NestedModule::test_wildcard_access(b"some_module");

        // The test results are not asserted; just run to compile/execute.
    }
}

//# run 0xCAFE::WildcardTest::main

// Featurres:
// b6bd62c2f45860d031831d2366ba177e: Allow the use of wildcards in name accesses when permitted by context (e.g., Module::*).
// 509b20779ecabeff191eebe7cae1cfbd: Declare public functions and modules using the 'public' visibility modifier.
// 226b9262c80c22b9c116a0f73ef262da: Use the function to check if a name adheres to restricted naming rules in different cases.
