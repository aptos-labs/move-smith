
//# publish
module 0xCAFE::AliasTest {
    // Define module aliases for convenient referencing
    use 0xCAFE::InnerModule as InnerMod;

    // Inner module to be aliased
    module InnerModule {
        public struct Value {
            value: u64,
        }

        public fun make_value(v: u64): Value {
            Value { value: v }
        }

        public fun update_value(v: &mut Value, new_value: u64) {
            v.value = new_value;
        }
    }

    // Main test module
    public fun test_value_rename_and_ensure() {
        let val = InnerMod::make_value(10);
        let new_val = val;

        // Rename and reassigned within nested expressions
        let renamed = {
            let renamed_value = new_val;
            // Update the value
            InnerMod::update_value(&mut renamed_value, 20);
            // Return the renamed value after update
            renamed_value
        };

        // Use 'ensures' to verify postcondition: value should be 20
        ensure(
            renamed.value == 20,
            0xCAFE,
            "postcondition_failed"
        );
    }
}



//# run 0xCAFE::AliasTest::test_value_rename_and_ensure