
//# publish
module 0xCAFE::TestModule {
    use std::log;

    // Feature 1: Test local copy and mutable reference effect on a struct
    public fun test_struct_copy_and_mutation() {
        // Define a struct for the test outside the function
        // Move the struct definition outside to the module scope
    }
}

// Define the struct at module scope
struct Data has copy, drop, store {
    value: u64,
    label: bool,
}

// Now, implement the test function separately
public fun test_struct_copy_and_mutation() {
    // Initialize a struct instance
    let original = Data { value: 42, label: true };
    // Make a copy
    let copy_data = original;
    // Obtain a mutable reference to the copy
    letable_ref: &mut Data = &mut copy_data;
    // Mutate via the reference
    mutable_ref.value = 100;
    // Log the mutated value
    log::log_info(b"Mutated value:");
    log::log_info(&mutable_ref.value);
    // Verify original unchanged
    log::log_info(b"Original value:");
    log::log_info(&original.value);
    // Return the value from the mutated copy for test assertion (if needed)
    // But since Move functions don't return values for tests, we omit returns
}

// Feature 2: Log messages with log level and module path
public fun test_logging() {
    log::log_debug(b"Debug message in 0xCAFE::TestModule");
    log::log_info(b"Info message in 0xCAFE::TestModule");
    log::log_warn(b"Warning message in 0xCAFE::TestModule");
    log::log_error(b"Error message in 0xCAFE::TestModule");
}

// Helper function to evaluate blocks with side effects, in order
public fun eval_blocks_in_order() {
    let a: u64 = 0;
    let b: u64 = 0;
    let c: u64 = 0;

    let a_value = {
        a = a + 10;
        a
    };
    let b_value = {
        b = b + 20;
        b
    };
    let c_value = {
        c = c + 30;
        c
    };
    // For testing purposes, you can log or return these results if needed
    // but Move does not support returning multiple values.
    // Alternatively, you could store or log them.
}


//# run 0xCAFE::TestModule::test_struct_copy_and_mutation


//# run 0xCAFE::TestModule::test_logging


//# run 0xCAFE::TestModule::eval_blocks_in_order
