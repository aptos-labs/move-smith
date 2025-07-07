//# publish
module 0xA550C3D3EE0B43F2::TestFeatures {
    // Use flags or metadata to specify compiler version, if applicable
    // Assuming a special pragma or feature flag for version 2; placeholder as actual syntax depends on the environment
    // For illustration:
    // #![move_version = 2]

    // Declare a boolean variable to test 'assert' condition recognition
    public struct AssertFlag has copy, drop {
        value: bool,
    }

    // Function to set the assert flag to true
    public fun set_assert_flag(account: &signer) {
        move_to(account, AssertFlag { value: true });
    }

    // Function to check if 'assert' condition is recognized in specifications
    public fun verify_assert_condition(account: &signer): bool {
        let flag = borrow_global<AssertFlag>(signer_address_of(account));
        flag.value
    }
}

//# run 0xA550C3D3EE0B43F2::TestFeatures::set_assert_flag --signers 0xA550C3D3EE0B43F2

//# publish
module 0xA550C3D3EE0B43F2::TestParserEndExpression {
    // Function to parse an expression and determine if it reached its end
    public fun is_end_of_expression(expr: vector<u8>): bool {
        // Simplistic parser simulation: check for a specific delimiter, e.g., 0x00
        let len = vector::length(&expr);
        if (len == 0) {
            false
        } else {
            // Is the last byte a newline or semicolon indicating end?
            // For test purposes, consider 0x3B (';') as end
            *vector::borrow(&expr, len - 1) == 0x3B
        }
    }
}

//# run 0xA550C3D3EE0B43F2::TestParserEndExpression::is_end_of_expression --args "vector[1,2,3,0x3B]"  // Should return true
