
//# publish
module 0xCAFE::TestModule {
    use std::log;

    // Feature 1: Test local copy and mutable reference effect on a struct
    public fun test_struct_copy_and_mutation() {
        // Define a struct for the test
        struct Data has copy, drop, store {
            value: u64,
            label: bool,
        }
        // Initialize a struct instance
        let original = Data { value: 42, label: true };
        // Make a copy
        let copy_data = original;
        // Obtain a mutable reference to the copy
        letable_ref: &mut Data = &mut copy_data;
        // Mutate via the reference
        mutable_ref.value = 100;
        // Log the mutated value
        log::log_info(b"Mutated value:", &mutable_ref.value);
        // Verify original unchanged
        log::log_info(b"Original value:", &original.value);
        // Return the value from the mutated copy
        mutable_ref.value
    }

    // Feature 2: Log messages with log level and module path
    public fun test_logging() {
        log::log_debug(b"Debug message in 0xCAFE::TestModule");
        log::log_info(b"Info message in 0xCAFE::TestModule");
        log::log_warn(b"Warning message in 0xCAFE::TestModule");
        log::log_error(b"Error message in 0xCAFE::TestModule");
    }

    // Helper function to evaluate block with side effects, in order
    public fun eval_blocks_in_order() {
        let a = 0u64;
        let b = 0u64;
        let c = 0u64;
        // Evaluate block for a with side effect
        let a_value = {
            a = a + 10;
            a
        };
        // Evaluate block for b with side effect
        let b_value = {
            b = b + 20;
            b
        };
        // Evaluate block for c with side effect
        let c_value = {
            c = c + 30;
            c
        };
        // Combine the results to produce final
        (a_value, b_value, c_value)
    }
}


//# run 0xCAFE::TestModule::test_struct_copy_and_mutation

//# run 0xCAFE::TestModule::test_logging

//# run 0xCAFE::TestModule::eval_blocks_in_order


// Featurres:
// e1b3992c50b1d1b0ea6c1022cd2610ef: Test that assigning a local copy of a struct and then modifying a field through a mutable reference affects the original struct as expected, and that the correct field value is returned.
// 080b2942ee9f5a5383fb6ff5d1510203: Log messages with an associated log level and module path information
// 8ab2c2b88ea0c5733f361b383914e6f8: Test that blocks used as function arguments are evaluated in the correct left-to-right order, each block can mutate local variables, and the final result reflects these side effects.
