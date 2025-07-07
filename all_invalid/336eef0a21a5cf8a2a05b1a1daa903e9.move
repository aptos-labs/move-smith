


//# publish
module 0xCAFE::TestFeatures {
    use std::vector;

    //! Testing marked entry functions and parameterized attributes

    // script]
    public fun entry_point_with_params_and_attributes(
        // parameter with nested attributes
        // attribute_list([// attribute_a], // attribute_b], // attribute_c(["nested", "attributes"])]]))]
        param1: u64,
        // no attribute
        param2: bool
    ): bool {
        // Just return true for success
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
        assert!(result, 42);
        // Call nested attribute entry
        let sum = Self::entry_with_nested_attributes(10u128, 20u128);
        assert!(sum == 30u128, 1000);
    }
}


//# run 0xCAFE::TestFeatures::run_entry_point_with_params --signers 0xBEEFBEEF


// Featurres:
// 92c46e3e4f1eaab7b786e011f2d5bbde: Mark functions as entry points using the 'entry' modifier or deprecated script visibility.
// d2c40146156c397fcaabfbbfe969e2af: Use 'succeeds_if' specifications to define detailed success conditions.
// 12b85df1c82f455df912067ffe6320ae: Use parameterized attributes with nested attribute lists in Move code.
