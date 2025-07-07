module 0xCAFE::AttributeTest {
    use std::vector;
    use std::option;

    // Attribute with a constant value
    // attribute_value = 42]
    // Attribute with a module-qualified identifier
    // attribute_value = 0xCAFE::MyModule]

    // Function to test 'let' binding and type argument syntax
    public fun test_binding_and_type_args() {
        // Assign an expression to a named variable
        let a = 100u8 + 23u8;

        // Use a generic struct instantiation with a space before '<'
        let s: vector<u8> = vector::empty();

        // Return value for the function
        a
    }

    // Function to test attribute with disambiguating '<' in type parameters
    public fun test_type_disambiguation<t>(value: t): bool {
        // Use the type argument with a space before '<'
        let _ = option::option< t>(option::none<t>());
        // Return some boolean expression
        true
    }
}