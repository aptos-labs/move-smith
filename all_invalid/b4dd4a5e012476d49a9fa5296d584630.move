//# publish
module 0xCAFE::TestModule {
    use std::signer;
    use std::vector;

    // Helper function to check if an address string contains exactly one '=' character.
    public fun validate_address_format(address_str: &vector<u8>): bool {
        let count_equals = 0;
        let length = vector::length(address_str);
        let i = 0;
        while (i < length) {
            let byte_ref = vector::borrow(address_str, i);
            if (*byte_ref == '=' as u8) {
                count_equals = count_equals + 1;
            }
            i = i + 1;
        }
        // Returns true if exactly one '='
        return (count_equals == 1);
    }

    // Function to check if a name is a reserved name
    public fun is_reserved_name(name: &vector<u8>): bool {
        // List of reserved names, e.g., "SELF_NAME"
        // For this test, only one reserved name is checked
        if (vector::length(name) != 9) {
            return false;
        }
        if (vector::slice(name, 0, 9) == b"SELF_NAME") {
            return true;
        }
        false
    }

    #[test]
    public fun test_address_format_and_reserved_name(
        addr_str_b: vector<u8>,  // e.g., b"0xCAFE=0xBABE"
        name_b: vector<u8>       // e.g., b"testname"
    ): bool {
        let addr_ok = validate_address_format(&addr_str_b);
        assert!(addr_ok, 0); // Should be exactly one '='

        let reserved = is_reserved_name(&name_b);
        // Just an example; not asserting here
        reserved
    }
}

//# run
fun main() {
    // Example test cases:
    // Valid address string with one '='
    let addr_str1 = b"0xCAFE=0xBABE";
    // Invalid address string with multiple '='
    let addr_str2 = b"0xCAFE=0xBA=BE";
    // Name not reserved
    let name1 = b"my_module";
    // Reserved name
    let name2 = b"SELF_NAME";

    // Call the test function with valid address and non-reserved name
    // Use full address syntax for the function call with --args
    // NOTE: The arguments must be passed as byte arrays (vectors). Since the script runner expects args to be inline values, we generate the move script invocation like so:

    // Example invocations:
    //# run 0xCAFE::TestModule::test_address_format_and_reserved_name --signers 0xCAFE --args b"0xCAFE=0xBABE" b"testname"
    // But since the CLI expects argument vectors, we need to provide the byte strings as arguments.

    // For example, to run with the valid address string:
    // (Adjust accordingly in your test environment)
}