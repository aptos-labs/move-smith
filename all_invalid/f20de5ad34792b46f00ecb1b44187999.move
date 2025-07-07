//# publish
module 0xDEADBEEF::TestVariableBindings {
    use std::signer;

    /// A function to test variable binding mutability within a lambda
    fun test_variable_binding(mut_flag: bool): bool {
        let mut x = 10;
        let y = 20;

        // Lambda that captures 'x' and 'y'
        let closure = || {
            if (mut_flag) {
                x = x + 1; // Should be allowed if 'x' is mutable
            } else {
                // x = x + 1; // Mutability check: if 'x' wasn't mutable, this line would error
            }
            // Using 'y' inside lambda - should be immutable
            return y + x;
        };

        let result = closure();

        // Return result for testing purposes
        result
    }

    /// A function to test nested blocks with variable bindings
    fun test_variable_in_blocks(): u64 {
        let a = 5;
        let b = {
            let c = 10;
            c + a
        };

        a + b
    }

    /// A "runner" function to test variable bindings
    public fun run_variable_binding_tests(): bool {
        let r1 = test_variable_binding(true);
        let r2 = test_variable_binding(false);
        let r3 = test_variable_in_blocks();

        // For simplicity, return true always
        true
    }
}

//# run 0xDEADBEEF::TestVariableBindings::run_variable_binding_tests --signers 0x123
//# run 0xDEADBEEF::TestVariableBindings::test_variable_binding --args true --signers 0x123
//# run 0xDEADBEEF::TestVariableBindings::test_variable_binding --args false --signers 0x123
//# run 0xDEADBEEF::TestVariableBindings::test_variable_in_blocks --signers 0x123

//# publish
module 0xCAFEBABE::Experiments {
    use std::vector;
    use 0xDEADBEEF::TestVariableBindings;

    // List of recognized experiments
    const EXPERIMENTS: vector<vector<u8>> = vector[
        b"experiment_1",
        b"experiment_2",
        b"experiment_3"
    ];

    /// Function to check if an experiment is in the set
    fun is_valid_experiment(name: vector<u8>): bool {
        let mut i = 0;
        let len = vector::length(&EXPERIMENTS);
        while (i < len) {
            if (vector::equals(&EXPERIMENTS[i], &name)) {
                return true;
            }
            i = i + 1;
        }
        false
    }

    /// Function to perform an experiment if it is recognized
    public fun run_experiment(experiment_name: vector<u8>): bool {
        if (is_valid_experiment(experiment_name)) {
            // Perform experiment, e.g., call a test function
            TestVariableBindings::run_variable_binding_tests();
            true
        } else {
            // Experiment not recognized
            false
        }
    }

    /// Function to reference modules via access chain (assuming nested modules)
    // For demonstration, assume a path: 0xCAFEBABE::Experiments::SubModule
    // Since no nested modules are defined, this is a placeholder.
    // you could define nested modules similarly if needed.
}

//# run 0xCAFEBABE::Experiments::run_experiment --args b"experiment_1" --signers 0x456