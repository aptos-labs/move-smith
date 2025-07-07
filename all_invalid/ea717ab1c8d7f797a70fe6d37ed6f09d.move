//# publish
module 0xCAFE::SpecModule {
    /// This module is for testing specifications and verification annotations.
    /// It includes functions with formal specifications and verification attributes.

    // Specification block: pure function with requires and ensures conditions
    #[spec]
    public fun spec_add(x: u64, y: u64): u64 {
        requires{x >= 0 && y >= 0};
        ensures {result >= x && result >= y};
        x + y
    }

    // Verifiable function with pre/post conditions
    #[verifies]
    public fun verify_subtract(x: u64, y: u64): u64 {
        requires {x >= y};
        ensures {result == x - y};
        x - y
    }

    // Define a resource with verification attribute for formal reasoning
    resource struct TestRes {
        value: u64,
    }

    // Verification block: function to initialize resource
    #[spec]
    public fun init_res(v: u64): TestRes {
        TestRes { value: v }
    }
}

//# run
script {
    fun main() {
        // Call the specification function
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
        assert(result == 15, 0);
    }

    // Function to test lambda with double-pipe syntax for capturing
    public fun test_lambda_capture() {
        let offset = 3;
        let lambda = || |x: u64| x + offset;
        let result = lambda()(7);
        assert(result == 10, 0);
    }

    // Function to test nested lambdas with verification attributes
    #[verifies]
    public fun test_nested_lambda() {
        let wrapper = || |x: u64| {
            let inner = || |y: u64| x + y;
            inner()(2)
        };
        let val = wrapper()(5);
        assert(val == 7, 0);
    }

    // Main function to run tests
    public fun run_tests() {
        test_lambda_pipe();
        test_lambda_capture();
        test_nested_lambda();
    }
}

//# run 0xCAFE::LambdaTest::run_tests --signers 0xCAFE --args

// Featurres:
// 596f08530fa4ba0599dc029de0496605: Add specification blocks to modules for formal verification and documentation purposes.
// 40371b5668a176b407716e3629c12949: Create lambda (anonymous) functions using pipe '|' or double-pipe '||' syntax for parameter binding.
// 7de5c415f36b52af2275191ee808773b: Use verification attributes in your code to annotate functions or resources with specific verification requirements.
