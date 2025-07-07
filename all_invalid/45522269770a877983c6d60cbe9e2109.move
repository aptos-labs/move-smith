//# publish
module 0xCAFE::SpecModule {
    /// This module is for testing specifications and verification annotations.
    /// It includes functions with formal specifications and verification attributes.

    // Note: Move currently does not support the #[spec] attribute in the Move language.
    // We will remove this attribute to avoid compilation errors.
    // Also, Move uses `assert` in scripts, but in modules, it is available in tests or scripts.
    // Since your code calls `assert` in scripts later, it is okay.
    // For pure functions, in Move, they are just normal functions.

    // Define a resource with verification attribute for formal reasoning
    resource struct TestRes {
        value: u64,
    }

    // Initialization function for resource (no attribute needed)
    public fun init_res(v: u64): TestRes {
        TestRes { value: v }
    }
}

//# run
script {
    fun main() {
        // Call the specification function (removed #[spec])
        let sum = 0xCAFE::SpecModule::spec_add(10, 20);
        // Call the verifying function
        let diff = 0xCAFE::SpecModule::verify_subtract(50, 25);

        // Initialize resource and verify its value
        let res = 0xCAFE::SpecModule::init_res(100);
        // Borrow global resource (assuming it was moved to global storage earlier)
        // For testing, just create and manipulate data locally.
    }
}
{
// No further invocation required for this test.
}

//# publish
module 0xCAFE::LambdaTest {
    /// This module tests lambda (anonymous) functions and their composition
    /// using pipe '|' and double-pipe '||' syntax.

    // Function to test lambda with pipe syntax
    public fun test_lambda_pipe() {
        let result = (|x: u64| x + 5)(10);
        assert(result == 15);
    }

    // Function to test lambda with double-pipe syntax for capturing
    public fun test_lambda_capture() {
        let offset = 3;
        let lambda = || |x: u64| x + offset;
        let result = lambda()(7);
        assert(result == 10);
    }

    // Function to test nested lambdas with verification attributes
    #[verifies]
    public fun test_nested_lambda() {
        let wrapper = || |x: u64| {
            let inner = || |y: u64| x + y;
            inner()(2)
        };
        let val = wrapper()(5);
        assert(val == 7);
    }

    // Main function to run tests
    public fun run_tests() {
        test_lambda_pipe();
        test_lambda_capture();
        test_nested_lambda();
    }
}

//# run 0xCAFE::LambdaTest::run_tests --signers 0xCAFE --args