//# publish
module 0xCAFE::TestModule {

    // Function to test defining functions with a sequence of statements for body
    public fun sequence_of_statements_test() {
        // Declare some local variables
        let a = 10;
        let b = 20;

        // Use a variable without using it to test warnings/errors for unused variables
        let _unused_var = 100;

        // Loop bounds as arbitrary unary expressions evaluated once at the start
        let lower_bound = (a as u64) + 5; // 15
        let upper_bound = (b as u64) * 2; // 40

        // For loop with computed bounds
        for idx in lower_bound..upper_bound {
            // Inside loop, do simple arithmetic operations
            let sum = (idx as u64) + a as u64;
            let product = sum * b as u64;
            // Just to ensure some statements are executed
            if product % 2 == 0 {
                continue;
            }
        }
        // End of function body, no return value
    }

    // Expose a runner function to call sequence_of_statements_test
    public fun run_sequence_test() {
        Self::sequence_of_statements_test();
    }

    // Additional test: Define a function that uses function parameters with different types
    public fun process_params(x: u8, y: u64, z: bool): u64 {
        let result = 0;
        if z {
            result = (x as u64) + y;
        } else {
            result = (y as u64) - (x as u64);
        }
        result
    }

    // Runner for process_params
    public fun run_process_params() {
        let res1 = Self::process_params(5, 1000, true);
        let res2 = Self::process_params(10, 2000, false);
        // Use res1 and res2 to prevent unused variable warnings (not necessary but good practice)
        let _ = res1;
        let _ = res2;
    }
}

// //# run 0xCAFE::TestModule::run_sequence_test --signers 0xCAFE
// //# run 0xCAFE::TestModule::run_process_params --signers 0xCAFE

// Featurres:
// f9e3dbcdb0501a55cb3534cf7c36b1c1: Define functions with a specified sequence of Move statements as their body.
// d1ff22fd96533f18059b24a9a0b9404f: Define function parameters and local variables, and receive warnings or errors if any are unused
// 9a043053cdb6ef58f1e47a28e3c1d6c2: Write expressions for the loop bounds (lower_bound and upper_bound) as arbitrary unary expressions evaluated once at the loop's start.
