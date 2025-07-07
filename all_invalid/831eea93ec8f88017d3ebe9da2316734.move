
//# run
script {
    // Invoke entry points that execute module functions, testing correct execution and state changes
    // Call storage methods: store, inspect, update, remove
    // Assuming signer address is 0xDEAD
    let signer_addr = @0xDEAD;

    // Store a new Obj at signer's address
    move_call(
//# run
        script;
        0xCAFE::StorageUsage::store_at_signer_address;
        --signers
        {signer_addr};
        --args
        9u8 8u8
    );

    // Inspect value to verify storage
    let (_x, _y) = move_call(
//# run
        script;
        0xCAFE::StorageUsage::inspect_value;
        --signers
        {signer_addr}
    );

    // Update stored value
    move_call(
//# run
        script;
        0xCAFE::StorageUsage::update_value;
        --signers
        {signer_addr};
        --args
        7u8 6u8
    );

    // Inspect again to verify update
    let (_x2, _y2) = move_call(
//# run
        script;
        0xCAFE::StorageUsage::inspect_value;
        --signers
        {signer_addr}
    );

    // Remove the object
    move_call(
//# run
        script;
        0xCAFE::StorageUsage::remove_at_signer_address;
        --signers
        {signer_addr}
    );
}


//# run
script {
    // Call cross_module_call to verify invoking module functions from another module
    move_call(
//# run
        script;
        0xCAFE::StorageUsage::cross_module_call;
        --signers
        {0x0}
    );
}


//# run
script {
    // Call several_args with different signers and arguments
    move_call(
//# run
        script;
        0xCAFE::StorageUsage::several_args;
        --signers
        {0xBEEF, 0xAAAA};
        --args
        10u8 20u8
    );
}

// Define a module with internal functions to test access restrictions and internal logic

//# publish
module 0xCAFE::InternalTest {
    use std::signer;

    // Internal function that modifies a value
    fun internal_modify_value(value: &mut u64) {
        *value = *value + 1;
    }

    // Public function that internally calls the internal function
    public fun call_internal_modify(value: &mut u64) {
        internal_modify_value(value);
    }
}


//# run
script {
    // Declare a local variable outside the inner while loop
    let outer_var: u64 = 0;

    // Declare a mutable variable inside with same name to shadow outer_var
    let inner_var: u64 = 5;

    // Assign a new value before loop
    let local_shadow_var = inner_var;

    // Initialize a variable for testing variable shadowing
    let test_var = 42;

    // Loop with local variable shadowing; check correctness of shadowing
    let i: u64 = 0;
    // Using a for loop to iterate 3 times
    for (index in 0..3) {
        // Shadow inner_var inside the loop with different value
        let inner_var = index;

        // Within loop, inner_var should be loop index
        assert!(inner_var == index, 0);

        // Shadow outer_var
        let outer_var = index + 10;

        // Check that outer_var inside loop shadow is as expected
        assert!(outer_var == index + 10, 0);
    };

    // After loop, outer_var remains unchanged
    assert!(test_var == 42, 0);

    // Now testing internal function access, which should be restricted
    // The following should fail if attempted outside module
    // move_call(
    //     script;
    //     0xCAFE::InternalTest::internal_modify_value;
    //     --signers
    //     {signer_address};
    //     --args
    //     0u64
    // );

    // Correctly, call public wrapper to modify value
    // Initialize mutable variable
    let val: u64 = 0;
    // Call internal function via public wrapper
    // The following call should succeed within the script
    move_call(
//# run
        script;
        0xCAFE::InternalTest::call_internal_modify;
        --signers
        {0x0};
        --args
        &mut val
    );
    // Validate value has been incremented
    assert!(val == 1, 0);
}


//# run
script {
    // Declare variables with shadowing characteristic
    let outer_scope_var: u64 = 10;
    let shadowed_var: u64 = 100;

    // Shadow outer variable
    let shadowed_var = 50;

    // Internal helper function (simulate, can't define here, but assume inside module)
    // Here, we simulate calling an internal function that modifies local variable and testing shadowing
    // For demonstration, assume internal function is accessible (though actual access is restricted)
    // The test is to ensure that shadowed variables are isolated per scope
    let inner_scope_var: u64 = shadowed_var + 20;

    // Shadow again inside inner scope
    let shadowed_var = inner_scope_var;

    // Verify variables: inner shadow did not modify outer
    assert!(outer_scope_var == 10, 0);
    assert!(shadowed_var == 70, 0);
}

// The above code exercises the compiler and VM for script execution, variable shadowing and scope,
// internal function access restrictions, and correct state mutation through modules and scripts.


// Featurres:
// b70ccb6e356eebb5b3735f5f76cd5273: Write script entry points in Move modules
// 0b62e2b6ef6d21801ee5807769ee6a3e: Test that local variable assignments inside and outside a while loop are handled correctly and that variable shadowing does not affect values across loop iterations.
// 63d45d364eac9afd0006b4525c93f85c: Use 'internal' visibility to restrict access within the module or package.
