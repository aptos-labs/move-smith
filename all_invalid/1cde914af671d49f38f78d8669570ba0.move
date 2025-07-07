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
            // Hypothetical syntax to specify property
            property: val > 0;
        }
    }

    // A function with a specification that calls an impure function
    #[spec]
    fun spec_impure_call() {
        spec {
            // Call to impure function within spec will cause an error
            // This is for testing purposes
            impure_function();
            property: false; // placeholder
        }
    }

    // A test function to exercise the spec and report errors
    public fun run_spec_tests() {
        // Call pure specification
        spec_pure();

        // Call impure spec, should produce a detailed error about impure function call
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