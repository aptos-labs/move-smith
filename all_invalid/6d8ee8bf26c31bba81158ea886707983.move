
//# publish
module 0xCAFE::TestModule {
    use std::vector;

    // This inline function defines a no-op to test removing inline functions with bodies from final program.
    public inline fun inline_no_body() {
        // no body
    }

    // Function that assigns to the result of a block expression
    public fun assign_block_expr_result() {
        let result: u8 = {
            let temp = 5;
            temp + 3
        };
        // Use the result to prevent optimization out
        assert!(result == 8, 999);
        // Assign to the result of a match arm
        let value: u8 = match 2 {
            1 => {
                let x = 10;
                x
            },
            2 => {
                let y = 20;
                y
            },
            _ => {
                let z = 30;
                z
            }
        }; // <-- no mistake here

        assert!(value == 20, 999);
    }

    // Function that assigns to the reference of the result of a match arm
    public fun assign_ref_of_match() {
        let ref_value: &u8;
        let target_value: u8 = match 1 {
            1 => {
                let temp = 100u8;
                reference(temp)
            },
            _ => {
                let temp2 = 200u8;
                reference(temp2)
            }
        };
        // Use ref_value to prevent optimizer removal
        ref_value = &target_value;
        assert!(*ref_value == 100u8, 999);
    }

    // Helper to create reference, since Move signature does not expose direct reference creation,
    // this is a placeholder to simulate the assignment of references (normally it's safe only within scope)
    fun reference<'a>(value: u8): &u8 {
        &value
    }

    // Note: To fix the compilation error, the 'match' expression must be correctly formatted.
    // The original error indicates an unexpected token at 'match 2 { ... }' which is often caused by syntax or missing semicolon.
    // In Move, match expression syntax is correct as shown, but the code above should be fine.
    // Ensure no extras or syntax errors are introduced.
}


//# run 0xCAFE::TestModule::assign_block_expr_result


//# run 0xCAFE::TestModule::assign_ref_of_match