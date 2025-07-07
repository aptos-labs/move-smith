//# publish
module 0xabc::RefTest {
    // This module tests that mutable references to nested conditional expressions and blocks
    // correctly update variables without side effects, ensuring consistent behavior.

    fun test_conditional_references(r: u64): u64 {
        // Create a mutable reference to a conditional expression based on r
        let cond_ref = &mut { if (r % 2 == 0) { r } else { 5 } }; // &mut of 0 or 1
        *cond_ref = *cond_ref + 3; // modify the referenced value

        // Use a nested block with a mutable reference
        let mut outer_var = *cond_ref; // initial value after modification
        let nested_ref = &mut {
            // inside nested block, conditionally modify outer_var
            if (outer_var > 4) {
                outer_var = outer_var - 2;
            }
            outer_var
        };
        *nested_ref = *nested_ref + 4;

        // Reassign outer_var again directly to verify no side effects
        outer_var = *nested_ref;

        // Final value should reflect all modifications
        outer_var
    }

    // Public function to test multiple cases
    public fun run_tests(): vector<u64> {
        vector[
            test_conditional_references(2), // even, should modify accordingly
            test_conditional_references(7), // odd, should handle the else branch
        ]
    }
}

//# run 0xabc::RefTest::run_tests

//# publish
module 0xdef::NestedRef {
    // This module tests references within nested blocks and their correct updates
    fun test_nested_blocks(val: u64): u64 {
        let base = val;
        let result_ref = &mut {
            let temp = &mut {
                let inner_var = base;
                // modify inner_var through reference
                let inner_mut_ref = &mut inner_var;
                *inner_mut_ref = *inner_mut_ref + 6;
                // return inner_var
                inner_var
            };
            // after inner block, modify temp
            let temp_mut = &mut *temp;
            *temp_mut = *temp_mut * 2;
            // final value after nested modifications
            *temp_mut
        };
        // Use the outer reference to assign final value
        *result_ref = *result_ref + 1;

        // The final updated value
        *result_ref
    }

    public fun run_asserts(): vector<u64> {
        vector[
            test_nested_blocks(4), // should process nested references correctly
            test_nested_blocks(10)
        ]
    }
}

//# run 0xdef::NestedRef::run_asserts