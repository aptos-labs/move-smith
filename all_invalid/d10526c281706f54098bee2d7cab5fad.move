//# publish
module 0xCAFE::DeprecationTest {
    // This module is to test module attribute annotations, including deprecation.
    #[deprecate]
    public fun deprecated_function(): bool {
        true
    }

    // A function to test annotation processing when called.
    public fun call_deprecated(): bool {
        // Call the deprecated function; should produce a warning.
        Self::deprecated_function()
    }
}

//# publish
module 0xCAFE::SpecExpressions {
    // This module tests specification expressions with annotations such as `@` and `@x`.

    // Function with annotation using a specification expression.
    #[spec] // in Move, annotations like `@` are used in specifications, but for test purposes, we just define functions to simulate.
    public fun spec_expr_test(): u64 {
        // Use a specification expression to define a constant value.
        let value: u64 = 42;
        value
    }

    // Defer variable assignment with an annotation-like comment inside function.
    public fun annotated_variable(): u8 {
        // Variable with inline annotation comment (not actual syntax but simulates annotation support).
        // @constant: true
        let x: u8 = 255;
        x
    }
}

//# publish
module 0xCAFE::DupModules {
    // To test duplicated modules and multi-annotation handling.
    #[deprecated]
    #[deprecate]
    public fun old_function(): bool {
        false
    }
    // Another duplicated module with same function name should be flagged or ignored.
}

//# run
//# run 0xCAFE::DeprecationTest::call_deprecated --signers 0xCAFE
//# run 0xCAFE::SpecExpressions::spec_expr_test --signers 0xCAFE
//# run 0xCAFE::SpecExpressions::annotated_variable --signers 0xCAFE