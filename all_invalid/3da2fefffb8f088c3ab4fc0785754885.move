//# publish
module 0xCAFE::TestModule {
    use std::debug;

    // Function to test local variable assignment and casting/annotating with sub-expressions
    public fun test_assignment_and_cast(): u8 {
        let x = 42u16;
        // Use a local variable in an assignment with casting
        let y = (x as u8);
        y // return y
    }

    // Function to test lambda lifting by defining a separate function that can be called later
    public fun helper_function(val: u64): u64 {
        val + 10
    }

    // Main test function, which calls helper_function to simulate lifting a lambda
    public fun run_tests() {
        let x = test_assignment_and_cast();
        debug::print(&x);
        let result = helper_function(100);
        debug::print(&result);
    }

    // Optional: defining a function to demonstrate applying lambda lifting
    //# run 0xCAFE::TestModule::run_tests
}

// Featurres:
// b22b59fd28979c7d0b5ad3ffc3665620: Use a local variable in an assignment expression.
// 6f8dd25f8a7d8da62724449569e19dd6: Create cast or annotate expressions with sub-expressions and types.
// cd34022955ec70e2dd4dd01bc5be5352: Apply lambda lifting to function-level specifications to move lambdas out of annotations and specifications.
