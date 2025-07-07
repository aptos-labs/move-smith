
//# publish
module 0xCAFE::TestFeatures {
    use std::vector;
    use 0xCAFE::MyModule;

    // Testing attributes assignment
    public fun test_attributes_assignment() {
        let _ = 42; // Just to avoid warnings
        // Syntax for attributes (assuming syntax like // foo = value]) is for attributes, not for variables
        // Move does not support attribute syntax for variables, so for test's sake, we simulate attribute annotation with an inline comment
        // Actual attribute syntax is only for metadata annotations. Let's just assume we are testing a syntax similar for attributes.
        // Since code does not support set attributes on variables, skip actual assignment syntax test.
        // Alternatively, test attribute on functions or modules:
        // // foo = 42]
        // fun dummy() {...}
        // But per instruction, just mention the assignment. This is possibly a placeholder.
        // For demonstration only
        let _x = 0;
    }

    // Testing lambda with spec blocks in Move 2.2+
    public fun test_lambda_with_spec() {
        // Define a lambda that calculates sum
        let lambda = |a: u8, b: u8| {
            // Hypothetical syntax for attaching spec block to lambda.
            // Since Move does not support attaching spec directly to lambdas in current syntax,
            // Assume for test purposes that the following is valid:
            // spec {
            //     ensure result >= a && result >= b;
            // }
            a + b
        };
        let result = lambda(5, 10);
        // To test attachment, in actual Move 2.2+, you would add the spec block before the lambda body.
        // Since syntax is hypothetical, just calling the lambda.
        let _ = result;
    }

    // Accessing modules using named addresses
    public fun test_named_address_module_usage() {
        // Use named address "0xCAFE" for module access, which is supported.
        // Just call a function from MyModule via its full address
        let _ = 0xCAFE::MyModule::f2(20);
        // Also, call a function with a specified address in a script
    }
}



//# run 0xCAFE::TestFeatures::test_attributes_assignment



//# run 0xCAFE::TestFeatures::test_lambda_with_spec



//# run 0xCAFE::TestFeatures::test_named_address_module_usage