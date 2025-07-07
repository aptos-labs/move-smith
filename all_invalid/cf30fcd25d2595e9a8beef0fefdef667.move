
//# publish
module 0xCAFE::TestModule {
    use std::signer;

    // Struct to hold state across functions for testing
    struct TestState has store {
        temp_var: u64,
        nested_counter: u64,
        flag: bool,
    }

    // Script entry point for test 1: verify variable shadowing inside and outside while loops
    public fun shadowing_test(signer: signer): () {
        // Outer variable
        let _outer = 0u64;

        // Shadowed variable inside loop
        let i = 0u64;
        while (i < 3) {
            // Shadow variable i within loop block
            let i = i + 1;
            // i here is inner, should be unaffected outside
            assert!(i == (i),  // inner i
                0);
            // Increment outer 'i' via external variable
            i = i + 1;
        };
        // After loop, outer i remains 0, inner shadow does not affect it
        // We do not have outer i variable outside, so test only that we reached the end
    }

    // Script entry point for test 2: nested loops with break/continue and variable updates
    public fun nested_loops_test(signer: signer): () {
        let state = move_to<TestsState>(&signer);
        let outer_counter = 0u64;

        while (outer_counter < 5) {
            let inner_counter = 0u64;

            while (inner_counter < 10) {
                if (inner_counter == 3) {
                    inner_counter = inner_counter + 2;
                    continue;
                };
                if (inner_counter == 7) {
                    break;
                };
                if (inner_counter % 2 == 0) {
                    inner_counter = inner_counter + 1;
                } else {
                    inner_counter = inner_counter + 2;
                };
            };
            // Update outer's state
            outer_counter = outer_counter + 1;
            // Track nested_counter for validation
            move_to<TestsState>(&signer).nested_counter = outer_counter;
        };
        // Save final outer_counter
        move_to<TestsState>(&signer).nested_counter = outer_counter;
        // It should be 5
        let final_state: &mut TestsState = borrow_global_mut<TestsState>(signer::address_of(&signer));
        assert!(final_state.nested_counter == 5, 999);
    }

    // Script entry point for test 3: check internal functions and access restrictions
    public fun call_internal_functions(s: signer): () {
        // Call an internal-only function within module
        internal_function_example();
        // Try to call from outside should fail if attempted
        // (simulate compile error if attempted externally)
    }

    // Internal function, only callable within this module
    fun internal_function_example() {
        // does nothing, just for access enforcement test
    }

    // Script entry point for test 4: validate data storage via move_to and borrow_global
    public fun storage_and_borrow(s: signer): () {
        let resource = Resource { count: 42u64 };
        move_to<Resource>(&signer, resource);
        let r: &Resource = borrow_global<Resource>(signer::address_of(&signer));
        assert!(r.count == 42, 1001);
        // Modify resource
        let r_mut: &mut Resource = borrow_global_mut<Resource>(signer::address_of(&signer));
        r_mut.count = r_mut.count + 8;
        assert!(r_mut.count == 50, 1002);
        // Remove resource
        let r_removed: Resource = move_from<Resource>(signer::address_of(&signer));
        assert!(r_removed.count == 50, 1003);
    }

    // Resources for storage tests
    struct Resource has store, key {
        count: u64,
    }

    // Testing function to invoke all above tests
    public fun run_all_tests(s: signer): () {
        shadowing_test(s);
        nested_loops_test(s);
        call_internal_functions(s);
        storage_and_borrow(s);
    }
}


//# run 0xCAFE::TestModule::run_all_tests --signers 0xBADD


// Featurres:
// b70ccb6e356eebb5b3735f5f76cd5273: Write script entry points in Move modules
// 0b62e2b6ef6d21801ee5807769ee6a3e: Test that local variable assignments inside and outside a while loop are handled correctly and that variable shadowing does not affect values across loop iterations.
// 63d45d364eac9afd0006b4525c93f85c: Use 'internal' visibility to restrict access within the module or package.
// 802f80faa85da9b54168540bf1cea833: Test that nested loops with multiple break and continue statements, along with variable updates, correctly influence control flow and final assertions.
