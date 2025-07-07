
//# publish
module 0xCAFE::InteractionTest {

    use std::signer;

    // Resource to keep track of internal invocation counts
    struct Counter has key {
        count: u64,
    }

    // Initialize counter resource under an admin account
    public fun init_counter(s: &signer) {
        move_to<Counter>(s, Counter { count: 0 });
    }

    // Internal function to increment counter
    fun internal_increment(counter_ref: &mut Counter) {
        counter_ref.count = counter_ref.count + 1;
    }

    // Function to expose counter value for testing
    public fun get_counter(s: &signer): u64 acquires Counter {
        let counter_ref: &Counter = borrow_global<Counter>(signer::address_of(s));
        counter_ref.count
    }

    // Public test function that calls internal increment
    public fun call_internal_and_check(s: &signer) {
        let counter_ref: &mut Counter = borrow_global_mut<Counter>(signer::address_of(s));
        internal_increment(counter_ref);
    }

    // Function to simulate variable shadowing and scope within loops
    public fun shadowing_test() {
        let outer_var: u64 = 5;

        let i: u64 = 0;

        // First loop with inner variable shadowing
        while (i < 3) {
            let inner_outer_var = i + 10; // shadowing outer_var (not used further)
            // Confirm inner scope shadow
            assert!(inner_outer_var == i + 10, 999);
            i = i + 1;
        };

        // After loop, verify outer_var remains unchanged:
        assert!(outer_var == 5, 999);
    }

    // Resource to test internal function access restriction
    struct InternalCapability has key {}

    // Internal function not accessible outside the module
    fun internal_only_function() {
        // test logic
    }

    // Public wrapper to test internal function
    public fun call_internal_only() {
        internal_only_function()
    }

    // Internal function with variable declaration
    fun internal_variable_scope() {
        let local_var: u8 = 42;
        // Do something internally
        assert!(local_var == 42, 998);
    }

    // Expose a public function that calls internal internal_variable_scope
    public fun invoke_internal_vars() {
        internal_variable_scope()
    }
}



//# run 0xCAFE::InteractionTest::init_counter --signers 0xBADD



//# run 0xCAFE::InteractionTest::call_internal_and_check --signers 0xBADD



//# run 0xCAFE::InteractionTest::get_counter --signers 0xBADD



//# run 0xCAFE::InteractionTest::shadowing_test



//# run 0xCAFE::InteractionTest::call_internal_only --signers 0xBADD



//# run 0xCAFE::InteractionTest::invoke_internal_vars --signers 0xBADD
