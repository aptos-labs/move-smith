
//# publish
module 0xDEAD::QuantifierModule {
    use std::vector;

    // This module tests defining multiple modules, quantifiers, and variable bindings within lambdas and blocks.

    // Define a secondary module to test multiple module definition support
//# publish
    module 0xDEAD::InnerModule {
        // Simple function to be called in lambdas
        public fun add_one(x: u64): u64 {
            x + 1
        }
    }

    // Define a module with a function that uses quantifiers and variable bindings
//# publish
    module 0xDEAD::QuantifierTest {
        use 0xDEAD::InnerModule;

        // Define a struct to hold test results
        struct Results has store {
            exists_flag: bool,
            forall_flag: bool,
            lambda_capture_result: u64,
            block_capture_result: u64,
        }

        // Function that exercises quantifiers, variable bindings, lambdas, and blocks
        public fun run_tests() {
            // Declare variables with different mutability in block scope
            let x = 10u64;
            let y = 20u64;

            // Define a vector to simulate a collection for quantifier tests
            let v: vector<u64> = vector[15, 20, 25];

            // Quantifiers: exists and forall
            let exists_flag = exists (val in &v) {
                *val == 20
            };
            let forall_flag = forall (val in &v) {
                *val >= 15
            };

            // Variable capture in lambda: capturing x, y, and outer scope variable
            let lambda_result = {
                // Inside lambda, y is borrowed mutably, x is borrowed immutably.
                let lambda = |z: u64| -> u64 {
                    // Call inner module function
                    let result1 = InnerModule::add_one(z);
                    // Use captured y variable, since it's mutable
                    y = y + z;
                    // Return sum
                    result1 + y + x
                };
                lambda(5)
            };

            // Variable capture in block: modify y
            let block_result = {
                let temp_y = y;
                y = y + 10;
                temp_y + 5
            };

            // Instantiate Results to hold the results
            let results = Results {
                exists_flag,
                forall_flag,
                lambda_capture_result: lambda_result,
                block_capture_result: block_result,
            };

            // Use the results in some way (could be assertions, but omitted here)
            results
        }
    }
}


//# run 0xDEAD::QuantifierModule::QuantifierTest::run_tests


// Featurres:
// 5384dd53cb94407108d41c3fd47a4dc8: Define multiple modules in a single source file.
// 89191f8c80cf96615942157c5298890e: Write quantifiers using special identifier syntax (e.g., 'forall', 'exists').
// 8171a7fbf944cb0c44bd028f983d3a3b: Handle variable bindings in lambda expressions and blocks to determine their mutability status.
