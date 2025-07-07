//# publish
address 0x1 {
module NestedModule {
    // Define a simple struct
    struct TestStruct has copy, drop, store {
        value: u64,
        flag: bool,
    }

    // Function to modify the 'value' field of a mutable reference
    public fun set_value(s: &mut TestStruct, new_value: u64) {
        s.value = new_value;
    }

    // Function that returns the current value of the struct's 'value'
    public fun get_value(s: &TestStruct): u64 {
        s.value
    }

    // Runner function to test assigning, modifying, and accessing struct fields
    public fun run_test(): u64 {
        // Initialize struct instance
        let original_struct = TestStruct {
            value: 10,
            flag: false,
        };

        // Create a mutable copy
        let mut local_struct = original_struct;

        // Modify the 'value' field through a mutable reference
        set_value(&mut local_struct, 42);

        // Return the modified value to verify correctness
        get_value(&local_struct)
    }
}
}

//# publish
address 0x2 {
module OuterModule {
    // Import NestedModule for referencing
    use 0x1::NestedModule;

    // Function to perform nested module referencing and call inner functions
    public fun test_nested_mod_ref(): u64 {
        // Call the runner function inside NestedModule
        NestedModule::run_test()
    }
}
}

//# run 0x2::OuterModule::test_nested_mod_ref