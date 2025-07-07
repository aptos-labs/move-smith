
//# publish
module 0xCAFE::InteractionTest {

    use std::signer;
    use std::vector;

    // Resource to keep track of internal invocation counts
    struct Counter has key {
        count: u64,
    }

    // Initialize counter resource under an admin account
    public fun init_counter(s: signer) {
        move_to<Counter>(&s, Counter { count: 0 });
    }

    // Internal function to increment counter
    fun internal_increment(counter_ref: &mut Counter) {
        counter_ref.count = counter_ref.count + 1;
    }

    // Function to expose counter value for testing
    public fun get_counter(s: signer): u64 acquires Counter {
        let counter_ref: &Counter = borrow_global<Counter>(signer::address_of(&s));
        counter_ref.count
    }

    // Public test function that calls internal increment
    public fun call_internal_and_check(s: signer) {
        let counter_ref: &mut Counter = borrow_global_mut<Counter>(signer::address_of(&s));
        internal_increment(counter_ref);
    }

    // Function to simulate variable shadowing and scope within loops
    public fun shadowing_test() {
        let outer_var: u64 = 5;

        let i: u64 = 0;

        // First loop with inner variable shadowing
        while (i < 3) {
            let outer_var = i + 10; // shadowing outer_var
            // Confirm inner scope shadow
            assert!(outer_var == i + 10, 999);
            i = i + 1;
        };

        // After loop, verify outer_var remains unchanged:
        assert!(outer_var == 5, 999);
    }

    // Resource to test internal function access restriction
    struct InternalCapability has key {}

    // Internal function not accessible outside the module
    fun internal_only_function() {
        // Test logic (e.g., increase a counter or set a state)
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


// Featurres:
// b70ccb6e356eebb5b3735f5f76cd5273: Write script entry points in Move modules
// 0b62e2b6ef6d21801ee5807769ee6a3e: Test that local variable assignments inside and outside a while loop are handled correctly and that variable shadowing does not affect values across loop iterations.
// 63d45d364eac9afd0006b4525c93f85c: Use 'internal' visibility to restrict access within the module or package.
// a607f58e072d40e373e7f4e2e5a2acea: Enable compiler warnings for deprecated features or usage in Move and Aptos libraries.
