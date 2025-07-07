
//# publish
module 0xCAFE::TestModule {
    // Simple function to test variable declaration and assignments
    public fun declare_and_assign() {
        declare (x, y, z): (u64, bool, vector<u8>);
        // Assign values to variables
        y = true;
        x = 42;
        z = b"abc";

        // Reassign within an expression, check execution order
        let sum = x + (if y then 10 else 20);
        // At this point, sum should be 52 if y is true
        // No assertion, just test declaration and expressions
    }

    // Function to test attribute misuse (simulate incorrect attribute position)
    public fun attribute_error() {
        // Incorrect nesting of attribute
        #[move]
        // The above attribute should be valid. Here, we simulate misuse by placing attribute
        // outside of a valid function or struct, but since Move compiler enforces proper placement,
        // it should be caught at compile time if wrongly used. For test purpose, leave as dummy.
        let _dummy = 0;
    }

    // Function to test nested attribute warning
    public fun nested_attribute_warning() {
        // Try nested attributes which are not valid in Move
        // This should produce a warning or error during compilation
        #[move #[move]] 
        let _dummy = 1;
    }
}


//# run 0xCAFE::TestModule::declare_and_assign


//# run 0xCAFE::TestModule::attribute_error


//# run 0xCAFE::TestModule::nested_attribute_warning

// Featurres:
// de04319eb88235b3bcf9371bc1ad5660: Declare local variables in Move code using `declare` statements with a list of variables.
// 28e3cac7cfb6fd855decf014568a084c: Identify and warn about attributes used in incorrect positions, such as nested attributes where they are not expected.
// fa4f2c34a031f7541af4e2c9851a579f: Test that assignments inside an expression execute before using the updated variable's value within the same expression.
