
//# publish
module 0xCAFE::TestModule {
    // Simple function to test variable declaration and assignments
    public fun declare_and_assign() {
        // Correct syntax for variable declaration and assignment in Move
        let (x, y, z): (u64, bool, vector<u8>) = (0, false, b"");
        // Assign values to variables using reassignment
        let y = true;
        let x = 42;
        let z = b"abc";

        // Reassign within an expression, check execution order
        let sum = x + (if y then 10 else 20);
        // At this point, sum should be 52 if y is true
        // No assertion, just test declaration and expressions
    }

    // Function to test attribute misuse (simulate incorrect attribute position)
    public fun attribute_error() {
        // The attribute should be placed directly above a valid function,
        // but here we simulate incorrect placement.
        // Note: Move will raise an error if attribute is misplaced.
        #[move]
        // Dummy statement for the attribute misuse
        let _dummy = 0;
    }

    // Function to test nested attribute warning
    public fun nested_attribute_warning() {
        // Move does not support nested attributes; this should produce an error
        #[move #[move]]
        let _dummy = 1;
    }
}



//# run 0xCAFE::TestModule::declare_and_assign



//# run 0xCAFE::TestModule::attribute_error



//# run 0xCAFE::TestModule::nested_attribute_warning