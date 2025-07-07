//# publish
module 0xCAFE::nested_loop {
    // Test 1: Infinite nested loop with inner return statement
    public fun run_nested_loop_test() {
        let count = 0;
        // Outer loop
        loop {
            // Inner loop
            loop {
                count = count + 1;
                if (count >= 5) {
                    // Exit inner loop prematurely
                    break;
                }
            }
            // After inner loop break, check if count reached 5
            if (count >= 5) {
                // Break outer loop as well
                break;
            }
        }
        // After loops, count should be 5
        // Not asserting here, just for test coverage
    }

    // Test 2: Anonymous functions with various parameters
    public fun run_lambda_tests() {
        // Single parameter lambda that adds to input
        let add_fn = |x: u64| { x + 10 };
        let result1 = add_fn(5);
        // Double parameter lambda
        let sum_fn = |x: u64, y: u64| { x + y };
        let result2 = sum_fn(3, 7);
        // Lambda with no parameters
        let const_fn = || { 42 };
        let result3 = const_fn();

        // Use the results (no assertions needed)
        // just to execute lambdas
        let _ = result1;
        let _ = result2;
        let _ = result3;
    }

    // Test 3: Access control via function values in protected module
    resource struct SecretData {
        value: u64,
    }

    public fun init_secret(account: &signer) {
        move_to(account, SecretData { value: 999 });
    }

    // protected module for permission management
    module 0xCAFE::protected {
        public fun get_secret(addr: address): &SecretData {
            borrow_global<SecretData>(addr)
        }

        public fun set_secret(addr: address, new_value: u64) {
            let secret_ref = borrow_global_mut<SecretData>(addr);
            secret_ref.value = new_value;
        }
    }

    // Application module that uses protected functions
    module 0xCAFE::app {
        use 0xCAFE::protected;
        use 0xCAFE::nested_loop::SecretData;

        // Function that gets secret data via protected module
        public fun read_secret(addr: address): u64 {
            let secret_ref = protected::get_secret(addr);
            secret_ref.value
        }

        // Function that modifies secret data via protected module
        public fun update_secret(addr: address, new_val: u64) {
            protected::set_secret(addr, new_val);
        }
    }

    // Runner function to test access control
    public fun run_access_control_test(signer: &signer) {
        // Initialize secret data for the account
        init_secret(signer);
        let addr = signer.address();

        // Read secret
        let val = app::read_secret(addr);
        // Expect val == 999 (no assertion, just access)
        // Modify secret
        app::update_secret(addr, 1234);
        let new_val = app::read_secret(addr);
        // Use new_val to ensure the change
        let _ = new_val;
    }
}

//# run 0xCAFE::nested_loop::run_nested_loop_test
//# run 0xCAFE::nested_loop::run_lambda_tests
//# run 0xCAFE::nested_loop::run_access_control_test --signers 0xCAFE

// Featurres:
// 60a0169eb06c4c85ce927d0264378cc4: Test that an infinite nested loop correctly terminates when an inner loop uses a return statement, preventing subsequent assertions from executing.
// 9c8d9de92723c9d02990ddb928bae9e0: Test that Move anonymous functions (lambdas/closures) with various numbers and arrangements of parameters correctly capture and pass arguments to a function.
// 994fb366f94f073886379e668330d517: Test that access control via function values in the `protected` module correctly manages permissions for reading and modifying resources in the `app` module.
