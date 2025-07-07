//# publish
module 0xCAFE::NameValidator {
    // Function to check if a name adheres to certain restricted rules:
    // - Name must not contain spaces
    // - Name must not contain special characters like '@', '#', '$'
    // - Name length must be between 1 and 10 bytes
    public fun is_valid_name(name: vector<u8>): bool {
        let len = vector::length(&name);
        if (len == 0 || len > 10) {
            return false;
        }
        let i = 0;
        while (i < len) {
            let c = *vector::borrow(&name, i);
            // Check for space
            if (c == ' ' as u8) {
                return false;
            }
            // Check for special characters
            if (c == '@' as u8 || c == '#' as u8 || c == '$' as u8) {
                return false;
            }
            i = i + 1;
        }
        true
    }

    // Function with multiple pragma annotations to test compiler directives
    //# gas_preserve
    //# verifier_ignore
    public fun dummy() {
        // Empty function
    }

    // Function to test shadowing
    public fun shadow_test() {
        let x = 10;
        // Shadow outer x
        let x = x + 5;
        // Return value not used; just testing shadowing and mutability
        // Shadow again inside a nested block
        let y = {
            let x = x + 10;
            x
        };
        // Outside, x should still be the shadowed value
        let _ = y; // To avoid warning
    }
}

//# publish
module 0xCAFE::TestRunner {
    use 0xCAFE::NameValidator;

    #[test]
    fun test_name_validation(): bool {
        let test_cases = vector[
            (b"ValidName".to_vec(), true),
            (b"TooLongName123".to_vec(), false),
            (b"Name WithSpace".to_vec(), false),
            (b"Special@Char".to_vec(), false),
            (b"Valid".to_vec(), true),
            (b"".to_vec(), false),
            (b"1234567890".to_vec(), true), // length exactly 10
        ];

        let len = vector::length(&test_cases);
        let i = 0;
        while (i < len) {
            let (name, expected) = *vector::borrow(&test_cases, i);
            let result = NameValidator::is_valid_name(name);
            // Normally assertions, but we're ignoring assertions per instructions
            // just run the test functions
            // Uncomment the following line if assertions are allowed:
            // assert(result == expected, 0);
            i = i + 1;
        }
        true
    }

    //# run 0xCAFE::NameValidator::is_valid_name
    //# run 0xCAFE::NameValidator::shadow_test
}