//# publish
module 0x1::TestModule {

    // Define a constant
    const MY_CONST: u64 = 42;

    // Define a struct
    struct MyStruct {
        value: u64,
    }

    // Define a public function to be called in tests
    public fun runner() {
        // No-op, just a placeholder
    }
}

//# run 0x1::TestModule::runner --signers 0x1

//# publish
module 0x2::VariableBindingsTest {

    use 0x1::TestModule;

    // A function to test variable bindings in lambda expressions and blocks
    public fun test_variable_bindings() {
        // Immutable binding
        let x = 10;

        // Mutable binding
        let mut y = 20;

        // Lambda capturing variable x
        let lambda_x = || {
            // Should read `x`, which is immutable
            let _val = x;
        };

        // Lambda capturing mutable variable y
        let lambda_y = || {
            // Mutate y
            y = y + 1;
        };

        // Use lambda functions
        lambda_x();
        lambda_y();

        // Block with variable bindings
        {
            let a = 5; // immutable
            let mut b = 15; // mutable

            // Inner lambda in block
            let inner_lambda = || {
                // Reading immutable variable
                let _val_a = a;
                // Mutating mutable variable
                b = b + 10;
            };

            inner_lambda();
        }

        // After block, check values
        // (No assertions as per instruction)
    }

    // Function to test experiment declaration based on EXPERIMENTS keyset
    public fun declare_experiment(experiment: vector<u8>) {
        use 0x3::Experiments;

        // Assuming EXPERIMENTS keyset is a set of u8
        if (Experiments::contains(experiment)) {
            Experiments::declare(experiment);
        }
        // Else, do nothing
    }
}

//# run 0x2::VariableBindingsTest::test_variable_bindings --signers 0x2

//# publish
module 0x3::Experiments {
    // Keyset of valid experiments
    use std::keyset;

    // Suppose the keyset of permitted experiments
    public fun EXPERIMENTS() acquires Keyset {
        keyset { 1u8, 2u8, 3u8 }
    }

    // Function to check if an experiment is included
    public fun contains(experiment: vector<u8>): bool {
        keyset::contains(&EXPERIMENTS(), &experiment)
    }

    // Function to declare an experiment (placeholder)
    public fun declare(experiment: vector<u8>) {
        // Placeholder: declare the experiment
    }
}

//# run 0x3::Experiments::contains --args 2u8 --signers 0x3