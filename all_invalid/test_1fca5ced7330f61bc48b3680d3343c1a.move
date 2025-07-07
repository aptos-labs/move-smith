//# publish
module 0xABCD::ConditionalRefTest {
    // Helper function to demonstrate mutable reference to a conditional expression affecting different variables
    fun test_conditional_ref(r: u64): u64 {
        let base_var = 5;
        // Create a mutable reference to either r or base_var based on condition
        let cond_ref = &mut { if (r % 2 == 0) { r } else { base_var } };
        // Modify through reference
        *cond_ref = *cond_ref + 3;

        // Next, define nested block with a new variable
        let nested_var = 10;
        let nested_ref = &mut {
            if (r > 10) {
                nested_var
            } else {
                *cond_ref
            }
        };
        *nested_ref = *nested_ref + 4;

        // Now, an inner block that creates a temporary variable
        let inner_temp = {
            let temp_var = 20;
            temp_var
        };
        // Create a mutable reference to the inner_temp
        let temp_ref = &mut inner_temp;
        *temp_ref = *temp_ref + 6;

        // Final variable assignment to check if modifications are consistent
        let final_value = inner_temp;
        final_value
    }

    public fun test(): u64 {
        // Call test_conditional_ref with different inputs and sum results
        test_conditional_ref(8) + test_conditional_ref(7)
    }

    // Struct with copy and drop to test references with complex data types
    struct DataStruct has copy, drop {
        value: u64
    }

    // Function to test references on struct fields with conditional expressions
    fun test_struct_ref(r: DataStruct): u64 {
        let default_struct = DataStruct { value: 15 };
        let struct_ref = &mut { if (r.value < 10) { r } else { default_struct } };

        // Modify the struct's value through reference
        (*struct_ref).value = (*struct_ref).value + 2;

        // Working with a local copy
        let local_copy = r;
        let local_ref = &mut local_copy;
        (*local_ref).value = (*local_ref).value + 3;

        // Reference to struct field
        let field_ref = &mut (*local_ref).value;
        *field_ref = *field_ref + 5;

        // Temporary block with new struct
        let temp_struct = DataStruct { value: 25 };
        let temp_ref = &mut temp_struct.value;
        *temp_ref = *temp_ref + 7;

        // Return the modified value
        local_copy.value
    }

    public fun test_struct(): u64 {
        test_struct_ref(DataStruct { value: 8 }) + test_struct_ref(DataStruct { value: 12 })
    }
}

//# run 0xABCD::ConditionalRefTest::test
//# run 0xABCD::ConditionalRefTest::test_struct