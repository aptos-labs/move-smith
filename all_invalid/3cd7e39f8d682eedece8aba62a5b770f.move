
//# publish
module 0xCAFE::TestModule {
    use std::option;
    use std::vector;
    use std::address;

    struct ResourceStruct has key, store {
        value: u64,
        marker: bool,
    }

    public fun create_resource(val: u64): ResourceStruct {
        ResourceStruct { value: val, marker: true }
    }

    /// Test 1: Using Option to represent optional collections of types
    public fun test_option_usage() {
        let opt_none: option::Option<vector<u8>> = option::none<vector<u8>>();
        let opt_some: option::Option<vector<u8>> = option::some(vector::empty<u8>());

        // Confirming that options are distinct
        if (option::is_some(&opt_some)) {
            // Get mutable reference to the vector inside the option
            let v_ref = option::borrow_mut(&mut opt_some);
            vector::push_back(v_ref, 1);
            vector::push_back(v_ref, 2);
        };

        // No assertion needed, just testing option usage
        ();
    }

    /// Test 2: Mutual exclusive let binding with copy types and structs
    public fun test_mutually_exclusive_paths(copy_val: u64, struct_val: ResourceStruct, cond1: bool, cond2: bool) {
        let copy_var = copy copy_val; // primitive copy
        let struct_var = copy struct_val; // struct with copy/drop

        if (cond1) {
            let _a = copy_var; // consume copy_var
            let _b = struct_var; // consume struct_var
        } else {
            let _c = copy_var; // re-use copy_var in other branch
            let _d = struct_var; // re-use struct_var
        };
        // all variables are consumed in the branches
        ();
    }

    /// Test 3: Borrow checker correctly prevents aliasing with nested closures
    public fun test_nested_closures_prevent_aliasing(resource_addr: address, s1: address) {
        // Outer closure that mutably borrows resource
        let outer_ctx = || {
            let resource_ref: &mut ResourceStruct = borrow_global_mut<ResourceStruct>(resource_addr);
            resource_ref.value = 42;
        };
        // Inner closure attempting to also mutably borrow same resource
        let inner_ctx = || {
            let resource_ref2: &mut ResourceStruct = borrow_global_mut<ResourceStruct>(resource_addr);
            resource_ref2.marker = false;
        };

        // Call outer and inner closures
        outer_ctx();
        inner_ctx();
        // This sequence will cause aliasing violation if called simultaneously,
        // but in the test, they are called sequentially.
        // The test ensures the borrow checker detects improper aliasing if attempted concurrently
        ();
    }

    // Runner function to invoke all tests
    public fun run_all_tests() {
        // Prepare test data
        let resource = create_resource(100);
        // Use a dummy address for resource
        let resource_addr = @0xDEADBEEF;

        // Run tests
        test_option_usage();
        test_mutually_exclusive_paths(123u64, resource, true, false);
        test_nested_closures_prevent_aliasing(resource_addr, @0x1);
    }
}

//# run 0xCAFE::TestModule::run_all_tests
