
//# publish
module 0xABCD::TestScriptEntryPoints {
    use std::signer;
    use 0xCAFE::MyModule;
    use 0xDEAD::DeprecatedModules;

    // Runner to invoke the module's entry functions without arguments
    public fun run_all_entry_points() {
        // Call f1 with parameters 5 and true
        let _ = MyModule::f1(5u8, true);
        // Call f3 with parameter 20
        let _ = MyModule::f3(20u16);
        // Call f8 with no parameters
        let _ = MyModule::f8();
        // Call example_vector_usage
        MyModule::example_vector_usage();
    }
}


//# run 0xABCD::TestScriptEntryPoints::run_all_entry_points


//# publish
module 0xDEAD::DeprecatedModules {
    // Mark entire namespace as deprecated with attribute
    // (In Move, deprecation at address level is conceptual; simulate with attribute on modules -- notation)
    // deprecated]
    // All modules under this namespace are considered deprecated
    // (Note: This attribute is a conceptual placeholder as Move currently doesn't support deprecation attribute syntax)
    public fun dummy() {}
}


//# publish
module 0xBADA::FeatureTest {
    use std::signer;
    use 0xCAFE::MyModule;

    // Function that will intentionally trigger a failure in preorder validation
    public fun violating_postcondition(x: u16): u16 {
        // Suppose the postcondition expects x > 10, but we deliberately violate it
        // For testing, make it return a value violating that
        x // No violation here; just placed for context
    }

    // Function with expected failure annotation (simulate with panic)
    public fun expected_failure() {
        panic!(b"Deliberate failure for testing expected failure annotation");
    }

    // Specification validation: For example, a pure validator
    public fun validate_spec(x: u32): bool {
        // Suppose a specification that x must be even
        assert!(x % 2 == 0, 999);
        true
    }

    // Function that deliberately violates spec
    public fun violate_spec(x: u32): bool {
        // Violates the spec by passing an odd number
        assert!(x % 2 == 0, 888);
        true
    }

    // Runner for all above functions
    public fun run_tests() {
        // normal execution
        let _ = validate_spec(4);
        // violation
        // This should trigger assertion failure
        let _ = violate_spec(3);
        // expected failure case
        // Should panic, testing expected failure annotation
        Self::expected_failure();
        // Postcondition violation: simulate by calling violating_postcondition
        Self::violating_postcondition(5);
    }
}


//# run 0xBADA::FeatureTest::run_tests


// Featurres:
// b70ccb6e356eebb5b3735f5f76cd5273: Write script entry points in Move modules
// c1367d37b2075aa6fdcc5740b3ac2c36: Attach deprecation attributes at the address (namespace) level to mark all modules under it as deprecated.
// 42b25b93e4183728f064e19bece2cde4: Annotate code with expected failure attributes that do not take any parameters or assigned values.
// fdc6779e3d725d21cb1af960a124c0e2: Implement specification checking to ensure that specifications adhere to pureness and correctness standards.
