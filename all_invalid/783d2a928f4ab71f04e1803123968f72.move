
//# publish
module 0xCAFE::TestModule {
    use std::signer;

    // Internal resource for testing internal visibility
    struct InternalCounter has key {
        count: u64,
    }

    // Public resource for external state checking
    struct PublicState has key {
        value: u64,
    }

    // Internal function to increment counter
    fun internal_increment(counter: &mut InternalCounter) {
        counter.count = counter.count + 1;
    }

    // Public function to initialize resource
    public fun init_counter(s: &signer) {
        move_to<InternalCounter>(s, InternalCounter { count: 0 });
        move_to<PublicState>(s, PublicState { value: 0 });
    }

    // Internal function to get count
    fun get_counter(s: &signer): &InternalCounter {
        borrow_global<InternalCounter>(signer::address_of(s))
    }

    // Public function to perform multiple internal increments
    public fun perform_increments(s: &signer, times: u64) {
        let counter_ref = borrow_global_mut<InternalCounter>(signer::address_of(s));
        let i = 0;
        while (i < times) {
            internal_increment(&mut counter_ref);
            i = i + 1;
        };
    }

    // Public function that shadows local variable
    public fun shadow_variable(s: &signer, initial_value: u64): u64 {
        let value = initial_value;
        let value_shadow = value + 10; // shadowing outer variable
        // Loop to modify value
        let j = 0;
        while (j < 3) {
            value = value + j;
            j = j + 1;
        };
        // The shadowed variable should not affect outer 'value'
        value_shadow
    }

    // Public function to read and modify resource
    public fun update_public_state(s: &signer, new_value: u64) {
        let state_ref = borrow_global_mut<PublicState>(signer::address_of(s));
        state_ref.value = new_value;
    }

    // Internal function to simulate non-native operation
    fun internal_add(a: u64, b: u64): u64 {
        a + b
    }

    // Public wrapper for internal_add
    public fun call_internal_add(a: u64, b: u64): u64 {
        internal_add(a, b)
    }

    // Entry point script functions
    public fun script_initialize(s: &signer) {
        init_counter(s);
    }

    public fun script_perform_and_check(s: &signer, times: u64): u64 {
        perform_increments(s, times);
        get_counter(s).count
    }

    public fun script_shadow_test(s: &signer, initial_value: u64): u64 {
        shadow_variable(s, initial_value)
    }

    public fun script_update_state(s: &signer, val: u64) {
        update_public_state(s, val);
    }

    public fun script_addition(a: u64, b: u64): u64 {
        call_internal_add(a, b)
    }
}



//# run 0xCAFE::TestModule::script_initialize --signers 0xBADD



//# run 0xCAFE::TestModule::script_perform_and_check --signers 0xBADD --args 5u64



//# run 0xCAFE::TestModule::script_shadow_test --signers 0xBADD --args 42u64



//# run 0xCAFE::TestModule::script_update_state --signers 0xBADD --args 999u64



//# run 0xCAFE::TestModule::script_addition --args 123u64 456u64
