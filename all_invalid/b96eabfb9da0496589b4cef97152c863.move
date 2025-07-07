//# publish
module 0x1::TestModule {
    // Use of anonymous address in a constant
    const ANON_ADDRESS: address = @0xABCDEF0123456789;

    // Module alias
    alias 0x1::TestModule as TM;

    // Function to test anonymous address and alias usage
    public fun test_anonymous_and_alias() {
        let addr_bytes = b"ABCDEF0123456789";
        assert!(addr_bytes == b"ABCDEF0123456789", 1);
        // Call to another function via alias
        TM::helper_function();
    }

    // Helper function to be called via alias
    public fun helper_function() {
        // Function body that does nothing for now
        return;
    }

    // Lambda lifting: define a top-level function that captures a lambda
    public fun lifted_lambda_test() {
        // Move doesn't have lambdas per se, but simulate by passing a function as argument
        let result = execute_function_with_lambda(some_lambda);
        assert!(result, true);
    }

    // Function that accepts a function parameter (simulating lambda)
    fun execute_function_with_lambda(f: (bool) -> bool): bool {
        f(true)
    }

    // Lambda expression simulated as a function
    fun some_lambda(flag: bool): bool {
        if (flag) {
            return true;
        } else {
            return false;
        }
    }
}

//# run
script {
    // Run the test_anonymous_and_alias function
    0x1::TestModule::test_anonymous_and_alias();
}

//# run 0x1::TestModule::lifted_lambda_test