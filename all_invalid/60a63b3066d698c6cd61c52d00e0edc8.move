
// Invoke MyModule::f1 with parameters
public fun run_test_script_entry_points() {
    let result1 = 0xCAFE::MyModule::f1(5u8, true);
    let result2 = 0xCAFE::MyModule::f1(10u8, false);
    // Invoke f3 with parameter
    let _s = 0xCAFE::MyModule::f3(15u16);
    // Invoke storage functions
    let signer_address = @0xBEEF;
    0xCAFE::StorageUsage::store_at_signer_address(signer_address, 7u8, 8u8);
    let _value = 0xCAFE::StorageUsage::inspect_value(signer_address);
    0xCAFE::StorageUsage::update_value(signer_address, 9u8, 10u8);
    let _updated_value = 0xCAFE::StorageUsage::inspect_value(signer_address);
    0xCAFE::StorageUsage::remove_at_signer_address(signer_address);
    let total = 0xCAFE::StorageUsage::several_args(signer_address, signer_address, 1u8, 2u8);
}


//# run 0xCAFE::run_test_script_entry_points

// Test 2: Local variable handling inside and outside a while loop, verify variable shadowing and persistence
public fun run_variable_scope_test() {
    // Outside loop assignment
    let a = 0u8;
    // Loop with local shadowed variable
    let i = 0u8;
    while (i < 3u8) {
        let a = i + 10u8; // local shadow
        a; // use the local shadow
        i = i + 1u8;
    };
    // After loop, verify that outer 'a' remains unchanged
    a; // note: no change expected
}


//# run 0xCAFE::run_variable_scope_test

// Test 3: Module filtering with conditionals - simulate iterating over modules, select based on condition
// Since Move doesn't have runtime reflection, emulate by creating a vector of module addresses and filtering
public fun run_module_filtering() {
    let modules = vector[
        @0xCAFE,
        @0xDEAD,
        @0xBEEF,
        @0xCAFE,
        @0xC0FF,
    ];
    let selected_modules = vector[];
    let i = 0u64;
    while (i < vector::length(&modules)) {
        let m = *vector::borrow(&modules, i);
        // Filter: select modules with address 0xCAFE
        if (m == @0xCAFE) {
            vector::push_back(&mut selected_modules, m);
        };
        i = i + 1u64;
    };
    // At this point, selected_modules should contain only 0xCAFE addresses
}


//# run 0xCAFE::run_module_filtering

// Test 4: Inline 'spec' blocks embedded in expressions to verify behavior and control flow
public fun run_inline_spec_test() {
    // Surprise: simulate an inline spec within a match arm
    let value = match (1u8) {
        1 => {
            // spec block: expected to pass
            // The spec could be an inline assert
            assert!(true, 0);
            100u8
        },
        2 => {
            assert!(false, 999); // would cause abort if taken
            200u8
        },
        _ => {
            50u8
        }
    };
    // Use value
    value; // last expression
}

//# run 0xCAFE::run_inline_spec_test


// Featurres:
// b70ccb6e356eebb5b3735f5f76cd5273: Write script entry points in Move modules
// 0b62e2b6ef6d21801ee5807769ee6a3e: Test that local variable assignments inside and outside a while loop are handled correctly and that variable shadowing does not affect values across loop iterations.
// f8287dfd86ee638b034bdb7d8ba43c52: Filter modules associated with an address according to custom conditions.
// a86de4c293c224fb889184ab0355339e: Embed 'spec' blocks as part of an expression for in-line specification.
