
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
            assert!(i == (i), 0);
            // Increment inner i
            let i = i + 1;
        };
        // After loop, outer i remains undefined outside, so no effect to check
    }

    // Script entry point for test 2: nested loops with break/continue and variable updates
    public fun nested_loops_test(signer: signer): () {
        // Initialize and store state
        let state = move_to<TestsState>(&signer);
        // Use a mutable reference to state for updates
        let state_ref: &mut TestsState = borrow_global_mut<TestsState>(signer::address_of(&signer));

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
            state_ref.nested_counter = outer_counter;
        };
        // Final assertion
        assert!(state_ref.nested_counter == 5, 999);
        // Prevent unused variable warning
        move_from<TestsState>(&signer);
    }

    // Script entry point for test 3: check internal functions and access restrictions
    public fun call_internal_functions(s: signer): () {
        internal_function_example();
    }

    // Internal function, only callable within this module
    fun internal_function_example() {
        // does nothing
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

    // Store initial state for tests
    struct TestsState has store {
        nested_counter: u64,
    }

    // Testing function to invoke all above tests
    public fun run_all_tests(s: signer): () {
        shadowing_test(s);
        nested_loops_test(s);
        call_internal_functions(s);
        storage_and_borrow(s);
        // Initialize and store the TestState
        let initial_state = TestsState { nested_counter: 0 };
        move_to<TestsState>(&s, initial_state);
    }
}



//# run 0xCAFE::TestModule::run_all_tests --signers 0xBADD
