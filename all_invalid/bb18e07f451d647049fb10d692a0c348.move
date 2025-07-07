//# publish
module 0xABC::test_module {

    /// Declare a struct to be used in some functions
    struct TestStruct has copy, drop, store {
        value: u64,
    }

    /// Initialize a resource with a u64 value
    public fun init_resource(account: &signer, init_value: u64) {
        let resource = TestStruct { value: init_value };
        move_to(account, resource);
    }

    /// A function that updates a resource and declares local variables with post state
    public fun update_and_check(account: &signer) {
        // Load the resource
        let res_ref = borrow_global_mut<TestStruct>(.signer_address_of(account));

        // Declare local variable 'old_value' with post state after assignment
        let old_value: u64;
        old_value = res_ref.value;

        // Modify the resource
        res_ref.value = old_value + 10;

        // Declare another local variable with post state, for demonstration
        let new_value: u64;
        new_value = res_ref.value;

        // Assert that the value has increased
        assert new_value > old_value, 42;

        // Declare a local variable without post, just for declaration
        let temp = 123u64;

        // For further testing, modify the resource again
        res_ref.value = new_value + 5;
    }

    /// Declare an invariant on the resource with 'update' keyword
    public fun resource_invariant(res: &TestStruct) update {
        // Invariant: value always >= 0
        assert res.value >= 0, 100;
    }

    /// A test function to run the above logic
    public fun run_tests() {
        // No parameters, used for integration testing
    }
}

//# run 0xABC::test_module::run_tests --signers 0xABC