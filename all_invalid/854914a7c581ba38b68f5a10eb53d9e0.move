
//# publish
module 0xDEAD::QuantifierModule {
    use std::vector;

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
        public fun run_tests(): Results {
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
                // Inside lambda, z is a parameter
                let lambda = |z: u64| -> u64 {
                    // Call inner module function
                    let result1 = InnerModule::add_one(z);
                    // Use captured y mutable variable
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
            Results {
                exists_flag,
                forall_flag,
                lambda_capture_result: lambda_result,
                block_capture_result: block_result,
            }
        }
    }
}



//# run 0xDEAD::QuantifierModule::QuantifierTest::run_tests
