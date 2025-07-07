
//# publish
module 0xCAFE::AttributeTest {
    use std::vector;

    // Attribute with a constant value
    // attribute_value = 42]
    // Attribute with a module-qualified identifier
    // attribute_value = 0xCAFE::MyModule]

    // Function to test 'let' binding and type argument syntax
    public fun test_binding_and_type_args() {
        // Assign an expression to a named variable
        let a = 100u8 + 23u8;

        // Use a generic struct instantiation with a space before '<'
        let s: std::vector<u8> = std::vector::empty();

        // Return value for the function
        a
    }

    // Function to test attribute with disambiguating '<' in type parameters
    public fun test_type_disambiguation<t>(value: t): bool {
        // Use the type argument with a space before '<'
        let _ = std::option::Option< t >(std::option::None::<t>);
        // Return some boolean expression
        true
    }
}


//# run 0xCAFE::AttributeTest::test_binding_and_type_args

// Featurres:
// acf0a8237c18af53c3ab3a951204da8b: Annotate your Move code with attributes that have either constant values or module-qualified identifiers as their values.
// 41f8c7258935ea12ed715b21888bd747: Assign an expression to a named variable using a 'let' binding in Move.
// 75fff8fc3ba40c50396bcf7caeae5564: Write type arguments with a space before the '<' when necessary to disambiguate the '<' operator from a generic type parameter.
