
//# publish
module 0xDEAD::NestedAccessAndScopeTest {
    use std::signer;

    // Define a nested struct with multiple levels
    struct Outer has store, key {
        inner: Inner,
        value: u64,
    }

    struct Inner has store {
        nested: DeepNested,
        flag: bool,
    }

    struct DeepNested has store {
        data: u128,
        status: bool,
    }

    // Internal function to set nested fields (simulate internal visibility)
    fun update_deep_nested(obj: &mut Outer, new_data: u128, new_status: bool){
        obj.inner.nested.data = new_data;
        obj.inner.nested.status = new_status;
    }

    // Function to get nested fields
    public fun get_deep_data(obj: &Outer): u128 {
        obj.inner.nested.data
    }

    // Function to perform nested access and variable scope manipulations
    public fun scope_and_access(s: signer) {
        // Create initial object
        let outer_obj = Outer {
            inner: Inner {
                nested: DeepNested { data: 42, status: true },
                flag: false,
            },
            value: 100,
        };

        // Declare a variable outside the loop
        let outer_value_ref = &mut outer_obj.value;

        // Example variable shadowing: declare variable with same name inside loop
        let shadow_counter = 0;

        // Traverse with while loop
        let i = 0;
        while (i < 3) {
            // Declare a local variable with same name as outside variable for scope test
            let outer_value = &mut outer_obj.value;
            *outer_value = *outer_value + 10 + i;

            // Shadowing variable
            let shadow_counter = shadow_counter + 1;

            // Mutate nested fields via internal function
            update_deep_nested(&mut outer_obj, 123456789 + i as u128, false);

            i = i + 1;
        };

        // After loop, ensure outer_obj.value has been correctly updated
        let result_value = outer_obj.value;

        // Access nested data
        let nested_data = get_deep_data(&outer_obj);

        // Assign to the signer's resource or just to local for test
        let _ = (result_value, nested_data);
    }

    // Internal function with restricted visibility; should be accessible here
    fun internal_test_visibility() {
        let obj = Outer {
            inner: Inner {
                nested: DeepNested { data: 0, status: false },
                flag: false,
            },
            value: 0,
        };

        // Modifying nested fields internally
        update_deep_nested(&mut obj, 55555, true);
        let data = get_deep_data(&obj);
        assert!(data == 55555, 9001);
    }

    // Dummy external function to verify internal invisibility from outside
    public fun external_call_internal() {
        // This line should be valid internally
        internal_test_visibility();
        // The following line should fail to compile if uncommented:
        // update_deep_nested(&mut dummy_obj, 999, false);
    }
}



//# run 0xDEAD::NestedAccessAndScopeTest::scope_and_access --signers 0xBADA


//# run 0xDEAD::NestedAccessAndScopeTest::internal_test_visibility
// This test covers nested field access, scope, variable shadowing, internal function accessibility.


// Featurres:
// 78f8dc464195108ec06049bb15ab9fa2: Access nested fields of expressions using dot notation in Move code.
// 0b62e2b6ef6d21801ee5807769ee6a3e: Test that local variable assignments inside and outside a while loop are handled correctly and that variable shadowing does not affect values across loop iterations.
// 63d45d364eac9afd0006b4525c93f85c: Use 'internal' visibility to restrict access within the module or package.
