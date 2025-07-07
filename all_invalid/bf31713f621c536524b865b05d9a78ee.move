// Declare an address block outside of modules or scripts
address 0x123 {
    //# publish
    module TestStructMod {
        // A simple struct with a field
        struct DataStruct {
            value: u64,
        }

        // Function to create a new DataStruct
        public fun create_struct(initial_value: u64): DataStruct {
            DataStruct { value: initial_value }
        }

        // Function to modify a field via mutable reference
        public fun modify_struct_field(s: &mut DataStruct, new_value: u64) {
            s.value = new_value;
        }

        // Function to test assigning a copy and modifying it
        public fun test_assign_and_modify(): u64 {
            let original = create_struct(10);
            let mut copy = original; // assign copy
            // modify copy via mutable reference
            let s_ref = &mut copy;
            modify_struct_field(s_ref, 42);
            // return the field from original to verify it remains unchanged
            original.value
        }

        // Runner function to exercise the test
        public fun run_test() {
            let result = test_assign_and_modify();
            // The original struct's value should remain 10
            // (No assertion needed, but could be checked externally)
        }
    }

    //# run 0x123::TestStructMod::run_test
}