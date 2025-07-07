
//# publish
module 0xCAFE::TestFeatures {
    use std::vector; // Warning: unused, can be removed if not used elsewhere

    //! Testing marked entry functions and parameterized attributes

    // script]
    public fun entry_point_with_params_and_attributes(
        // parameter with nested attributes
        // attribute_list([// attribute_a], // attribute_b], // attribute_c(["nested", "attributes"])]]))]
        param1: u64,
        // no attribute
        param2: bool
    ): bool {
        // Just return param2 for success
        param2
    }

    // Function marked as entry point with nested attributes
    // entry]
    public fun entry_with_nested_attributes(
        // attribute_list([// attribute_x], // attribute_y(["nested_attr1"])]]))]
        x: u128,
        // attribute_list([// attribute_z]])]
        y: u128
    ): u128 {
        // Return sum
        x + y
    }

    // Helper function to call entry points
    public fun run_entry_point_with_params() {
        let result = Self::entry_point_with_params_and_attributes(42u64, true);
        assert!(result, true);
        // Call nested attribute entry
        let sum = Self::entry_with_nested_attributes(10u128, 20u128);
        assert!(sum == 30u128, 1000);
    }
}



//# run --signers 0xBEEFBEEF --args 0xCAFE::TestFeatures::run_entry_point_with_params
