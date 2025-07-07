//# publish
module 0xCAFE::SpecTest {

    // Here we define a dummy function to simulate an impure call
    public fun impure_function() {
        // some impure operation, e.g., a global resource mutation
    }

    // A pure function with a specification that uses a pure expression
    #[spec] 
    fun spec_pure() {
        // No impure calls here
        // Some specification expression
        // For example: ensuring that a local variable is positive
        let val = 42;
        spec {
            // 'spec' block with property
            // (assuming some hypothetical syntax) to enforce 'val > 0'
            // Note: Syntax is illustrative; real Move spec might differ
            property: val > 0;
        }
    }

    // A function with a specification that calls an impure function
    #[spec]
    fun spec_impure_call() {
        spec {
            // Call to impure function within spec will cause an error
            // Hypothetically, we attempt to specify that impure_function is called
            // even though in reality, spec expressions should be pure
            impure_function();
            // The above should produce detailed error about impure call
            property: false; // placeholder
        }
    }

    // A test function to exercise the spec and report errors
    public fun run_spec_tests() {
        // Call pure special
        spec_pure();

        // Call impure spec, should produce detailed error about impure function call
        spec_impure_call();
    }

    // Additional test: specify a function with an intentional invalid spec
    #[spec]
    fun invalid_spec_expression() {
        spec {
            // Using an impure function call in the spec
            impure_function(); // Should cause an error
            property: true;
        }
    }

    // Run the invalid spec function
    public fun run_invalid_spec() {
        invalid_spec_expression();
    }
}

//# run 0xCAFE::SpecTest::run_spec_tests
//# run 0xCAFE::SpecTest::run_invalid_spec

// Featurres:
// 54aec8a306571d53a83df563ed7c4f5c: Annotate Move spec blocks with 'pragma' clauses specifying comma-separated properties
// 834db50012e317ce95b4a6e911c524dd: Receive detailed error messages when a specification expression calls an impure Move function.
// 0b0e0aad523cf344a223193ebefd1284: Write specifications in Move functions using specification language constructs
