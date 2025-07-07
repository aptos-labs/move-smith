
//# publish
module 0xCAFE::DiagnosticsAndLoops {
    use std::vector;

    // Function to intentionally produce a diagnostic message (simulated via debug print)
    public fun trigger_diagnostic() {
        debug!("[Diagnostics] This is a simulated diagnostic message");
    }

    // Function that contains a while loop with complex condition involving block with multiple assignments
    public fun while_loop_with_assignment() {
        let a = 0u64;
        let b = 10u64;
        // The loop condition has a block where a and b are updated
        while (
            {
                // Perform multiple assignments inside the block
                a = a + 2;
                b = b - 1;
                // The condition uses updated variables
                a < b + 3
            }
        ) {
            // Inside loop: can do something, but for testing just continue
            // No operation needed
            // To prevent infinite loop, optionally include a break if needed
        };
        // Return final values for verification, if needed
        (a, b)
    }

    // Struct with type parameter to test type parameter declaration
    struct ParametricStruct<T> has store, key {
        value: T,
        label: vector<u8>,
    }

    // Function to create and store a ParametricStruct with a type parameter
    public fun create_parametric_struct<U: copy + drop>(label_data: vector<u8>, val: U): () {
        let ps = ParametricStruct<U> {value: val, label: label_data};
        move_to<ParametricStruct<U>>(&signer::borrow_signer(), ps);
    }

    // Runner function to execute the above functions
    public fun run_tests() {
        trigger_diagnostic();
        let (final_a, final_b) = while_loop_with_assignment();

        // Create a parametric struct with a concrete type
        create_parametric_struct(b"test", 42u8);
        create_parametric_struct(b"float", 3.14);
    }
}



//# run 0xCAFE::DiagnosticsAndLoops::run_tests --signers 0xBADD